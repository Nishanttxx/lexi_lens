# Lexi Lens — Technical Planning Document

**Status:** Draft for approval. No implementation should begin until the open questions below are resolved and this document is confirmed.
**Platform decision (confirmed):** Web app first (responsive, works on mobile browsers), architected so a native mobile app (React Native/Expo) can reuse the same Supabase backend later.
**Database & Auth (confirmed):** Supabase (Postgres + Supabase Auth + Supabase Storage + Edge Functions).
**Visual design:** Explicitly out of scope for this document. You will supply colors, typography, layout, and component styling separately. This doc only defines structure, data, and behavior — not appearance.

---

## 0. Open Questions / Missing Information

Per the engineering rules ("do not invent major requirements"), these are flagged rather than assumed. Defaults are proposed so planning can continue, but each needs your explicit approval before build.

| # | Question | Proposed default | Why it matters |
|---|---|---|---|
| 1 | OCR engine: client-side (Tesseract.js), or a cloud API (Google Cloud Vision / AWS Textract / Azure Read)? | Cloud API (Google Cloud Vision) for accuracy, with a Supabase Edge Function as the proxy | Affects cost, latency, offline capability, and where the API key lives |
| 2 | TTS engine: browser-native (Web Speech API, free but robotic) or a paid natural-voice API (ElevenLabs, Google Cloud TTS, Amazon Polly)? | Web Speech API for MVP, natural-voice API as a fast-follow | Affects cost per user, voice quality, and whether audio needs to be generated server-side and cached |
| 3 | Is a signup/account required to use the app at all, or can someone use it anonymously (no saved history) and only sign up to save documents? | Anonymous use allowed; account required only to save/sync documents across devices | Affects onboarding friction and DB design (guest vs. registered rows) |
| 4 | Do documents/scans need to persist (a "library" of past scans) or is each session single-use (scan → read → discard)? | Persist as a "Documents" library the user can revisit | Core to database schema — table count and storage sizing |
| 5 | Free vs. paid tiers / usage limits (OCR and TTS calls both cost money at scale)? | Not defined yet — MVP has no billing, but usage is rate-limited per user | Needed before launch; affects DB (usage counters) and infra |
| 6 | Target languages — English only, or multi-language OCR/TTS? | English only for MVP | Affects OCR/TTS provider config and font (OpenDyslexic has limited non-Latin support) |
| 7 | Does "AI Text-to-Speech" in the slides mean literal speech synthesis (TTS), or also an LLM step that simplifies/summarizes the text before reading it aloud? | TTS only (no LLM rewriting) for MVP; text simplification flagged as a possible v2 feature | Changes the AI integration section significantly — please confirm |

**Nothing below assumes an answer other than the proposed default.** Anywhere a default is used, it's called out again inline as `[DEFAULT — confirm]`.

---

## 1. Product Requirements

### Problem
People with dyslexia struggle to read standard printed or on-screen text due to font shape, spacing, and visual crowding. Lexi Lens converts a photo or upload of text into a dyslexia-friendly, customizable reading format, with an audio fallback.

### Target users
Dyslexic individuals (students, adults) and people supporting them (parents, teachers, accessibility services).

### Primary use cases
1. Capture a photo of printed text (book page, worksheet, sign, document) and read it back in a dyslexia-friendly format.
2. Upload an existing image or PDF instead of capturing live.
3. Adjust font, spacing, size, and color overlay to personal preference, and have that preference remembered.
4. Listen to the text read aloud instead of / alongside reading it.
5. Revisit previously scanned documents. `[DEFAULT — confirm #4]`

### Core features (MVP)
- Image capture / upload
- OCR text extraction
- Dyslexia-friendly text rendering (OpenDyslexic font, adjustable spacing/size, color overlays)
- Text-to-speech playback with play/pause/scrub and word-highlight sync
- Per-user saved customization preferences
- Document history/library `[DEFAULT — confirm #4]`

### Secondary features (post-MVP)
- Multi-language support
- Text simplification/summarization (LLM) `[open question #7]`
- Export customized text as PDF
- Shareable read-aloud links
- Usage analytics dashboard for teachers/parents

