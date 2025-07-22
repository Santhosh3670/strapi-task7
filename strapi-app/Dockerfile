FROM node:20

# Set working directory
WORKDIR /app

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

