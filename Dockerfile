# Use the official Node.js image as the base image for building Vue
FROM node:18 AS build-stage

# Set the working directory
WORKDIR /app

# Copy the package.json and package-lock.json files to install dependencies
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy the rest of the application code
COPY . .

# Build the Vue application
RUN npm run build

# Use the official Nginx image as the base image for serving the application
FROM nginx:1.21

# Copy the built app from the previous stage
COPY --from=builder /app/dist /usr/share/nginx/html

# Remove default NGINX website
RUN rm -rf /usr/share/nginx/html/*

# Copy custom nginx configuration
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Expose port 80
EXPOSE 80

# Command to run NGINX
CMD ["nginx", "-g", "daemon off;"]
