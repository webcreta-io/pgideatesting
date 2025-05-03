# Stage 1: Build the frontend
FROM node:18-alpine as frontend-builder

WORKDIR /app

# Copy package files first for better caching
COPY package*.json ./
COPY tailwind.config.js ./

# Install dependencies
RUN npm install

# Copy all frontend files
COPY . .

# Build the frontend (if needed - adjust based on your framework)
# RUN npm run build

# Stage 2: Build the backend (if you have Node.js backend)
FROM node:18-alpine as backend-builder

WORKDIR /api

# Copy backend package files
COPY api/package*.json ./

# Install backend dependencies
RUN npm install

# Copy backend source files
COPY api/ .

# Stage 3: Runtime image
FROM node:18-alpine

WORKDIR /app

# Install Vercel CLI (if needed)
RUN npm install -g vercel

# Copy built frontend from frontend-builder
COPY --from=frontend-builder /app .

# Copy built backend from backend-builder
COPY --from=backend-builder /api ./api

# Install production dependencies
RUN npm install --only=production

# Environment variables (adjust as needed)
ENV NODE_ENV=production
ENV PORT=3000

# Expose the application port
EXPOSE 3000

# Command to run the application
CMD ["sh", "-c", "vercel dev --listen 3000"]
