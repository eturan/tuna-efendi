# Dockerfile for Backstage

# Use the official Node.js image as a base
FROM node:14

# Set the working directory
WORKDIR /app

# Copy package.json and yarn.lock
COPY package.json yarn.lock .

# Install dependencies
RUN yarn install --frozen-lockfile

# Copy the rest of the application
COPY . .

# Build the Backstage application
RUN yarn build

# Expose the application port
EXPOSE 7007

# Start the application
CMD ["yarn", "start"]
