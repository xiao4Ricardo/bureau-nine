# SwiftCrew Backend – Agent Guide

This cheat sheet covers everything an agent needs to work on the SwiftCrew backend. When in doubt, follow existing patterns in `src/` rather than inventing new ones.

## Stack

- Java 17 + Spring Boot 3.4.3
- Spring Data JPA (Hibernate) + PostgreSQL 16
- Spring Security 6 with JWT (JJWT 0.12)
- Lombok for boilerplate reduction
- Gradle (Kotlin DSL) build system
- Docker Compose for local PostgreSQL

## Project Layout

```
src/main/java/com/swiftcrew/backend/
├── SwiftCrewApplication.java       # @SpringBootApplication entry point
├── common/
│   ├── ApiResponse.java            # Unified { code, message, data } envelope
│   ├── BaseEntity.java             # createdAt / updatedAt via @EntityListeners
│   ├── BusinessException.java      # Runtime exception with HTTP status
│   └── GlobalExceptionHandler.java # @RestControllerAdvice maps exceptions → ApiResponse
├── config/
│   ├── CorsConfig.java             # Allows localhost:5173 in dev
│   └── SecurityConfig.java        # JWT filter chain, public/protected paths
├── controller/                     # @RestController, thin — delegate to service
├── dto/                            # Request/response DTOs (no JPA annotations)
├── entity/                         # JPA entities extending BaseEntity
├── repository/                     # Spring Data JPA interfaces
├── security/
│   ├── JwtAuthenticationFilter.java
│   └── JwtProvider.java
└── service/
    ├── *.java                      # Service interfaces
    └── impl/
        └── *Impl.java              # Implementations
```

## Commands

- Start DB: `docker-compose up -d`
- Run app: `./gradlew bootRun`
- Run tests: `./gradlew test`
- Build JAR: `./gradlew build`
- Check deps: `./gradlew dependencies`

## Conventions

### Entities
- Extend `BaseEntity` (provides `id` UUID PK, `createdAt`, `updatedAt`).
- Use `@Table(name = "snake_case_plural")`.
- Lazy-load associations by default; fetch eagerly only when always needed.
- No business logic in entities.

### DTOs
- Separate `*Request` (inbound) and `*Response` / `*DTO` (outbound) classes.
- Use Lombok `@Data` / `@Builder` / `@NoArgsConstructor` / `@AllArgsConstructor`.
- Validate inbound DTOs with `@NotBlank`, `@Size`, `@Email`, etc.

### Services
- Interface + `Impl` pair in `service/` and `service/impl/`.
- All business logic lives here.
- Throw `BusinessException` for known error conditions; let Spring handle unexpected ones.
- `@Transactional` on write operations.

### Controllers
- Map to `/api/<resource>` (plural noun).
- Return `ApiResponse.success(data)` or `ApiResponse.error(...)` — never raw objects.
- Use `@Valid` on `@RequestBody` parameters.
- Keep controllers thin: validate input → call service → return response.

### Security
- `SecurityConfig` defines which paths are public (`/api/auth/**`) and which require JWT.
- Use `@PreAuthorize("hasRole('OWNER')")` for owner-only endpoints.
- Extract current user via `SecurityContextHolder` in services when needed.

### Error Handling
- `BusinessException(String message, HttpStatus status)` for known errors.
- `GlobalExceptionHandler` catches `BusinessException`, validation errors, and generic `Exception`.
- Never expose stack traces in API responses.

### Database
- `hibernate.ddl-auto: validate` in production — schema managed by `init-sql/` scripts.
- New tables/columns → add a new numbered SQL file in `init-sql/`.
- Always test migrations against a clean DB.

## API Response Envelope

```json
{ "code": 200, "message": "Success", "data": { ... } }
{ "code": 400, "message": "Validation failed", "data": null }
```

## Environment Variables

Required in `.env` (copy from `.env.example`):

| Variable | Example |
|----------|---------|
| `DB_HOST` | `localhost` |
| `DB_PORT` | `5432` |
| `DB_NAME` | `swiftcrew` |
| `DB_USER` | `swiftcrew` |
| `DB_PASSWORD` | `secret` |
| `JWT_SECRET` | 32+ char random string |

## Before Hand-off

- `./gradlew build` passes cleanly.
- New endpoints have role checks and input validation.
- Schema changes are in `init-sql/` with correct sequence number.
- Unit tests cover service layer business logic.
- No secrets committed; `.env.example` updated if new vars added.
