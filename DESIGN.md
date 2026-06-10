---
name: Fernwaerts
description: Privacy-focused, self-hosted location history with an open, playful, app-led public identity.
colors:
  fern-green: "#23AE54"
  fern-green-app: "#53C46C"
  fern-green-accent: "#23C35B"
  trail-yellow: "#EDBB32"
  trail-yellow-accent: "#F8CB4F"
  map-light-surface: "#FFFFFF"
  ink: "#111827"
  ink-muted: "#4B5563"
  night-surface: "#111111"
  white: "#FFFFFF"
  black: "#000000"
typography:
  display:
    fontFamily: "Inter, system-ui, sans-serif"
    fontSize: "3rem"
    fontWeight: 700
    lineHeight: 1.1
    letterSpacing: "0"
  headline:
    fontFamily: "Inter, system-ui, sans-serif"
    fontSize: "2.25rem"
    fontWeight: 700
    lineHeight: 1.15
    letterSpacing: "0"
  title:
    fontFamily: "Inter, system-ui, sans-serif"
    fontSize: "1.875rem"
    fontWeight: 700
    lineHeight: 1.2
    letterSpacing: "0"
  body:
    fontFamily: "Inter, system-ui, sans-serif"
    fontSize: "1rem"
    fontWeight: 400
    lineHeight: 1.7
    letterSpacing: "0"
  label:
    fontFamily: "Inter, system-ui, sans-serif"
    fontSize: "0.875rem"
    fontWeight: 500
    lineHeight: 1.4
    letterSpacing: "0"
rounded:
  sm: "8px"
  md: "12px"
  lg: "16px"
  panel: "24px"
spacing:
  xs: "4px"
  sm: "8px"
  md: "16px"
  lg: "24px"
  xl: "48px"
components:
  button-primary:
    backgroundColor: "{colors.fern-green}"
    textColor: "{colors.white}"
    rounded: "{rounded.md}"
    padding: "12px 24px"
  button-primary-hover:
    backgroundColor: "{colors.fern-green-accent}"
    textColor: "{colors.white}"
    rounded: "{rounded.md}"
    padding: "12px 24px"
  button-secondary:
    backgroundColor: "{colors.trail-yellow}"
    textColor: "{colors.white}"
    rounded: "{rounded.md}"
    padding: "12px 24px"
  panel-translucent:
    backgroundColor: "{colors.map-light-surface}"
    textColor: "{colors.ink}"
    rounded: "{rounded.panel}"
    padding: "16px 48px"
---

# Design System: Fernwaerts

## 1. Overview

**Creative North Star: "Pocket Atlas"**

Fernwaerts should feel like a personal atlas that happens to be technically
serious: map-led, tactile, self-owned, and lightly playful. The public homepage
and docs borrow from the Flutter app's translucent panels, green location
signals, rounded bottom sheets, and timeline/map imagery, rather than becoming a
generic marketing layer over the product.

The system is app-led brand design. It can use motion, video, screenshots, and
spatial composition, but it must keep privacy and setup language direct. The
visual tone should be open, fun, and private: friendly enough for personal
memories, restrained enough for sensitive location data.

This system explicitly rejects crypto or web3 aesthetics and generic SaaS
landing-page grammar. Avoid surveillance dashboards, investor-deck metrics,
growth analytics cues, and template feature-card grids.

**Key Characteristics:**
- Map and journey imagery lead whenever possible.
- Soft green is the continuity color between app, homepage, and docs.
- Translucent panels are allowed when they feel app-native, not decorative.
- Copy should prove data ownership through concrete setup and product states.
- Playful details should never obscure authentication, hosting, or sync behavior.

## 2. Colors

The palette is a bright location-history system: fresh green for ownership and
movement, yellow for warmth and wayfinding, neutral ink for trustworthy docs.

