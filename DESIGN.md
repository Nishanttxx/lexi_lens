# Lexi Lens — Design System

## Context and Goals
Lexi Lens turns a photo of printed text into a calm, fully adjustable reading and listening experience for dyslexic users. The interface itself has to demonstrate good accessible design — generous spacing, warm low-glare color, a legible typeface, and reading controls that are never hidden — because the people using it are the people most affected when an interface gets legibility wrong. This document defines the tokens and component rules needed to build that interface consistently, on web first and on a native mobile app later.

---

## Design Tokens and Foundations

### Typography
Two separate type systems exist on purpose: **UI chrome** (navigation, buttons, labels — fixed, designer-controlled) and the **reading surface** (the extracted text itself — user-controlled, because the whole point of the product is letting the reader change it).

| Token | Value | Used for |
|---|---|---|
| `font.family.ui` | Atkinson Hyperlegible | All chrome: nav, buttons, labels, forms, toasts |
| `font.family.reading.default` | OpenDyslexic | Default reading-surface font |
| `font.family.reading.alt` | Atkinson Hyperlegible | Alternate reading-surface font (toggle) |
| `font.size.xs` | 13px | Helper text, timestamps |
| `font.size.sm` | 15px | Secondary labels |
| `font.size.md` | 17px | Base UI text, body copy in chrome |
| `font.size.lg` | 19px | Emphasized UI text |
| `font.size.xl` | 22px | Section headings |
| `font.size.2xl` | 26px | Page titles |
| `font.size.3xl` | 32px | Landing hero |
| `font.size.4xl` | 40px | Landing hero (large viewport) |
| `line-height.ui` | 1.4 | UI chrome |
| `line-height.reading.default` | 1.6 | Reading surface — **must never go below 1.5**, even at the user's minimum spacing setting |
| `letter-spacing.ui` | 0 | UI chrome |
| `letter-spacing.reading.default` | 0.04em | Reading surface default — user-adjustable 0–0.12em |

**Reading-surface scale is independent and user-controlled**: font size 14–32px, line spacing 1.5–2.2, letter spacing 0–0.12em, font family toggle (OpenDyslexic / Atkinson Hyperlegible). These are exposed via `DisplaySettingsPanel` (see below) — they are the product's core feature, not a settings-page afterthought.

### Color
Warm and reduced-glare rather than stark white/black — pure white backgrounds and pure black text both increase visual "buzzing" that many dyslexic readers report.

| Token | Value | Notes |
|---|---|---|
| `color.bg.canvas` | `#FBF6EE` | App background — warm ivory, not white |
| `color.bg.surface` | `#FFFFFF` | Cards/panels sitting on the canvas |
| `color.bg.surface-muted` | `#F1E9DA` | Secondary panels, input backgrounds |
| `color.text.primary` | `#211D1A` | Soft warm charcoal — **not** pure black |
| `color.text.secondary` | `#5B5349` | Secondary/help text |
| `color.text.inverse` | `#FBF6EE` | Text on filled accent surfaces |
| `color.accent.primary` | `#2B6E63` | Deep moss teal — primary actions, links |
| `color.accent.primary-hover` | `#235A51` | Hover/active shade of primary |
| `color.accent.warm` | `#E8833B` | Warm amber — reserved for the TTS "currently reading" highlight and active-listening state, so it always means "audio is here" |
| `color.border.default` | `#DCD2C0` | Default borders/dividers |
| `color.border.strong` | `#B8AA8E` | Emphasized borders, input focus rest state |
| `color.state.success` | `#2F7A4D` | Confirmations (e.g. "Settings saved") |
| `color.state.error` | `#B3412B` | Errors — always paired with an icon and text, never color alone |
| `color.state.focus` | `#1D4E8F` | Focus ring — deliberately a different hue from the accent so focus is never mistaken for a hover/selected state |

**Reading overlay tints** (a classic low-vision/dyslexia reading aid — a tinted "page" behind the text, user-selectable, default off):

| Token | Value |
|---|---|
| `overlay.none` | transparent |
| `overlay.cream` | `#FFF6D9` |
| `overlay.blue` | `#E4F0F6` |
| `overlay.rose` | `#FBE7E4` |
| `overlay.mint` | `#E4F3EA` |

