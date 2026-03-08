# Invention Zones
## Stage Manager Shared Reference — Skills Only

Each zone lists: invisible decisions, default patterns, closing questions.

---

## API Design

**Invisible decisions:**
- Auth strategy and token lifecycle
- Error response shape and status code conventions
- Pagination pattern
- Versioning strategy
- Rate limiting behavior
- CORS configuration

**Default patterns Claude reaches for:**
- JWT with hardcoded expiry stored in localStorage
- Generic `{ error: "message" }` response shape
- Offset pagination even when cursor pagination is appropriate
- No versioning until it breaks something
- No rate limiting

**Closing questions:**
- Who calls this API and how do they authenticate?
- What does a failed response look like — and who handles it?
- Will this API need to evolve without breaking existing clients?

---

## Complex UI

**Invisible decisions:**
- State management topology
- Component communication pattern
- Loading and error states per component
- Optimistic update behavior
- Form validation timing and shape
- Accessibility baseline

**Default patterns Claude reaches for:**
- useState all the way down until it breaks, then a global store
- Prop drilling before context, context before dedicated state library
- Loading spinners with no error state
- Client-side validation only
- No accessibility unless specified

**Closing questions:**
- Where does state live and who owns it?
- What does the user see when something is loading? When it fails?
- What devices and input methods need to work?

---

## AI Systems

**Invisible decisions:**
- Prompt architecture and context injection strategy
- Context window budget allocation
- Model selection and fallback behavior
- Evaluation criteria for output quality
- Retry and degradation logic
- Cost per call assumptions

**Default patterns Claude reaches for:**
- Single monolithic prompt
- No context window management until overflow
- Hardcoded model with no fallback
- No evaluation — "it looks right" as the bar
- No retry logic

**Closing questions:**
- What does a bad output look like — and what happens when you get one?
- What's the acceptable latency and cost per interaction?
- How will you know if the system is degrading over time?

---

## DevOps / CI-CD

**Invisible decisions:**
- Branch strategy and merge gates
- Environment promotion sequence (dev to staging to prod)
- Secret and credential management
- Build artifact strategy
- Rollback mechanism
- Notification and alerting on failure

**Default patterns Claude reaches for:**
- Single main branch with no protection rules
- Deploy straight to production on merge
- Secrets hardcoded in config files or committed to repo
- No rollback plan
- No alerting

**Closing questions:**
- How does code get from a developer's machine to production — and who approves each step?
- Where do secrets live and who can access them?
- What's the rollback procedure when a deploy goes wrong?

---

## Hosting / Infrastructure

**Invisible decisions:**
- Scaling model (vertical, horizontal, serverless)
- Cold start tolerance
- Region and latency assumptions
- Storage type and persistence guarantees
- CDN and caching strategy
- Cost ceiling and spike behavior

**Default patterns Claude reaches for:**
- Single region deployment
- Serverless with no cold start consideration
- No caching layer
- No cost alerts
- Ephemeral storage treated as persistent

**Closing questions:**
- What's the expected load — and what happens when it spikes 10x?
- Does any part of this system need to be always-warm?
- Where is data stored and what happens if that storage goes away?

---

## Data Persistence

**Invisible decisions:**
- Schema design and normalization level
- Migration strategy
- Indexing assumptions
- Backup frequency and restore process
- Soft delete vs hard delete
- Multi-tenancy isolation

**Default patterns Claude reaches for:**
- Flat schema that works for demo data, breaks under real data
- No migrations — manual schema changes
- No indexes until queries are slow
- No backup strategy
- Hard deletes everywhere
- No tenant isolation

**Closing questions:**
- How does the schema change over time without destroying existing data?
- What data can never be deleted — and what should disappear?
- Who owns which data, and can it leak between users or tenants?

---

## Authentication / Authorization

**Invisible decisions:**
- Identity provider vs roll-your-own
- Session vs token strategy
- Role and permission model
- Password reset and account recovery flow
- Multi-factor requirements
- OAuth scope and consent

**Default patterns Claude reaches for:**
- Roll-your-own auth even when a provider is appropriate
- JWT in localStorage (XSS vulnerable)
- Binary admin/user roles with no granularity
- No account recovery flow
- No MFA
- Overly broad OAuth scopes

**Closing questions:**
- Who are the user types and what can each one do?
- What happens when someone loses access to their account?
- Is there any data or action that should require elevated verification?

