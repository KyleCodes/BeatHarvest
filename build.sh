#!/bin/bash

# Set color codes for output
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${GREEN}Starting build process...${NC}"

# Check if .env file exists
if [ ! -f ".env" ]; then
  echo -e "${RED}Error: .env file not found in current directory${NC}"
  exit 1
fi

# Build and start the container
echo "Building and starting Docker container..."
docker-compose up -d --build

# Wait for container to be ready (adjust sleep time if needed)
echo "Waiting for container to start..."
sleep 5

# Get container ID
CONTAINER_ID=$(docker ps -qf "name=backend-music-downloader")

if [ -z "$CONTAINER_ID" ]; then
  echo -e "${RED}Error: Container not found${NC}"
  exit 1
fi

# Copy .env file to container
echo "Copying .env file to container..."
docker cp .env "${CONTAINER_ID}:/app/BeatHarvest/.env"

if [ $? -eq 0 ]; then
  echo -e "${GREEN}✓ .env file copied successfully${NC}"
  echo -e "${GREEN}Build process complete!${NC}"
  echo "You can now connect to the container using: ssh root@localhost -p 2222"
  echo "Password: BeatHarvest"
else
  echo -e "${RED}Error: Failed to copy .env file${NC}"
  exit 1
fi