**Contrast rule:** `color.text.primary` on `color.bg.canvas` and on every `overlay.*` token must measure **7:1 or higher** (AAA), not just the 4.5:1 AA minimum — this is checked whenever a new overlay tint is added.

### Spacing
8px-based, generous. This audience benefits from uncluttered layouts and larger tap targets, so err toward more space, not less.

`space.1=4px` · `space.2=8px` · `space.3=12px` · `space.4=16px` · `space.5=24px` · `space.6=32px` · `space.7=48px` · `space.8=64px`

### Radius, Shadow, Motion

- `radius.sm=8px`, `radius.md=14px`, `radius.lg=22px`, `radius.pill=999px` — soft, rounded shapes throughout; no sharp/brutalist corners. Softness reads as calm and non-clinical, which matters for an audience that has often had a frustrating relationship with text.
- `shadow.1=0 1px 2px rgba(33,29,26,0.06)`, `shadow.2=0 4px 12px rgba(33,29,26,0.08)`, `shadow.3=0 8px 24px rgba(33,29,26,0.10)` — shadows stay soft and shallow; nothing should look like it's aggressively floating.
- `motion.duration.instant=100ms`, `motion.duration.fast=160ms`, `motion.duration.normal=240ms` — short by design. **No parallax, no auto-playing motion, no sliding/animated word-highlight** (the TTS highlight is a simple background-color swap, not a moving element). All motion must respect `prefers-reduced-motion: reduce` by collapsing to an instant state change.

### Touch & Pointer Targets
Minimum 44×44px for every interactive element, on web and mobile alike — camera/upload controls in particular are often used one-handed, mid-motion, by someone juggling a physical book or worksheet.

---

## Component-Level Rules

