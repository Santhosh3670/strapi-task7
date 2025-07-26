FROM node:20

# Set working directory
WORKDIR /app

# Install OS dependencies
RUN apt-get update && apt-get install -y netcat-openbsd

# Copy only dependency declarations first for better Docker caching
COPY package*.json ./

# Install dependencies (strapi and others)
RUN npm install --legacy-peer-deps

# Copy the rest of the app
COPY . .

# Build the Strapi app
RUN npm run build

# Expose the Strapi port
EXPOSE 1337

# Start the app
CMD ["npm", "start"]

