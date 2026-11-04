---
name: design-system-lexilens
description: Creates implementation-ready design-system guidance for Lexi Lens, with tokens, component behavior, and accessibility standards tuned for dyslexic readers. Use when creating or updating UI rules, component specifications, or design-system documentation for Lexi Lens.
---

# Lexi Lens

## Mission
Deliver implementation-ready design-system guidance for Lexi Lens that can be applied consistently across the capture, reading, listening, and account surfaces of the app — and that models good accessible design itself, not just enables it.

## Brand
- Product/brand: Lexi Lens
- Audience: dyslexic readers (primary), plus parents, teachers, and accessibility-services staff supporting them (secondary)
- Product surface: responsive web app (mobile-first; a native mobile app shares the same backend later)
- Core promise: point a camera at printed text, get back something you can actually read and hear

## Style Foundations
- Visual style: calm, high-legibility, low visual noise, warm rather than clinical
- Main font style: Atkinson Hyperlegible for interface chrome (a font purpose-built for legibility, not a generic system font); OpenDyslexic as the default reading-surface font, user-swappable
- Typography scale: `font.size.xs=13px`, `font.size.sm=15px`, `font.size.md=17px`, `font.size.lg=19px`, `font.size.xl=22px`, `font.size.2xl=26px`, `font.size.3xl=32px`, `font.size.4xl=40px` (UI chrome only — the reading surface has its own independent, user-adjustable scale; see DESIGN.md)
- Color palette: `color.bg.canvas=#FBF6EE`, `color.bg.surface=#FFFFFF`, `color.bg.surface-muted=#F1E9DA`, `color.text.primary=#211D1A`, `color.text.secondary=#5B5349`, `color.text.inverse=#FBF6EE`, `color.accent.primary=#2B6E63`, `color.accent.warm=#E8833B`, `color.border.default=#DCD2C0`, `color.state.focus=#1D4E8F`, `color.state.success=#2F7A4D`, `color.state.error=#B3412B`
- Spacing scale: `space.1=4px`, `space.2=8px`, `space.3=12px`, `space.4=16px`, `space.5=24px`, `space.6=32px`, `space.7=48px`, `space.8=64px`
- Radius/shadow/motion tokens: `radius.sm=8px`, `radius.md=14px`, `radius.lg=22px`, `radius.pill=999px` | `shadow.1=0 1px 2px rgba(33,29,26,0.06)`, `shadow.2=0 4px 12px rgba(33,29,26,0.08)`, `shadow.3=0 8px 24px rgba(33,29,26,0.10)` | `motion.duration.instant=100ms`, `motion.duration.fast=160ms`, `motion.duration.normal=240ms` (deliberately short — no parallax, no auto-playing motion, strict `prefers-reduced-motion` support)

## Accessibility
- Target: WCAG 2.2 AA minimum, **AAA contrast (7:1) for reading-surface body text** — a stricter bar than typical marketing sites, because legibility is the product, not a compliance checkbox.
- Keyboard-first interactions required, including full TTS playback control.
- Focus-visible rules required, using a focus color distinct from the accent color so focus is never ambiguous.
- Contrast constraints required at every token pairing, not just the default theme.
- Dyslexia-specific constraints required: no justified text, no all-caps body copy, line-height never below 1.5 on the reading surface, no meaning conveyed by color alone.

## Writing Tone
warm, plain, unambiguous — short sentences, one instruction per sentence, no idioms

## Rules: Do
- Use semantic tokens, not raw hex values, in component guidance.
- Every component must define required states: default, hover, focus-visible, active, disabled, loading, error.
- Responsive behavior and edge-case handling (long text, no text, slow network, denied camera permission) must be specified for every component family.
- Accessibility acceptance criteria must be testable in implementation.
- Expose reading-adjustment controls (font, size, spacing, overlay color, TTS speed) as first-class, always-reachable controls — never buried in a menu.

## Rules: Don't
- Do not allow low-contrast text or hidden focus indicators.
- Do not introduce one-off spacing or typography exceptions.
- Do not use ambiguous labels or non-descriptive actions ("Click here", icon-only buttons with no accessible name).
- Do not use motion, auto-advancing content, or animated highlighting that can't be disabled.
- Do not default to a stark white/black palette — canvas and text tokens must stay in the warm, reduced-glare range defined above.

## Guideline Authoring Workflow
1. Restate design intent in one sentence.
2. Define foundations and tokens.
3. Define component anatomy, variants, and interactions.
4. Add accessibility acceptance criteria.
5. Add anti-patterns and migration notes.
6. End with QA checklist.

## Required Output Structure
- Context and goals
- Design tokens and foundations
- Component-level rules (anatomy, variants, states, responsive behavior)
- Accessibility requirements and testable acceptance criteria
- Content and tone standards with examples
- Anti-patterns and prohibited implementations
- QA checklist

## Component Rule Expectations
- Include keyboard, pointer, and touch behavior (minimum 44×44px touch targets throughout).
- Include spacing and typography token requirements.
- Include long-content, overflow, and empty-state handling — this app's core content (OCR output) is unpredictable in length and quality, so every text-bearing component must define what happens with very long, very short, or garbled input.

## Quality Gates
- Every non-negotiable rule must use "must".
- Every recommendation should use "should".
- Every accessibility rule must be testable in implementation.
- Prefer system consistency over local visual exceptions.
