FROM node:20-alpine

WORKDIR /app

# Copy package files first (better caching)
COPY package*.json ./

# Install deps (prod only)
RUN npm ci --only=production --legacy-peer-deps

# Copy the rest of your source (including ts files)
COPY . .

# Build the app (creates /app/dist inside the container)
RUN npm run build

# Expose port
EXPOSE 3000

# Start the scheduler worker
CMD ["node", "dist/workers/scheduler.worker.js"]
