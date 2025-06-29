# Use Node base image
FROM node:18-alpine

# Set working directory
WORKDIR /app

# Copy app code
COPY app.js .

# Expose port
EXPOSE 3000

# Start the server
CMD ["node", "app.js"]
