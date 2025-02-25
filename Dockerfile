# Dockerfile for Backstage

# Use the official Backstage image as a base
FROM ghcr.io/backstage/backstage:latest

# Set working directory
WORKDIR /app

# Copy custom configuration if needed
COPY app-config.yaml ./

# Expose the application port
EXPOSE 7007

# Start the application
CMD ["yarn", "start"]