### User stories
- As a dyslexic reader, I want to snap a photo of a page and immediately see it in a font I can read, so I don't have to struggle through the original print.
- As a user, I want my font/color/spacing settings to persist across sessions so I don't have to reconfigure every time.
- As a user, I want to hear the text read aloud with the current word highlighted, so I can follow along.
- As a returning user, I want to find a document I scanned last week without re-scanning it. `[DEFAULT — confirm #4]`

### Functional requirements
- FR1: User can capture an image via device camera (web: `getUserMedia`/file input with `capture` attribute) or upload an existing image/PDF.
- FR2: System extracts text from the image via OCR.
- FR3: User can toggle/adjust: font (OpenDyslexic on/off), font size, letter spacing, line spacing, background/overlay color.
- FR4: System converts the processed text into audio and plays it back with basic controls (play, pause, seek, speed).
- FR5: User can create an account and log in (email/password + optionally OAuth) via Supabase Auth.
- FR6: Authenticated users' documents and preferences persist and sync across devices.
- FR7: Unauthenticated users can use the core flow (capture → read → listen) without an account, but nothing is saved. `[DEFAULT — confirm #3]`

### Non-functional requirements
- OCR result returned within ~5s for a typical single-page image.
- Works on modern evergreen browsers, desktop and mobile, down to a reasonably small screen width.
- WCAG 2.1 AA accessibility baseline (ironic to skip this for an accessibility tool).
- All user text/image data private to that user by default (enforced via Supabase Row Level Security, not just app logic).

### Business rules
- A user can only ever view/edit/delete their own documents and preferences (enforced at the database level via RLS, not only in application code).
- Guest sessions (if allowed) never write to the persistent `documents` table — only registered users get history. `[DEFAULT — confirm #3/#4]`

### Success criteria
- A user can go from "point camera at text" to "hearing/seeing dyslexia-friendly output" in under 3 taps/clicks and under ~10 seconds.
- OCR accuracy acceptable for standard printed text (not handwriting, for MVP).

### Constraints
- Must use Supabase for database and authentication (confirmed, non-negotiable per your instruction).
- Visual design is out of scope here — implementation must leave styling fully swappable (no hardcoded design decisions baked into component logic).

### Assumptions
- MVP targets printed/typed text, not handwriting recognition.
- MVP targets English text only. `[DEFAULT — confirm #6]`
- Internet connectivity is required (no offline OCR/TTS for MVP).

### Explicitly out of scope (MVP)
- Native mobile app codebase (planned for later, per your platform decision — the backend is being designed to support it, but no React Native/Expo build is part of this phase).
- Handwriting OCR.
- Multi-language support.
- Billing/subscriptions.
- Visual/UI design system (you are providing this).

---

## 2. User Flows

### Flow A — Capture & Read (guest or logged-in)
```
User → opens app → taps "Scan Text"
  → Frontend requests camera access (or shows upload picker)
  → User captures/selects image
  → Frontend uploads image to Backend (Edge Function) [loading state: "Reading your image..."]
  → Backend sends image to OCR provider
  → OCR provider returns extracted text (or error: no text found / low confidence)
  → Backend returns extracted text to Frontend
  → Frontend renders text using user's saved (or default) dyslexia-friendly settings
  → [If logged in] Backend saves document + extracted text to Supabase `documents` table
  → Success state: text shown on screen, "Listen" button available
  → Empty state: "We couldn't find readable text in that image — try again with better lighting/focus"
  → Error state: OCR provider timeout/failure → "Something went wrong reading that image, please try again"
```

### Flow B — Customize reading settings
```
User → opens "Display Settings" panel
  → Adjusts font size / spacing / color overlay via controls
  → Frontend applies changes live (client-side re-render, no backend round trip needed for preview)
  → User taps "Save as default" [only if logged in; guests see "Log in to save your settings"]
  → Backend upserts row in `user_preferences` table
  → Success state: confirmation toast
  → Error state: save failed → local preview still works, but a retry prompt is shown
```