---

## Third-Party Integrations

**Invisible decisions:**
- Webhook verification and security
- Rate limit handling and backoff strategy
- Failure and retry behavior
- API key rotation and storage
- Vendor lock-in surface area
- Sandbox vs production credential management

**Default patterns Claude reaches for:**
- No webhook signature verification
- No rate limit handling — fails silently or crashes
- No retry logic
- API keys in environment variables with no rotation plan
- Deep vendor coupling with no abstraction layer
- Same credentials for sandbox and production

**Closing questions:**
- What happens when this integration is unavailable for an hour?
- How are API keys stored, rotated, and revoked?
- What would it cost to swap this vendor out in six months?

---

## Error Handling / Logging / Observability

**Invisible decisions:**
- Error classification (user error vs system error vs integration error)
- Log level strategy and what gets captured
- Alerting thresholds
- Distributed trace correlation
- User-facing error message design
- Silent failure surface area

**Default patterns Claude reaches for:**
- console.log as the logging strategy
- Generic "something went wrong" user messages
- No error classification
- No alerting
- Errors that fail silently and leave the system in a bad state
- No correlation IDs across services

**Closing questions:**
- How will you know the system is broken before a user tells you?
- What information does a developer need to diagnose a production failure?
- What does the user see — and what do they do — when something goes wrong?

---

## Testing Strategy

**Invisible decisions:**
- Test pyramid shape (unit / integration / e2e ratio)
- What counts as tested enough to ship
- Test data management
- Mocking strategy for external dependencies
- CI gate vs local-only tests
- Who writes tests and when

**Default patterns Claude reaches for:**
- Unit tests for pure functions, nothing else
- No integration tests
- No e2e tests
- Mocks that don't reflect real API behavior
- Tests that pass locally, fail in CI
- Tests written after bugs, not before features

**Closing questions:**
- What level of confidence do you need before deploying?
- How do tests run in CI — and what breaks the build?
- How do you test behavior that depends on external services?

---

## Mobile / Responsive Behavior

**Invisible decisions:**
- Breakpoint strategy and what "mobile" means
- Touch target sizing
- Gesture and swipe behavior
- Offline or low-connectivity behavior
- Native device feature access (camera, location, notifications)
- Performance budget on low-end devices

**Default patterns Claude reaches for:**
- Desktop-first layout that shrinks badly
- No touch target sizing consideration
- No offline behavior
- Assumes fast, reliable connectivity
- No performance budget
- Responsive CSS that works in Chrome, breaks on Safari iOS

**Closing questions:**
- What devices and screen sizes must work — and which are nice-to-have?
- Does any feature require native device capabilities?
- What's the minimum acceptable experience on a slow connection?

---

## Feature Delivery / Optionality

**Invisible decisions:**
- Branching strategy and branch lifetime expectations
- Pull request review gates and merge criteria
- Feature toggle infrastructure and storage
- Rollout strategy — percentage, allowlist, cohort, or manual
- Toggle lifecycle — who turns it on, off, and when it gets cleaned up
- Data model compatibility across toggle states
- Observability tied to variant
- Experimentation infrastructure — A/B assignment, cohort isolation, result measurement
- Beta group and early access management
- Kill switch design for fast rollback without a deploy

**Default patterns Claude reaches for:**
- Feature branches that live too long and create merge conflict debt
- No PR gates — merge on approval with no automated checks
- Boolean flags hardcoded in config with no management layer
- Big bang releases — everyone gets the new thing at once
- No toggle cleanup — flags accumulate until the codebase is unreadable
- Schema changes that break the old code path the moment they ship
- No variant tracking in logs
- No kill switch — rollback requires a full redeploy

**Why this zone is different:**
Vibe coders treat branching and toggles as process questions. They aren't — toggle infrastructure has to be designed into the architecture from the start. Retrofitting it is expensive. Without variant-aware observability, user testing in production generates data you can't interpret.

**Closing questions:**
- How does a new feature reach 10% of users before it reaches 100%?
- If a feature toggle controls behavior that touches the database, what happens to users on the old code path after the schema changes?
- How will you know which variant a specific user experienced when reading your logs?
- When a toggle is permanent — the experiment is over — what removes the dead code?
- What's the fastest path to turning something off in production without a deploy?
