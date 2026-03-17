# SwiftCrew CRM – Agent Guide

This cheat sheet captures the minimum context an agent needs to work on the SwiftCrew CRM system. When in doubt, prefer the existing patterns in the codebase over inventing new ones.

SwiftCrew is a Zoho Bigin-style deal pipeline CRM for SMBs managing business affairs. The star feature is a **Kanban pipeline board** with drag-and-drop for both deal cards (cross-column) and stage columns (reorder). Frontend is a responsive Vue 3 Web App; backend provides RESTful APIs. The two are fully decoupled—always keep them in sync.

## Core Priorities

- Ship pragmatically: favour working solutions over over-engineering.
- Keep types in sync: frontend TS interfaces in `src/types/` must mirror backend DTOs/Entities.
- Maintain polish: run lint/format/type-check before handing work back.
- Guard responsiveness: every page must work on both mobile (cards, hamburger menu) and desktop (tables, sidebar).
- Stay secure: never hardcode secrets; always validate at system boundaries.

## Repository Layout

- `swiftcrew-frontend/` — Vue 3 + TypeScript + Tailwind CSS (see its own `CLAUDE.md`)
- `swiftcrew-backend/` — Java 17 + Spring Boot 3 + PostgreSQL (see its own `CLAUDE.md`)
- `.claude/agents/` — shared AI agents (code-reviewer, test-writer, security-auditor)
- `Reference/` — Zoho Bigin screenshots (target UI reference)
- `example/` — competitor screenshots for UI reference

## Stack Snapshot

| Layer | Tech |
|-------|------|
| Frontend | Vue 3 (Composition API) + TypeScript + Vite |
| Styling | Tailwind CSS v4 (`@theme` tokens in `src/assets/main.css`) + lucide-vue-next |
| State | Pinia stores, Axios with interceptors |
| Backend | Java 17, Spring Boot 3.4, Spring Data JPA, Spring Security (JWT) |
| Database | PostgreSQL 16 (Docker), Hibernate validate mode |
| Build | Gradle (backend), npm + Vite (frontend) |

## Local Startup

```bash
cd swiftcrew-backend && docker-compose up -d   # PostgreSQL
cd swiftcrew-backend && ./gradlew bootRun       # Backend → :8080
cd swiftcrew-frontend && npm install && npm run dev  # Frontend → :5173
```

## Modules

| Module | Route | Description |
|--------|-------|-------------|
| Pipelines | `/pipelines` | Kanban board — drag deals between stages, drag-reorder columns |
| Contacts | `/contacts` | Table view with company, owner, search, pagination |
| Companies | `/companies` | Table view with phone, website, owner |
| Products | `/products` | Catalog list + detail page with tabs (Timeline, Pipelines, Files, Tasks) |
| Activities | `/activities` | Custom CSS-grid calendar (month/week/day) with Tasks/Events/Calls |
| Dashboard | `/dashboard` | Stat cards + "Open Deals by Stage" bar chart |

## Business Roles

- **OWNER**: full access — all modules, full CRUD.
- **TECHNICIAN**: limited access — own deals and activities only.

## API Contract

- Unified JSON response: `{ code, message, data }`.
- Auth: JWT Bearer token in `Authorization` header, stored in `localStorage`.
- Base path: `/api/` (e.g. `/api/pipelines`, `/api/deals`, `/api/contacts`).
- Pagination: `page` (0-based), `size` (default 20), `sort` param.
- Error codes: 400 validation, 401 auth, 403 forbidden, 404 not found, 409 conflict, 500 server error.

## Git Workflow

- Never push to `main` directly; open a PR from a feature branch.
- Branch naming: `feat/<name>`, `fix/<name>`, `refactor/<scope>`.
- Commits: Conventional Commits format — `feat(pipelines): add stage reorder endpoint`.
- Merge PRs with squash only to keep `main` history clean.

## Database Conventions

- All primary keys: UUID.
- Table names: snake_case plural (`pipelines`, `deals`, `contacts`, `companies`, `products`, `activities`).
- DDL: `hibernate.ddl-auto: validate`. Schema changes go in `init-sql/` as numbered SQL files.
- Time storage: UTC in backend, frontend converts for display.

## Working Agreements

### Do

- Use `<script setup lang="ts">` for all Vue components.
- Fetch data through `src/api/` modules with typed Axios calls.
- Use Tailwind utility classes; design tokens live in `src/assets/main.css` `@theme` block.
- Use `lucide-vue-next` for all icons (nav: 24px, buttons: 20px, helpers: 16px).
- Follow Controller → Service → Repository layering on backend; never skip layers.
- Extend `BaseEntity` for all JPA entities (provides `createdAt`/`updatedAt`).
- Use Lombok (`@Data`, `@Builder`, `@NoArgsConstructor`) to reduce boilerplate.
- Write meaningful tests: Vitest for frontend, JUnit 5 + Mockito for backend.

### Don't

- Hardcode API paths in `.vue` files—define them in `src/api/`.
- Use Options API, `any` type, or raw `fetch`.
- Hardcode hex/rgb colours—use Tailwind palette or `primary-*` tokens.
- Skip error handling: frontend `catch` + backend `GlobalExceptionHandler`.
- Commit console debugging, unchecked promises, or failing lint/type checks.
- Cross layers on backend (e.g. Controller calling Repository directly).
- Commit `.env` files or secrets—only `.env.example` templates.

## Environment Setup

- Node.js 20+, Java 17+.
- Copy `.env.example` to `.env` in backend; required vars: `DB_HOST`, `DB_PORT`, `DB_NAME`, `DB_USER`, `DB_PASSWORD`, `JWT_SECRET`.
- Frontend connects to `http://localhost:8080` via Axios; backend CORS allows `http://localhost:5173`.

## Testing

- Frontend: `cd swiftcrew-frontend && npx vitest run` (Vitest + @vue/test-utils + jsdom)
- Backend: `cd swiftcrew-backend && ./gradlew test` (JUnit 5 + Mockito + @DataJpaTest)
- New features must include unit tests; bug fixes start with a failing test.

## Before Hand-off

- Frontend TS types and backend DTOs are in sync.
- API endpoints have proper error handling on both sides.
- Mobile + desktop responsive layouts verified.
- New APIs have role-based access control.
- Database changes reflected in `init-sql/` scripts.
- Environment variable changes reflected in `.env.example`.
- `@security-auditor` scan passes (no High-level issues).

Stay pragmatic, stay typed, and keep the UI responsive.
