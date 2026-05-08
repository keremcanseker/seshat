FROM oven/bun:1.3.12-alpine AS deps
WORKDIR /app
COPY package.json bun.lockb* ./
RUN bun install --frozen-lockfile --production=false

FROM oven/bun:1.3.12-alpine AS runner
WORKDIR /app
ENV NODE_ENV=production
COPY --from=deps /app/node_modules ./node_modules
COPY package.json tsconfig.json drizzle.config.ts ./
COPY src ./src
COPY drizzle ./drizzle

EXPOSE 3000

# Migrate sonra start. Coolify env'ine DATABASE_URL koymak yeterli.
CMD ["sh", "-c", "bun run src/db/migrate.ts && bun run src/index.ts"]