### Flow C — Listen to text (TTS)
```
User → on a rendered document → taps "Listen"
  → Frontend sends processed text to Backend (Edge Function) [loading state: "Preparing audio..."]
  → Backend calls TTS provider, returns audio stream/file (or uses on-device Web Speech API directly, no backend call, if that default is chosen)
  → Frontend plays audio, highlights current word/sentence in sync (if word-timing data is available from the TTS provider; otherwise sentence-level highlighting only)
  → User can pause/resume/scrub/adjust speed
  → Error state: TTS failure → text remains readable, error toast shown, "Try audio again" retry
```

### Flow D — Sign up / Log in
```
User → taps "Log in" / "Sign up"
  → Supabase Auth handles email/password (and optional OAuth) [loading state: spinner on button]
  → On success: session token stored client-side by Supabase client SDK, user redirected to their library/last document
  → On failure: inline error (invalid credentials / email already in use / weak password)
  → Email verification (if enabled) → user shown "check your email" state until verified [DEFAULT: verification required — confirm]
```

### Flow E — View document history (logged-in only) `[DEFAULT — confirm #4]`
```
User → opens "My Documents"
  → Frontend queries Backend for documents where owner = current user (RLS enforced)
  → Loading state: skeleton list
  → Empty state: "You haven't scanned anything yet — tap Scan to get started"
  → Success state: list of past documents (thumbnail + date + first line of text)
  → User taps a document → opens Flow B/C on the saved text
  → Error state: fetch failed → retry option
```

---

## 3. Pages / Routes & UI Structure (functional spec — no visual design)

> Visual styling, colors, typography, and layout are intentionally NOT specified here — you're providing that separately. This section only defines what exists on each screen and what data/state it needs.

| Route | Purpose | Auth required? | Key components | Data shown | Actions |
|---|---|---|---|---|---|
| `/` | Landing / capture entry point | No | CameraCapture, UploadPicker, GuestBanner | — | Capture photo, Upload file, Log in / Sign up |
| `/scan/processing` | Interstitial while OCR runs | No | LoadingIndicator | Progress/status text | Cancel |
| `/read/:documentId` (or `/read` for a fresh unsaved scan) | Main reading view | No (guest: ephemeral `:documentId` not persisted) | DyslexiaTextRenderer, DisplaySettingsPanel, TTSPlayer, SaveDocumentButton (logged-in only) | Extracted + processed text | Adjust display settings, Play/pause/seek audio, Save (if logged in) |
| `/library` | List of past documents `[DEFAULT — confirm #4]` | Yes | DocumentList, EmptyState | List of user's documents | Open, Delete, Search/filter (post-MVP) |
| `/settings` | Account + default display preferences | Yes (display prefs read-only fallback for guests, not saved) | AccountForm, DisplaySettingsPanel, LogoutButton | Current preferences, account email | Update password, Update default display settings, Log out, Delete account |
| `/login`, `/signup` | Auth screens | No (redirect if already logged in) | AuthForm | — | Submit credentials, OAuth buttons (if enabled), link to the other screen |
| `/reset-password` | Password reset | No | ResetPasswordForm | — | Request reset email, submit new password |

**Reusable components** (used across multiple routes — do not duplicate):
- `DyslexiaTextRenderer` — renders processed text with current display settings.
- `DisplaySettingsPanel` — the font/spacing/size/color controls; used in both `/read/*` (live preview) and `/settings` (default editor).
- `TTSPlayer` — playback controls + word/sentence highlight sync.
- `CameraCapture` / `UploadPicker` — image acquisition.
- `EmptyState`, `LoadingIndicator`, `ErrorBanner` — generic states shared everywhere.

**Responsive behavior:** All routes must work down to a single-column mobile-width layout (camera capture is the primary flow and will most often happen on a phone browser). Exact breakpoints/layout are your call at design time.

---

## 4. Tech Stack

