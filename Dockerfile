
# Stage 1: Build the application
FROM node:22-alpine AS builder

# Set the working directory
WORKDIR /app

# Copy package files
COPY package*.json ./

# Install dependencies
RUN npm ci

# Copy application source code
COPY . .

# Compile NestJS TypeScript code
RUN npm run build


# Stage 2: Create production image
FROM node:22-alpine AS production

# Set environment
ENV NODE_ENV=production
ENV PORT=3000

# Set working directory
WORKDIR /app

# Copy package files
COPY package*.json ./

# Install only production dependencies
RUN npm ci --omit=dev && npm cache clean --force

# Copy compiled application
COPY --from=builder /app/dist ./dist

# Expose application port
EXPOSE 3000

# Start NestJS application
CMD ["node", "dist/main.js"]