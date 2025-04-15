import { defineConfig } from "vitepress";

// https://vitepress.dev/reference/site-config
export default defineConfig({
  title: "Fernwärts",
  description: "Documentation for the open source Fernwärts app",
  base: "/fernwaerts",
  head: [
    ["link", {
      rel: "icon",
      type: "image/x-icon",
      href: "/fernwaerts/assets/favicon.ico",
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
      { icon: "github", link: "https://github.com/ton-An/fernwaerts" },
    ],
  },
});
