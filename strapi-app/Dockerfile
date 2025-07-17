<<<<<<< HEAD
FROM node:20
=======
# Use latest Node 20 Alpine image
FROM node:20-alpine
>>>>>>> 1ab85181 (Initial commit: Strapi project with Docker setup)

# Set working directory
WORKDIR /app

<<<<<<< HEAD
# Copy dependency files
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy the full project, including .env
COPY . .

# Copy .env file explicitly (in case it's in .dockerignore)

# Build Strapi for production
RUN npm run build

# Expose Strapi's default port
EXPOSE 1337

# Start Strapi in production mode
CMD ["npm", "start"]
=======
# Copy only package files and install dependencies first (caching)
COPY package*.json ./
RUN npm install

# Copy the rest of the app
COPY . .

# Expose Strapi default port
EXPOSE 1337

# Set environment variables from .env file (optional but recommended)
# NOTE: .env should be in project root and will be read by Strapi

# Run Strapi in development mode
CMD ["npm", "run", "develop"]
>>>>>>> 1ab85181 (Initial commit: Strapi project with Docker setup)