### Primary
- **Fern Green** (#23AE54): The public-site primary from `docs/app/global.css`.
  Use for brand marks, primary CTAs, links, active docs states, map accents, and
  signature strokes.
- **App Fern Green** (#53C46C): The Flutter app primary from
  `app/lib/main.dart`. Use when pulling the homepage closer to the app UI or
  rendering app-state-inspired surfaces.
- **Fresh Fern Hover** (#23C35B): Hover and active emphasis for primary web
  controls. Keep it in the same role family as Fern Green.

### Secondary
- **Trail Yellow** (#EDBB32): Secondary CTA and wayfinding accent. It should
  feel like a highlight on a route, not a finance or warning color.
- **Sunlit Trail Hover** (#F8CB4F): Hover treatment for secondary controls and
  small interaction highlights.

### Neutral
- **Map Light Surface** (#FFFFFF): Base for docs and translucent homepage
  panels. When used as `bg-white/60`, place it over meaningful imagery or map
  context.
- **Ink** (#111827): Primary text color for readable long-form docs and dense
  setup steps.
- **Muted Ink** (#4B5563): Secondary prose, labels, and descriptions. Verify
  contrast before placing it on tinted or translucent backgrounds.
- **Night Surface** (#111111): Dark-mode surface reference. Use sparingly and
  keep green/yellow accents readable against it.

### Named Rules

**The App Continuity Rule.** When designing the homepage, pull color from the
app first: green location signals, translucent panels, and map/timeline
materials. Do not introduce unrelated blues, purples, crypto-neons, or generic
SaaS gradients.

**The Privacy Contrast Rule.** Privacy, setup, auth, and self-hosting copy must
use body text colors that clearly pass contrast. Do not use pale gray text for
trust-critical explanations.

## 3. Typography

**Display Font:** Inter (local `docs/app/fonts/inter.ttf`, with system fallback)
**Body Font:** Inter (local `docs/app/fonts/inter.ttf`, with system fallback)
**Label/Mono Font:** none

**Character:** The current system uses one family across app-adjacent brand and
docs surfaces. Inter is a reflex font in greenfield branding, but here it is
already committed in the docs app and should be preserved until there is a
deliberate typography migration.

### Hierarchy
- **Display** (700, 3rem / `text-5xl`, 1.1): Product name and first-viewport
  homepage claims only. Use balanced line breaks and avoid negative tracking.
- **Headline** (700, 2.25rem, 1.15): Major homepage sections and docs landing
  headings.
- **Title** (700, 1.875rem / `text-3xl`, 1.2): Feature names, panel headings,
  and card titles when cards are genuinely needed.
- **Body** (400, 1rem-1.25rem, 1.7): Public copy and docs prose. Keep long docs
  lines near 65-75 characters.
- **Label** (500, 0.875rem, 1.4): Navigation, attribution, small controls, and
  metadata. Do not make repeated all-caps section eyebrows the default cadence.

### Named Rules

**The Plainspoken Privacy Rule.** Type hierarchy should make setup, ownership,
and data-flow statements easy to scan. Avoid performative technical labels when
plain language would be clearer.

## 4. Elevation

Fernwaerts currently uses a hybrid of tonal layering, blur, and occasional
shadow. In the app, depth comes from blurred translucent sheets and rounded
modal surfaces. On the homepage, `shadow-2xl` and `backdrop-blur-2xl` appear on
hero panels and attribution, but future work should use those effects as an
app-native material reference, not as default glassmorphism decoration.

### Shadow Vocabulary
- **App Sheet Blur** (`backdrop-filter: blur(18px)`): From the Flutter theme's
  `ImageFilter.blur(sigmaX: 18, sigmaY: 18)`. Use for bottom sheets, settings
  panels, and map overlays.
- **Homepage Atmosphere** (`backdrop-blur-2xl`): Web equivalent for panels over
  video or map imagery. Pair with translucent fill only when the background is
  meaningful.
- **Small Structural Lift** (`box-shadow` no heavier than an 8px blur): Use for
  interactive surfaces when a border is absent. Avoid pairing a decorative
  border with a wide soft shadow.
- **Marker Shadow** (`Colors.black` at 22% opacity, elevation 2): App map
  markers use a tight shadow to separate route points from the map.

### Named Rules

**The No Decorative Glass Rule.** Blurred translucent surfaces are allowed when
they echo the app's map sheets or protect legibility over imagery. They should
not become a generic frosted-card style across every section.

## 5. Components

### Buttons
- **Shape:** Rounded rectangle, 12px on the web (`rounded-xl`) and small app
  radii for inline buttons.
- **Primary:** Fern Green background with white text, `12px 24px` padding on
  the homepage. Use for the main product action.
- **Hover / Focus:** Shift to Fresh Fern Hover and keep a visible green focus
  ring. Transitions should be short and color-only unless motion adds meaning.
- **Secondary:** Trail Yellow background with white text for lower-priority
  actions. Do not let yellow become the primary brand color.
- **Inline App Button:** The Flutter `SmallTextButton` uses subtle press
  feedback with `backgroundContrast` at 8% alpha and a short fade. Use this
  pattern for quiet secondary actions in app-like docs examples.

### Cards / Containers
- **Corner Style:** App panels use medium to x-large radii; web panels currently
  use 24px (`rounded-3xl`). New cards should usually stay at 12-16px unless
  they are deliberately mimicking a modal sheet.
- **Background:** White translucent fills over video/map material, or solid
  docs surfaces for readability.
- **Shadow Strategy:** Prefer tonal/blurred layering over large decorative
  shadows. If using a shadow, do not combine it with a decorative 1px border.
- **Internal Padding:** Compact app controls use 8-16px; homepage hero panels
  can use 24-48px if the layout stays responsive.

### Inputs / Fields
- **Style:** Inputs should inherit the app's quiet, rounded, translucent field
  language where possible.
- **Focus:** Use Fern Green as the focus signal and keep labels legible.
- **Error / Disabled:** Use the app theme's error color for destructive or
  invalid states; keep privacy-sensitive failure text direct and non-alarming.

### Navigation
- **Style:** Fumadocs provides the docs navigation shell. Preserve its readable
  density and use the app icon plus Fernwaerts wordmark as the consistent brand
  anchor.
- **States:** Active and hover states should use Fern Green. Avoid yellow for
  active docs navigation unless it is a transient accent.
- **Mobile:** Keep navigation predictable and docs-first. The homepage can be
  expressive, but docs navigation should stay utilitarian.

### Map And Timeline Materials

Maps, route lines, place markers, calendar states, and location-history bottom
sheets are signature components. Use them as the source for homepage visuals:
real screenshots, map movement, timeline gradients, route markers, and
app-inspired panels are stronger than abstract icon cards.

## 6. Do's and Don'ts

### Do:
- **Do** base homepage redesigns on the Flutter app's map, calendar, modal, and
  translucent-sheet language.
- **Do** use Fern Green (#23AE54) as the public primary and App Fern Green
  (#53C46C) when the surface needs to feel closer to the app.
- **Do** use Trail Yellow (#EDBB32) as a secondary wayfinding accent, not as a
  finance, warning, or crypto signal.
- **Do** show concrete product states: screenshots, maps, docs steps, sync
  boundaries, and self-hosting setup.
- **Do** keep privacy and setup copy high contrast, direct, and free of vague
  reassurance.
- **Do** provide reduced-motion alternatives for video, globe, signature, and
  reveal animations.

### Don't:
- **Don't** make Fernwaerts feel like a crypto or web3 app.
- **Don't** make the homepage look like a generic SaaS landing page.
- **Don't** imply surveillance, growth analytics, enterprise monitoring, or
  investor-dashboard metrics.
- **Don't** use gradient text, repeated tiny uppercase section eyebrows, or a
  grid of identical icon cards as the default homepage structure.
- **Don't** use glassmorphism as decoration. Blur is for app-like map sheets and
  legibility over real imagery.
- **Don't** over-round normal cards beyond 16px unless the component is
  intentionally a modal sheet or hero overlay.
- **Don't** log or display real location data, tokens, credentials, server keys,
  or device IDs in examples, screenshots, or public docs.