### Button
- **Anatomy:** label (sentence case, verb-first — "Scan text", not "Text scanning"), optional leading icon, container.
- **Variants:** primary (filled, `color.accent.primary`), secondary (outlined, `color.border.strong`), destructive (filled, `color.state.error`), for actions like "Delete document".
- **States:** default; hover (`color.accent.primary-hover` / border darken); focus-visible (2px `color.state.focus` ring, 2px offset — must be visible on both `color.bg.canvas` and `color.bg.surface`); active (slight scale/opacity shift, ≤100ms); disabled (reduced opacity, `cursor: not-allowed`, never the only signal — pair with a reason if the disable isn't obvious, e.g. "Log in to save"); loading (inline spinner replaces label, label announced via `aria-live` for screen readers); error (not a button state per se — errors surface via the form/field or a banner, not the button itself).
- **Responsive/edge cases:** buttons never truncate their label — if space is tight, wrap the label onto a second line rather than ellipsis, since ellipsis on an action label is an accessibility anti-pattern for this audience.
- **Accessibility acceptance criteria:** every button has a visible text label or an `aria-label` describing the action, not just an icon; hit area ≥44×44px even when the visual button is smaller; keyboard `Enter`/`Space` activates; loading state is announced, not just visual.

### Input / Form Field (used in Auth, Settings)
- **Anatomy:** visible label (never placeholder-only), input, optional helper text, optional error text.
- **States:** default; hover; focus-visible (border switches to `color.state.focus`, plus ring); filled; disabled; error (border `color.state.error`, error text below field, `aria-describedby` linking them, `aria-invalid="true"`).
- **Responsive/edge cases:** long email addresses or error messages wrap, never scroll horizontally inside the field.
- **Accessibility acceptance criteria:** label is programmatically associated (`<label for>` or `aria-labelledby`); error text is announced on submit via `aria-live="polite"`; password fields have a visible show/hide toggle (memorizing a hidden password is disproportionately hard for some dyslexic users).

### DisplaySettingsPanel (font, size, spacing, overlay, TTS speed controls)
- **Anatomy:** grouped controls — font family toggle (segmented control), font size (slider + numeric readout), line spacing (slider), letter spacing (slider), overlay color (swatch picker, `overlay.*` tokens), TTS speed (slider). A live preview of `DyslexiaTextRenderer` sits alongside or above the panel so every change is seen immediately.
- **States:** default; each slider/toggle has its own focus-visible state; a "Save as default" action has its own loading/success/error states (see Button); "Reset to defaults" is always present and undoable.
- **Responsive/edge cases:** on narrow viewports, the live preview stacks above the controls rather than disappearing — the user must never lose sight of what a change does. Panel must be fully usable without a mouse (arrow keys adjust sliders).
- **Accessibility acceptance criteria:** every slider exposes its current value via `aria-valuenow`/`aria-valuetext` (e.g. "18 pixels", "1.6 line spacing") so screen reader users get the same feedback sighted users get visually; swatch picker options have accessible names ("Cream overlay", "Blue overlay"), not color-only identification.

### DyslexiaTextRenderer (the reading surface itself)
- **Anatomy:** the extracted/processed text, rendered using the current reading-surface tokens (font, size, spacing, overlay background).
- **States:** normal; "currently reading" (word or sentence gets `color.accent.warm` background while TTS plays); empty (no text yet — see EmptyState); long-content (very long OCR output paginates or scrolls, never gets truncated/cut off silently).
- **Responsive/edge cases:** never justify text (ragged-right only — justified text creates uneven word spacing that's specifically harder for dyslexic readers); never render body text in all-caps; low-confidence OCR words are visually flagged (e.g. subtle underline) rather than silently presented as certain.
- **Accessibility acceptance criteria:** text remains selectable/copyable; zooming the browser to 200% doesn't clip or overlap content; the "currently reading" highlight has ≥3:1 contrast against both the text and the surrounding background.

### TTSPlayer
- **Anatomy:** play/pause, seek/scrub, speed control (ties to the same `tts_speed` token as DisplaySettingsPanel), current position indicator.
- **States:** idle; loading ("Preparing audio…", spinner, per Button loading pattern); playing; paused; error (text stays fully readable regardless — audio failure never blocks reading, per an error banner with a retry action).
- **Responsive/edge cases:** controls remain reachable and usable while scrolling long text; if word-level timing isn't available from the TTS provider, fall back to sentence-level highlighting rather than no highlighting.
- **Accessibility acceptance criteria:** every control has a labeled, focusable button (not a bare icon); play/pause is also bindable to the spacebar when the player has focus; current state ("Playing", "Paused") is announced via `aria-live="polite"`, not only shown visually.

### CameraCapture / UploadPicker
- **Anatomy:** live camera preview (or upload dropzone), capture/select button, cancel.
- **States:** requesting-permission; permission-denied (clear recovery instructions, e.g. "Enable camera access in your browser settings" plus an "Upload instead" fallback that's always available); capturing; captured-preview (confirm or retake); uploading (progress indicator).
- **Responsive/edge cases:** if camera access isn't available at all (desktop without a webcam, permission blocked), the upload path is presented as the primary option, not a buried fallback.
- **Accessibility acceptance criteria:** camera preview has an accessible description for screen reader users (who will typically use "Upload" instead); capture button has a minimum 44×44px target and a clear label ("Take photo"), not just a camera icon.

### Document Card (Library list item)
- **Anatomy:** thumbnail (optional), title/first line of text, date, overflow menu (rename/delete).
- **States:** default; hover/focus-visible (`shadow.2`, border color shifts to `color.border.strong`); pressed; loading (skeleton placeholder while the list fetches); error (per-item retry if a thumbnail fails to load, doesn't block the rest of the list).
- **Responsive/edge cases:** long titles wrap to two lines then truncate with a full-title tooltip/`aria-label` — truncation is acceptable here (a list label) in a way it isn't for a button action label.
- **Accessibility acceptance criteria:** the whole card is a single focusable, keyboard-activatable target (not just the title text); the overflow menu is reachable and operable via keyboard, closes on `Escape`.

### EmptyState / LoadingIndicator / ErrorBanner
- **Anatomy (Empty):** short plain-language message + a single clear next action (e.g. "You haven't scanned anything yet" + "Scan text" button).
- **Anatomy (Loading):** spinner or skeleton + short status text ("Reading your image…") — status text changes are announced via `aria-live="polite"`.
- **Anatomy (Error):** icon + plain-language message (never a raw error code/stack) + retry action where one exists.
- **Accessibility acceptance criteria:** none of these three ever convey their meaning by color/icon alone — each always includes a text message.

---

## Accessibility Requirements and Acceptance Criteria

- **Contrast:** UI text must meet WCAG AA (4.5:1); reading-surface text must meet **AAA (7:1)** against its background/overlay in every supported combination. *Testable: automated contrast check run against every token pairing before merge.*
- **Keyboard:** every interactive element is reachable via `Tab`, operable via `Enter`/`Space`/arrow keys as appropriate, with no keyboard trap. *Testable: full keyboard-only pass through each of the five core flows (capture, customize, listen, save, log in).*
- **Focus visibility:** a visible focus indicator using `color.state.focus`, distinct from hover/selected styling, on every focusable element. *Testable: tab through every screen, confirm a visible ring at each stop.*
- **Motion:** `prefers-reduced-motion: reduce` collapses all transitions to instant state changes; nothing auto-plays or auto-advances. *Testable: toggle the OS setting, confirm no animated transitions remain.*
- **Text alignment:** body text is never justified; body text is never all-caps. *Testable: visual/style audit of the reading surface and all copy.*
- **No color-only meaning:** errors, success, and the "currently reading" state each pair color with text or an icon. *Testable: grayscale screenshot review — every state must still be understandable.*
- **Line height:** the reading surface never renders below 1.5 line-height, even at the user's minimum spacing setting. *Testable: attempt to set spacing below the floor via the slider — it should be clamped.*
- **Zoom/reflow:** the app remains usable and non-clipping at 200% browser zoom. *Testable: manual check at 200% zoom on each core screen.*

---

## Content and Tone Standards

Warm, plain, unambiguous. Short sentences. One instruction per sentence. No idioms or figurative language in UI copy (idioms are a known extra burden for some dyslexic readers).

| Do | Don't |
|---|---|
| "We couldn't find readable text in that image. Try better lighting or hold the camera steady." | "Looks like this one's a bit of a puzzle — no dice on the OCR front!" |
| "Scan text" | "Let's dive in and capture some content!" |
| "Settings saved." | "Boom — you're all set!" |
| "Enable camera access in your browser settings, or upload a photo instead." | "Camera error. Try again." |

- Buttons and labels use sentence case, not ALL CAPS or Title Case.
- Error messages always say what happened and what to do next — never a bare error code.
- Avoid negative framing where possible ("Try better lighting" rather than "Bad photo").

---

## Anti-Patterns and Prohibited Implementations

- Justified body text on the reading surface.
- All-caps body copy anywhere (small-caps or uppercase is acceptable for very short labels only, e.g. a badge, never for sentences).
- Pure white (`#FFFFFF`) as the app canvas, or pure black text — both increase visual glare/buzzing for this audience; use the warm tokens defined above.
- Hidden or removed focus indicators for the sake of a "cleaner" look.
- Icon-only controls with no accessible name.
- Auto-playing audio, auto-advancing screens, or animated (moving) text highlights.
- Truncating a button/action label instead of wrapping it.
- Conveying an error, success, or "currently playing" state through color alone.
- Burying the font/spacing/overlay controls in a nested settings menu instead of surfacing them directly on the reading screen.
- Introducing a new typeface, spacing value, or radius outside the token set without updating this document first.

---

## QA Checklist

- [ ] All text/background pairings pass their required contrast ratio (AA for UI, AAA for the reading surface).
- [ ] Every interactive element has a visible focus indicator and is keyboard-operable.
- [ ] No body text is justified or all-caps anywhere in the app.
- [ ] Reading-surface line-height never drops below 1.5 at any user setting.
- [ ] `prefers-reduced-motion` is honored on every transition.
- [ ] Every button, icon button, and form field has an accessible name.
- [ ] Error, empty, and loading states exist and are implemented for every component listed above.
- [ ] No state (error/success/currently-reading) relies on color alone.
- [ ] Touch targets are ≥44×44px throughout, including on desktop.
- [ ] Camera-permission-denied always offers an upload fallback in the same view.
- [ ] Display settings (font, size, spacing, overlay, TTS speed) are reachable in one tap/click from the reading screen, not nested in a menu.
- [ ] App remains usable, non-clipping, and non-overlapping at 200% browser zoom.
