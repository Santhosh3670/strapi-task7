<<<<<<< HEAD
<<<<<<< HEAD
FROM node:20
=======
# Use latest Node 20 Alpine image
FROM node:20-alpine
>>>>>>> 1ab85181 (Initial commit: Strapi project with Docker setup)
=======
>>>>>>> bcf28e48 ( created ngnix service and all 3 containers running in port 80)

FROM node:20

WORKDIR /app

<<<<<<< HEAD
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
=======

>>>>>>> bcf28e48 ( created ngnix service and all 3 containers running in port 80)
COPY package*.json ./
RUN npm install


COPY . .


EXPOSE 1337


CMD ["npm", "run", "develop"]
>>>>>>> 1ab85181 (Initial commit: Strapi project with Docker setup)

