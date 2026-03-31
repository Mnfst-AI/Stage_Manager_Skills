# Tool Selection Zones
## Stage Manager Shared Reference — Skills Only

Each zone names: the decision, Claude's default, real options with honest tradeoffs, what lock-in looks like, and the question that keeps options open longest.

---

## Analytics / Product Telemetry

**The decision:** How do you understand what users are doing and whether your experiments are working?

**What Claude defaults to:** Mixpanel.

**Real options:**
- **Mixpanel** — powerful funnel analysis, data on their servers, pricing scales sharply
- **PostHog** — analytics plus feature flags plus session recording; open source and self-hostable; data ownership stays with you
- **Amplitude** — enterprise-grade, expensive early, not self-hostable
- **Pendo** — strongest for in-app guidance and onboarding flows
- **Simple logging + Metabase** — full control, high setup cost

**What lock-in looks like:** Event taxonomy baked into your codebase. Migrating means re-instrumenting every event everywhere.

**The question that keeps options open longest:**
Who owns this data — and does that matter to your users or your community?

---

## Email Delivery / Transactional Messaging

**The decision:** How do you send transactional and marketing email?

**What Claude defaults to:** SendGrid.

**Real options:**
- **SendGrid** — reliable, pricing climbs with volume
- **Resend** — developer-first, modern API, React Email integration, better DX
- **Postmark** — transactional-only, best-in-class deliverability
- **AWS SES** — cheapest at scale, painful to set up
- **Loops** — built for SaaS lifecycle email, combines transactional and behavioral

**What lock-in looks like:** Templates built against one provider's engine. Unsubscribe management tied to their list model.

**The question that keeps options open longest:**
Is this purely transactional, or will you eventually need behavioral and lifecycle email in the same system?

---

## Payment Processing

**The decision:** How do you collect money and manage subscriptions?

**What Claude defaults to:** Stripe.

**Real options:**
- **Stripe** — best-in-class API, standard fees, US-centric defaults
- **Paddle** — merchant of record, handles VAT and global tax compliance, higher fees
- **Lemon Squeezy** — similar to Paddle, simpler, better for indie and digital products
- **Open Collective** — purpose-built for communities and cooperatives, transparent financials, mission-aligned

**What lock-in looks like:** Subscription logic, pricing tables, and webhook handlers tightly coupled to one provider's data model.

**The question that keeps options open longest:**
Do you need to handle VAT and global tax compliance — and does your model align better with a merchant of record?

---

## Search

**The decision:** How do users find things inside your product?

**What Claude defaults to:** Algolia.

**Real options:**
- **Algolia** — fastest time to great search, pricing scales sharply, data on their servers
- **Typesense** — open source Algolia alternative, self-hostable, nearly identical API
- **Meilisearch** — open source, self-hostable, excellent DX
- **pg_search / pgvector** — search directly in Postgres, no new infrastructure, semantic search possible

**What lock-in looks like:** Index schema and ranking rules built for one provider. Re-indexing a large dataset on migration is slow and risky.

**The question that keeps options open longest:**
Is full-text search genuinely needed now, or would filtered queries in your existing database get you to your first 1,000 users?

---

## Queue / Background Jobs

**The decision:** How do you handle work that shouldn't happen in a web request?

**What Claude defaults to:** Bull/BullMQ with Redis.

**Real options:**
- **BullMQ** — battle-tested, Redis-backed, rich feature set
- **Inngest** — event-driven, serverless-native, no Redis needed, built-in observability
- **Trigger.dev** — open source, self-hostable, strong for AI workloads
- **Simple cron + database** — for low-volume scheduled work, often enough

**What lock-in looks like:** Job definitions and retry logic coupled to one system. Migrating means rewriting infrastructure while keeping production running.

**The question that keeps options open longest:**
Are you on serverless infrastructure — and does your queue choice work without a persistent process?

---

## Feature Flags / Experimentation

**The decision:** How do you control which users see which features and run experiments?

**What Claude defaults to:** A boolean environment variable.

