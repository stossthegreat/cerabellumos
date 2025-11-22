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

# Don't prune - we need prisma CLI for migrations at runtime
# (Prisma client is already generated and in node_modules/@prisma/client)

# Expose port
EXPOSE 8080

# Start the API server (not the worker!)
CMD ["npm", "start"]
