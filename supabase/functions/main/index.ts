// @ts-ignore
import { STATUS_CODE } from "https://deno.land/std/http/status.ts";
import { head } from "npm:@supabase/storage-js@2.7.1";

console.log("main function started");
console.log(Deno.version);

addEventListener("beforeunload", () => {
  console.log("main worker exiting");
});

// log system memory usage every 30s
setInterval(() => console.log(EdgeRuntime.systemMemoryInfo()), 30 * 1000);

// cleanup unused sessions every 30s
setInterval(async () => {
  try {
    const cleanupCount = await EdgeRuntime.ai.tryCleanupUnusedSession();
    if (cleanupCount == 0) {
      return;
    }
    console.log("EdgeRuntime.ai.tryCleanupUnusedSession", cleanupCount);
  } catch (e) {
    console.error(e.toString());
  }
}, 30 * 1000);

Deno.serve(async (req: Request) => {
  const headers = new Headers({
    "Content-Type": "application/json",
  });

  const url = new URL(req.url);
  const { pathname: pathName } = url;

  if (pathName === "/health") {
    return new Response(
      null,
      { status: 200 },
    );
  }

  const pathParts = pathName.split("/");
  const functionName = pathParts[1];

  if (!functionName || functionName === "") {
    return new Response(
      JSON.stringify({
        error: { "code": "missing_function_name" },
      }),
      {
        status: 400,
        headers: headers,
      },
    );
  }

  const functionPath = `/home/deno/functions/${functionName}`;
  console.log(`serving the request with ${functionPath}`);

  const createWorker = async () => {
    const memoryLimitMb = 150;
    const workerTimeoutMs = 5 * 60 * 1000;
    const noModuleCache = false;

    const envVarsObj = Deno.env.toObject();
    const envVars = Object.keys(envVarsObj).map((k) => [k, envVarsObj[k]]);
    const forceCreate = false;

    const cpuTimeSoftLimitMs = 10000;
    const cpuTimeHardLimitMs = 20000;

    return await EdgeRuntime.userWorkers.create({
      servicePath: functionPath,
      memoryLimitMb,
      workerTimeoutMs,
      noModuleCache,
      envVars,
      forceCreate,
      cpuTimeSoftLimitMs,
      cpuTimeHardLimitMs,
    });
  };

  const callWorker = async () => {
    try {
      const worker = await createWorker();
      const controller = new AbortController();

      const signal = controller.signal;

      return await worker.fetch(req, { signal });
    } catch (exception) {
      console.error(exception);

      return new Response(null, {
        status: 500,
        headers,
      });
    }
  };

  return callWorker();
});
