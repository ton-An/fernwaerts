---
# https://vitepress.dev/reference/default-theme-home-page
layout: home

hero:
  name: Fernwärts
  text: Privacy-Focused Location Tracker
  tagline: Your Journey, Your Data – Open, Private, Yours.
  image: 
    src: /assets/app_icon_transparent.png
  actions:
    - theme: brand
      text: Markdown Examples
      link: /markdown-examples
    - theme: alt
      text: API Examples
      link: /api-examples

features:
  - icon: 🔒
    title: Private
    details: Your data is yours and only yours. Wether you use the app local-only or self-hosted, your information remains under your control.
  - icon: 📍
    title: Smart Location Insights
    details: Automatically categorize your visits by place, city, and country—creating a meaningful timeline of your travels.
  - icon: 🌐
    title: Open Source
    details: This app is open-source. You’re welcome to contribute to its development! :)
---

::: warning
The project and the documentation are still in early stages, so expect some rough edges. Thanks for your patience 😘
:::

---
<pre>

</pre>
# Team
<script setup>
import { VPTeamMembers } from 'vitepress/theme'

const members = [
  {
    avatar: 'https://avatars.githubusercontent.com/u/25333824?v=4',
    name: 'Anton Heuchert',
    title: 'Developer/Creator',
    sponsor: 'https://github.com/sponsors/ton-An',
    links: [
      { icon: 'github', link: 'https://github.com/ton-An' },
    ]
  },
]
</script>
<VPTeamMembers size="small" :members="members" />

