FROM node:20-slim AS base
ENV PNPM_HOME="/pnpm"
ENV PATH="$PNPM_HOME:$PATH"
RUN corepack enable

FROM base AS build-stage
COPY . /app
WORKDIR /app
RUN pnpm install
RUN pnpm run build

FROM base AS production-stage
WORKDIR /app
COPY --from=build-stage /app/.output /app
EXPOSE 3000
CMD ["node", "./server/index.mjs"]
