import { defineConfig } from "vitepress";

// https://vitepress.dev/reference/site-config
export default defineConfig({
  title: "Location History",
  description: "Documentation for the open source Location History app",
  base: "/location_history",
  head: [
    ["link", {
      rel: "icon",
      type: "image/x-icon",
      href: "/location_history/assets/favicon.ico",
    }],
  ],
  themeConfig: {
    nav: [
      { text: "Home", link: "/" },
      { text: "Examples", link: "/markdown-examples" },
    ],
    search: {
      provider: "local",
      options: { detailedView: true },
    },
    sidebar: [
      {
        text: "Examples",
        items: [
          { text: "Markdown Examples", link: "/markdown-examples" },
          { text: "Runtime API Examples", link: "/api-examples" },
        ],
      },
    ],

    socialLinks: [
      { icon: "github", link: "https://github.com/ton-An/location_history" },
    ],
  },
});