**Real options:**
- **PostHog** — feature flags plus full analytics, open source and self-hostable
- **LaunchDarkly** — enterprise standard, powerful targeting, expensive
- **Unleash** — open source LaunchDarkly alternative, self-hostable
- **Flagsmith** — open source, self-hostable, simpler, good DX

**What lock-in looks like:** Flag keys baked into every component. If flags and analytics are separate systems, you lose the ability to correlate variants with behavioral data.

**The question that keeps options open longest:**
Do your flags need to know anything about the user — cohort, plan, beta status — or are they purely on/off for everyone?

---

## File Storage / Media Handling

**The decision:** Where do user-uploaded files and media live?

**What Claude defaults to:** AWS S3.

**Real options:**
- **AWS S3** — reliable, cheap at scale, complex IAM, vendor lock-in
- **Cloudflare R2** — S3-compatible, no egress fees, simpler pricing
- **Supabase Storage** — S3-compatible, integrated with Supabase auth and database
- **Uploadthing** — developer-first, handles presigned URLs, size limits, type validation

**What lock-in looks like:** Storage URLs baked into your database. Migration means moving files and updating every URL reference.

**The question that keeps options open longest:**
What are your egress costs at 10x current scale?

---

## CMS / Content Infrastructure

**The decision:** How do non-developers edit content?

**What Claude defaults to:** Hardcoded strings in the codebase.

**Real options:**
- **Sanity** — powerful structured content, real-time collaboration, generous free tier
- **Contentful** — enterprise standard, robust, expensive at scale
- **Payload CMS** — open source, self-hostable, code-first schema
- **Notion as CMS** — works for simple use cases via API, zero setup
- **MDX files in repo** — right for developer docs, wrong for non-developer editors

**What lock-in looks like:** Content schema modeled in one CMS's data structure. Migration means exporting and transforming structured content at scale.

**The question that keeps options open longest:**
Who needs to edit this content — developers only, or people who shouldn't touch the codebase?

---

## Maps / Geolocation

**The decision:** How do you display maps and geocode addresses?

**What Claude defaults to:** Google Maps.

**Real options:**
- **Google Maps** — best coverage, complex pricing, costs spike with usage
- **Mapbox** — strong for custom-styled maps, generous free tier, predictable pricing
- **OpenStreetMap + Leaflet** — fully open source, self-hostable tiles, no API key required
- **Radar** — geofencing and location intelligence focus

**What lock-in looks like:** Map component and geocoding calls tied to one provider's API shape.

**The question that keeps options open longest:**
Does your community model have concerns about Google's data collection on your users' location behavior?

---

## Communication / Notifications

**The decision:** How do you reach users outside the product?

**What Claude defaults to:** Twilio for SMS.

**Real options:**
- **Twilio** — reliable, global, expensive per message
- **Knock** — notification infrastructure across all channels with a workflow builder
- **OneSignal** — push notifications focus, generous free tier
- **Novu** — open source, self-hostable, multi-channel, growing fast

**What lock-in looks like:** Notification logic coupled to one provider. Adding channels later means rebuilding the routing layer each time.

**The question that keeps options open longest:**
How many channels do you need now — and is it worth abstracting the notification layer so adding channels doesn't require rewriting routing logic?

---

## Database / Persistence Platform

**The decision:** Where does your data live and who manages the infrastructure?

**What Claude defaults to:** Postgres via Supabase for web apps, Firebase for rapid prototypes.

**Real options:**
- **Supabase** — Postgres with auth, storage, realtime bundled; open source and self-hostable
- **Neon** — serverless Postgres with branching, scale-to-zero, generous free tier
- **PlanetScale** — serverless MySQL with schema branching
- **Railway** — managed Postgres with simple deployment
- **Firebase / Firestore** — realtime and offline-first, fast to prototype, strong Google lock-in

**What lock-in looks like:** Data model and migration history tied to one platform. Moving a production database is the highest-risk migration a team can attempt.

**The question that keeps options open longest:**
Do you need your database to be self-hostable — and does your data sovereignty commitment require knowing exactly where user data lives?
