FROM node:20-alpine

WORKDIR /app

# Copy package files first (better caching)
COPY package*.json ./
COPY prisma ./prisma

# Install ALL dependencies (including dev deps - needed for build)
RUN npm ci --legacy-peer-deps

# Copy the rest of your source (including ts files)
COPY . .

# Generate Prisma client and build TypeScript
RUN npx prisma generate && npm run build

# Remove dev dependencies to reduce image size
RUN npm prune --production --legacy-peer-deps

# Expose port
EXPOSE 3000

# Start the scheduler worker
CMD ["node", "dist/workers/scheduler.worker.js"]