### Frontend
- **Framework:** Next.js (React) — chosen for SSR/SEO on the marketing/landing surface plus a normal SPA-like app experience, and because it's a straightforward base to later share types/logic with a React Native mobile app.
- **Language:** TypeScript
- **Styling:** Not specified — left open for your design system (CSS Modules, Tailwind, or plain CSS all remain viable; app logic will not assume one).
- **Component library:** None assumed by default (your design will dictate this); avoid pulling in a generic UI kit unless you specify one.
- **State management:** React Context + hooks for local/UI state; Supabase client + React Query (TanStack Query) for server state/caching. `[proposed, not yet approved]`
- **Form handling:** React Hook Form (lightweight, avoids boilerplate for auth/settings forms). `[proposed, not yet approved]`
- **Data fetching:** Supabase JS client (`@supabase/supabase-js`) directly from the frontend for reads protected by RLS; Edge Functions for anything needing a server-side secret (OCR/TTS provider keys).

### Backend
- **Framework:** Supabase Edge Functions (Deno) for any logic needing secret API keys (OCR/TTS calls) or server-side validation beyond RLS.
- **Language:** TypeScript (Deno runtime, matches Edge Functions).
- **API architecture:** REST-ish via Edge Function HTTP endpoints for OCR/TTS proxying; direct Supabase client calls (PostgREST under the hood) for standard CRUD on documents/preferences, protected by RLS.
- **Authentication:** Supabase Auth (email/password; OAuth providers optional/future).
- **Validation:** Zod schemas shared between Edge Functions and frontend forms where practical.
- **Background jobs:** None required for MVP (OCR/TTS calls are synchronous request/response). If audio pre-generation/caching is added later, Supabase's `pg_cron` or a queue table could be introduced — not needed now.

### Database
- **Engine:** Supabase Postgres.
- **ORM:** None — using the Supabase client + PostgREST directly, plus raw SQL migrations, to keep RLS policies and schema fully explicit (an ORM would obscure the RLS-centric design this app needs).
- **Migration system:** Supabase CLI migrations (`supabase/migrations/*.sql`), version-controlled.

### Infrastructure
- **Hosting (frontend):** Vercel (pairs naturally with Next.js) — `[proposed, confirm or specify alternative]`
- **File storage:** Supabase Storage (for uploaded/captured images, and generated audio files if cached).
- **Caching:** None beyond React Query's client cache for MVP.
- **Queue/background processing:** None for MVP (see above).
- **Monitoring:** Supabase's built-in logs/dashboard for backend; Vercel analytics or a lightweight error tracker (e.g., Sentry) for frontend — `[proposed, not yet approved]`.
- **Logging:** Edge Function logs via Supabase dashboard.

### External services
| Service | Purpose | Notes |
|---|---|---|
| OCR provider (Google Cloud Vision, default) | Extract text from captured/uploaded images | `[open question #1]` |
| TTS provider (Web Speech API, default) | Convert processed text to speech | `[open question #2]` |
| Supabase Auth | User accounts, sessions | Confirmed |
| Supabase Storage | Store source images (and audio, if cached) | Confirmed |

---

## 5. System Architecture

```
[Browser/Mobile Web]
  ├─ Next.js frontend (React)
  │    ├─ Supabase JS client → Supabase Auth (login/session)
  │    ├─ Supabase JS client → Postgres via PostgREST (documents, preferences) — RLS-protected
  │    └─ fetch() → Supabase Edge Functions (OCR proxy, TTS proxy)
  │
  ├─ Supabase Edge Function: /ocr
  │    → receives image (from Supabase Storage path or direct upload)
  │    → calls OCR provider API (server-side secret key)
  │    → returns extracted text
  │
  ├─ Supabase Edge Function: /tts   [only needed if NOT using browser-native Web Speech API]
  │    → receives processed text
  │    → calls TTS provider API (server-side secret key)
  │    → returns audio (stream or storage URL)
  │
  ├─ Supabase Postgres (RLS enforced)
  │    ├─ users (managed by Supabase Auth)
  │    ├─ documents
  │    ├─ user_preferences
  │    └─ (future) usage_counters
  │
  └─ Supabase Storage
       ├─ /images/{user_id}/{document_id}.jpg
       └─ /audio/{user_id}/{document_id}.mp3   (only if TTS output is cached)
```

