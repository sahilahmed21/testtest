# Install dependencies based on the preferred package manager
FROM node:18-alpine AS base
WORKDIR /app
COPY . .

FROM base AS builder
WORKDIR /app/builder
COPY --from=base /app/package.json ./
RUN npm install
COPY --from=base /app .
RUN npm run build

FROM base AS runner
WORKDIR /app
COPY --from=builder /app/builder/public ./public
COPY --from=builder /app/builder/.next ./.next
COPY --from=builder /app/builder/node_modules ./node_modules
COPY --from=builder /app/builder/package.json ./package.json

EXPOSE 3000
CMD ["npm", "start"]