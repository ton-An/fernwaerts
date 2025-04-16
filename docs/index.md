---
# https://vitepress.dev/reference/default-theme-home-page
layout: home

hero:
  name: Fernwärts
  text: Privacy-Focused Location Tracker
  tagline: Your Journey, Your Data – Open, Private, Yours.
  image: 
    src: /assets/app_icon_transparent_new.png
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
    title: Open Codebase*
    details: This app has an open codebase. You’re welcome to contribute to its development! :) <br><br><span style="color:var(--vp-c-text-3)">* Due to the dual license model, this app is (by the OSI definition) not open source</span>
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
            
      {   
        icon: {
          svg: '<svg xmlns="http://www.w3.org/2000/svg" version="1.1" viewBox="0 0 24 24"> <defs></defs> <path class="st0" d="M12,24c-1.64,0-3.19-.31-4.65-.94s-2.74-1.49-3.82-2.58-1.95-2.37-2.58-3.83-.94-3.01-.94-4.65.31-3.22.94-4.66,1.49-2.72,2.58-3.81,2.37-1.95,3.82-2.58,3.01-.94,4.65-.94,3.22.31,4.67.94,2.72,1.49,3.81,2.58,1.95,2.36,2.58,3.81.94,3.01.94,4.66-.31,3.19-.94,4.65-1.49,2.74-2.58,3.83-2.36,1.95-3.81,2.58-3.01.94-4.67.94ZM12,21.54c.52-.72.97-1.47,1.35-2.25s.69-1.61.93-2.49h-4.56c.24.88.55,1.71.93,2.49s.83,1.53,1.35,2.25ZM8.88,21.06c-.36-.66-.68-1.34-.94-2.06-.27-.71-.5-1.44-.68-2.21h-3.54c.58,1,1.31,1.87,2.18,2.61.87.74,1.86,1.29,2.98,1.65ZM15.12,21.06c1.12-.36,2.11-.91,2.98-1.65.87-.74,1.6-1.61,2.18-2.61h-3.54c-.18.76-.4,1.5-.67,2.21-.27.71-.59,1.39-.94,2.06ZM2.7,14.4h4.08c-.06-.4-.11-.8-.13-1.18s-.05-.8-.05-1.22.02-.82.05-1.21.07-.79.13-1.18H2.7c-.1.4-.17.8-.23,1.18s-.08.8-.08,1.21.02.83.08,1.22.13.78.23,1.18ZM9.18,14.4h5.64c.06-.4.1-.8.13-1.18s.05-.8.05-1.22-.01-.82-.05-1.21-.08-.79-.13-1.18h-5.64c-.06.4-.11.8-.14,1.18s-.05.8-.05,1.21.02.83.05,1.22.07.78.14,1.18ZM17.22,14.4h4.08c.1-.4.17-.8.23-1.18s.07-.8.07-1.22-.02-.82-.07-1.21-.13-.79-.23-1.18h-4.08c.06.4.11.8.14,1.18s.04.8.04,1.21-.01.83-.04,1.22-.08.78-.14,1.18ZM16.74,7.2h3.54c-.58-1-1.31-1.87-2.18-2.61s-1.87-1.29-2.98-1.65c.36.66.68,1.34.94,2.05s.49,1.45.67,2.2ZM9.72,7.2h4.56c-.24-.88-.55-1.71-.93-2.49s-.83-1.53-1.35-2.25c-.52.72-.97,1.47-1.35,2.25s-.69,1.61-.93,2.49ZM3.72,7.2h3.54c.18-.76.4-1.49.68-2.2s.58-1.39.94-2.05c-1.12.36-2.12.91-2.98,1.65s-1.6,1.61-2.18,2.61Z"/> </svg>'
        }, link: 'https://antons-webfabrik.eu'}
    ]
  },
]
</script>
<VPTeamMembers size="small" :members="members" />