**Data flow summary:** The frontend never talks to the OCR/TTS provider directly — those API keys live only in Edge Function environment variables, never in frontend code. All direct database reads/writes from the frontend go through Supabase's client library, which is subject to RLS policies, so authorization is enforced at the database layer, not just in the UI.

**Why this architecture:** Minimal moving parts — no separate backend server to host, deploy, or scale; Supabase covers auth, database, storage, and the two serverless functions we actually need. This avoids introducing an unnecessary standalone backend framework (Express/Fastify/etc.) since Edge Functions cover the one thing Supabase's auto-generated API can't do (calling third-party APIs with secret keys).

---

## 6. Database Schema (Supabase / Postgres)

All tables use Supabase's built-in `auth.users` for identity — no separate custom `users` table is created (avoids duplicating what Supabase Auth already manages). Every user-owned table has an `owner_id` referencing `auth.users(id)` and Row Level Security enabled.

### `documents`
| Field | Type | Notes |
|---|---|---|
| `id` | `uuid` | Primary key, default `gen_random_uuid()` |
| `owner_id` | `uuid` | FK → `auth.users(id)`, not null, `on delete cascade` |
| `title` | `text` | Nullable — e.g. first line of extracted text, or user-renamed |
| `raw_text` | `text` | OCR output, not null |
| `image_storage_path` | `text` | Path in Supabase Storage bucket `images`, nullable (guest scans that aren't saved never create this row at all) |
| `source` | `text` | `'camera'` or `'upload'` |
| `created_at` | `timestamptz` | default `now()` |
| `updated_at` | `timestamptz` | default `now()`, updated via trigger |
| `deleted_at` | `timestamptz` | nullable — soft delete |

Indexes: `(owner_id, created_at desc)` for the library list query.

### `user_preferences`
One row per user — their default display settings.

| Field | Type | Notes |
|---|---|---|
| `owner_id` | `uuid` | Primary key AND FK → `auth.users(id)`, `on delete cascade` |
| `font_family` | `text` | default `'OpenDyslexic'` |
| `font_size` | `integer` | default `18` (px) |
| `letter_spacing` | `numeric` | default `0.05` (em) |
| `line_spacing` | `numeric` | default `1.5` |
| `overlay_color` | `text` | nullable hex/token, default `null` (no overlay) |
| `tts_speed` | `numeric` | default `1.0` |
| `updated_at` | `timestamptz` | default `now()`, updated via trigger |

### Relationships
```
auth.users (1) ──< (many) documents
auth.users (1) ──  (1) user_preferences
```

### Row Level Security (critical — enforces "a user can never read another user's data")
```sql
alter table documents enable row level security;
alter table user_preferences enable row level security;

create policy "Users can CRUD their own documents"
  on documents for all
  using (auth.uid() = owner_id)
  with check (auth.uid() = owner_id);

create policy "Users can CRUD their own preferences"
  on user_preferences for all
  using (auth.uid() = owner_id)
  with check (auth.uid() = owner_id);
```

### Storage buckets
- `images` — private bucket, path convention `{owner_id}/{document_id}.jpg`, access controlled via a Storage RLS policy mirroring the one above (`auth.uid() = owner_id` derived from path).
- `audio` — private bucket, same convention, only created if TTS output caching is approved (see open question #2).

### Notes on guest usage `[depends on open question #3/#4]`
If guest (unauthenticated) use is confirmed, guest scans are never written to `documents` — they exist only in frontend memory for that session. Nothing in the schema needs to special-case guests; they simply never generate a row.

---

## 7. API Contracts

Most reads/writes use the Supabase client directly against `documents` and `user_preferences` (governed by RLS above), so only the two custom Edge Functions are documented as "API endpoints" here.

### `POST /functions/v1/ocr`
- **Auth:** Optional (guests may call this; if a Supabase session is present, pass it through so the function knows whether to also save the resulting document — or let the frontend handle the save as a separate DB insert after receiving text).
- **Request body:** `{ image: base64 string OR storage_path: string }`
- **Response (200):** `{ text: string, confidence: number }`
- **Response (422):** `{ error: "no_text_found" }`
- **Response (502):** `{ error: "ocr_provider_error" }`
- **Validation:** image size limit (e.g. 10MB), accepted MIME types (`image/jpeg`, `image/png`).

### `POST /functions/v1/tts` *(only if a paid TTS provider is chosen over the browser-native API)*
- **Auth:** Optional, same reasoning as above.
- **Request body:** `{ text: string, speed?: number }`
- **Response (200):** `{ audio_url: string }` or a streamed audio response
- **Response (400):** `{ error: "text_too_long" }` (define a max character limit)
- **Response (502):** `{ error: "tts_provider_error" }`

### Standard DB operations (via Supabase client, not custom endpoints)
| Operation | Table | Notes |
|---|---|---|
| Create document | `documents` insert | Only for logged-in users |
| List documents | `documents` select where `owner_id = auth.uid()` and `deleted_at is null` | Paginated |
| Soft-delete document | `documents` update `deleted_at = now()` | |
| Get/upsert preferences | `user_preferences` select/upsert | |

---

## 8. Authentication & Authorization

- **Signup / Login / Logout / Password reset:** Handled by Supabase Auth (email + password for MVP).
- **Email verification:** `[DEFAULT: required before first save — confirm]`
- **OAuth:** Not in MVP scope; Supabase Auth supports adding Google/Apple later without schema changes.
- **Session strategy:** Supabase's default JWT-based session, managed by the `supabase-js` client (handles refresh automatically).
- **Protected routes:** `/library`, `/settings` require a session; middleware in Next.js checks for a valid Supabase session and redirects to `/login` if absent.
- **Roles/permissions:** Single role for MVP (no admin panel). If an admin/moderation role is needed later, it would be a `role` column on a profile table plus RLS policy updates — not built now, per "don't build unnecessary complexity."
- **Resource ownership:** Enforced at the database layer via RLS (Section 6), not only in frontend checks — the rule "a user must never access another user's data by changing an ID" is satisfied because Postgres itself rejects the query, regardless of what the frontend sends.

---

## 9. Security

- **Secrets:** OCR/TTS provider API keys live only in Supabase Edge Function environment variables — never shipped to the frontend bundle, never committed to the repo.
- **Input validation:** Image MIME type/size checked before sending to OCR; text length capped before sending to TTS.
- **SQL injection:** Not applicable in the traditional sense — no raw SQL string concatenation; all queries go through Supabase's parameterized client or migrations.
- **XSS:** Extracted OCR text is rendered as plain text (not `dangerouslySetInnerHTML`) to prevent any injected markup in scanned text from executing.
- **CSRF:** Supabase's JWT-in-header auth model is not cookie-session-based in the vulnerable sense, but Edge Functions should still validate the `Authorization` header rather than trusting any implicit cookie.
- **Rate limiting:** OCR/TTS Edge Functions should rate-limit per user/IP (Supabase doesn't do this natively — would need a simple counter table or a service like Upstash — `[flagging as needed before public launch, not built for MVP]`).
- **File upload security:** Enforce MIME type and size limits both client- and server-side; images stored in a private (non-public) Storage bucket.
- **PII:** Only email (via Supabase Auth) and scanned text/images are stored — no other PII collected in MVP.
- **Secure headers:** Standard Next.js/Vercel defaults; no custom relaxation of CSP without reason.
- **Error-message leakage:** API errors return generic messages (`"ocr_provider_error"`) to the client; full provider error details are logged server-side only.

---

## 10. Environment Configuration

| Variable | Used for | Frontend or backend | Secret? | Where configured |
|---|---|---|---|---|
| `NEXT_PUBLIC_SUPABASE_URL` | Supabase project URL | Frontend | No | Vercel env vars |
| `NEXT_PUBLIC_SUPABASE_ANON_KEY` | Supabase anon/public key (safe for frontend — RLS protects data) | Frontend | No (public by design) | Vercel env vars |
| `SUPABASE_SERVICE_ROLE_KEY` | Elevated access for Edge Functions if ever needed to bypass RLS for a trusted server operation | Backend (Edge Functions) only | **Yes** | Supabase project secrets |
| `OCR_PROVIDER_API_KEY` | Auth to OCR provider (e.g. Google Cloud Vision) | Backend (Edge Function) only | **Yes** | Supabase project secrets |
| `TTS_PROVIDER_API_KEY` | Auth to TTS provider, if a paid one is chosen | Backend (Edge Function) only | **Yes** | Supabase project secrets |

No actual key values are included anywhere in this document or in the repo. `.env` files are git-ignored.

---

## 11. Error Handling

| Failure | Handling |
|---|---|
| Invalid image upload (wrong type/too large) | Rejected client-side before upload, with inline message |
| OCR provider timeout/failure | Edge Function returns `502`; frontend shows retry prompt, original image preserved so user doesn't have to re-capture |
| OCR finds no text | `422 no_text_found`; frontend shows guidance ("try better lighting/focus") |
| TTS provider failure | Text remains visible/readable regardless; only audio playback shows an error + retry |
| Auth failure (bad credentials, etc.) | Supabase Auth's error surfaced as an inline, human-readable form error |
| Network failure generally | Generic "connection issue, please try again" banner; no raw error/stack shown to the user |
| Unexpected server error | Edge Function logs full details server-side (Supabase dashboard); client sees a generic message only |

---

## 12. AI / OCR & TTS Integration

- **OCR provider:** `[open question #1]` — default proposal: Google Cloud Vision `TEXT_DETECTION`.
- **TTS provider:** `[open question #2]` — default proposal: Web Speech API (browser-native, zero backend cost) for MVP; revisit a paid natural-voice API once quality feedback comes in.
- **Fallback models:** None for MVP — a single provider per capability keeps the system simple; if the chosen OCR/TTS provider has an outage, the user sees the error state in Section 11 rather than silently falling back to a second provider (adding a fallback provider is a real feature to plan deliberately later, not something to half-build now).
- **Input format:** OCR — JPEG/PNG image, ≤10MB. TTS — plain text, capped length (exact cap TBD based on provider limits).
- **Output format:** OCR — plain text + confidence score. TTS — audio stream/URL.
- **Validation:** OCR output is never assumed complete/correct — it's shown to the user as editable/correctable text rather than treated as ground truth for anything downstream (important since there's no automated correction step in MVP).
- **Retry logic:** One automatic retry on transient provider errors (5xx) before surfacing the error state to the user.
- **Timeout handling:** Edge Functions set an explicit timeout (e.g. 15s) against the provider call so the user isn't stuck on a loading state indefinitely.
- **Cost considerations:** Both OCR and TTS calls cost money per use — this is exactly why open question #5 (usage limits) needs an answer before public launch, even though MVP can ship without hard limits.

---

## 13. Testing Strategy

### Unit tests
- Display-settings logic (font/spacing/size calculations, defaults merging).
- Zod validation schemas for OCR/TTS request payloads.

### Integration tests
- Edge Function `/ocr`: mocked provider response → correct text/confidence returned; provider error → correct error shape returned.
- Supabase RLS policies: a test user cannot read/update/delete another test user's `documents` or `user_preferences` rows (this is the single most important test in the whole app, given the "no cross-user access" business rule).
- Document CRUD via Supabase client against a local/staging Supabase instance.

### End-to-end tests (critical flows)
- Guest: capture/upload → see processed text → play TTS.
- Signup → capture → save document → log out → log back in → document still present in `/library`.
- Update display settings → reload app → settings persisted.

### Security tests
- Attempt to fetch another user's document by guessing/changing an `id` → must fail (covered by RLS integration test above, plus an E2E check via the actual API).
- Unauthenticated request to a protected route (`/library`, `/settings`) → redirected to login.
- Oversized/invalid file upload → rejected with correct error, not a server crash.

### Checklist (mirrors master prompt format)
**Authentication:**
- [ ] User can register
- [ ] User can log in
- [ ] Invalid credentials fail with a clear message
- [ ] Protected routes reject unauthenticated users
- [ ] Users cannot access other users' documents/preferences

**Scan/read feature:**
- [ ] Valid image → correct extracted text shown
- [ ] Invalid/no-text image → empty state shown, no crash
- [ ] Loading state shown during OCR
- [ ] OCR failure → error state with retry, image not lost

---

## 14. Deployment

- **Development:** Local Next.js dev server + local Supabase (via Supabase CLI `supabase start`) or a shared Supabase "dev" project.
- **Staging:** A separate Supabase project + a Vercel preview deployment per branch/PR. `[proposed — confirm if staging is wanted for MVP or if dev→prod directly is acceptable]`
- **Production:** Vercel (frontend) + Supabase production project (DB, Auth, Storage, Edge Functions).
- **Migrations:** Supabase CLI migration files, applied via `supabase db push` (or CI) — never hand-edited directly against production.
- **Build process:** Standard Next.js build via Vercel's Git integration (auto-deploy on push to main, per your existing rule of not pushing/committing without instruction — this refers to CI's own deploy step, not Claude performing git actions).
- **CI/CD:** GitHub Actions (or Vercel's built-in CI) running lint + unit/integration tests before merge. `[proposed, not yet approved]`
- **Backups:** Supabase's automatic daily backups (available on paid plans) — confirm which Supabase pricing tier you're on, as this affects backup/retention guarantees.
- **Rollback strategy:** Vercel's instant rollback to a previous deployment for frontend; Supabase migrations should be written to be reversible where practical (a corresponding "down" migration or a documented manual rollback step for anything destructive).

---

## 15. Engineering Rules (project-specific, carried forward from your master prompt)

1. Do not begin implementation until the open questions in Section 0 are resolved.
2. Visual/UI design (colors, typography, spacing values, component look) is supplied externally — do not invent it.
3. Database schema changes go through a migration file, never a manual dashboard edit, once development starts.
4. No provider API key ever appears in frontend code or is committed to the repo.
5. RLS is the source of truth for authorization — frontend-only checks are a UX nicety, never the security boundary.
6. No new external service/provider is added without it being reflected back into Section 4/12 first.
7. Small, reviewable changes — one feature/task at a time, matching the roadmap below.

---

## 16. Technical Risks

| Risk | Impact | Mitigation |
|---|---|---|
| OCR accuracy on poor-quality photos (glare, angle, handwriting) | Core feature feels broken | Set expectations in empty/error states; consider client-side image quality hints (blur/lighting warning) later |
| OCR/TTS provider cost at scale | Budget risk if usage limits (open question #5) aren't defined before growth | Add usage counters/rate limiting before public launch |
| Web Speech API voice quality/availability varies by browser | Inconsistent experience across users | Revisit with a paid TTS provider once validated with real users |
| RLS misconfiguration | Most severe possible bug class here — cross-user data leak | Dedicated automated tests specifically for RLS (Section 13), reviewed before any schema change ships |
| Scope creep from "AI" branding into an LLM rewriting feature (open question #7) | Could balloon MVP significantly | Explicitly deferred until confirmed |

---

## 17. Development Roadmap (small, independently testable tasks)

1. Supabase project setup: schema migration for `documents` + `user_preferences`, RLS policies, Storage buckets.
2. Supabase Auth wired into Next.js (signup/login/logout/password reset), protected route middleware.
3. Image capture/upload UI (no styling) + Edge Function `/ocr` with chosen provider, guest flow only (no save).
4. `DyslexiaTextRenderer` + `DisplaySettingsPanel` (live preview, local state only, no persistence yet).
5. Persist `user_preferences` for logged-in users (save/load defaults).
6. Persist `documents` for logged-in users + `/library` list + soft delete.
7. TTS integration (`TTSPlayer`) using the chosen provider from open question #2.
8. Error/empty/loading states audit across all flows in Section 2.
9. RLS + auth security test suite (Section 13).
10. Deployment pipeline (staging + production).

Each task above should be reviewed and approved individually before moving to the next, per the "small, correct, understandable change" principle.

---

*End of planning document. Please review Section 0 (Open Questions) first — everything else follows from those answers.*
