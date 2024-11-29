#!/bin/bash

# Set color codes for output
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${GREEN}Initializing development environment...${NC}"

# Create downloads directory if it doesn't exist
if [ ! -d "downloads" ]; then
  echo "Creating downloads directory..."
  mkdir -p downloads
  echo -e "${GREEN}✓ Created downloads directory${NC}"
else
  echo -e "${GREEN}✓ Downloads directory already exists${NC}"
fi

# Set up SSH directory and copy keys if needed
if [ ! -d ".ssh" ]; then
  echo "Setting up SSH directory..."
  mkdir -p .ssh

  # Check if user has SSH key
  if [ -f "$HOME/.ssh/id_rsa" ]; then
    echo "Copying SSH key from user's home directory..."
    cp "$HOME/.ssh/id_rsa" .ssh/
    chmod 600 .ssh/id_rsa
    echo -e "${GREEN}✓ SSH key copied successfully${NC}"
  else
    echo -e "${RED}Warning: No SSH key found in $HOME/.ssh/id_rsa${NC}"
    echo "You may need to generate an SSH key using: ssh-keygen -t rsa -b 4096"
  fi
else
  echo -e "${GREEN}✓ SSH directory already exists${NC}"
fi

# Ensure .gitignore exists and contains necessary entries
if [ ! -f ".gitignore" ]; then
  echo "Creating .gitignore..."
  touch .gitignore
fi

# Add necessary entries to .gitignore if they don't exist
for entry in ".env" ".ssh" "downloads/" "config/"; do
  if ! grep -q "^$entry$" .gitignore; then
    echo "$entry" >>.gitignore
    echo -e "${GREEN}✓ Added $entry to .gitignore${NC}"
  fi
done

echo -e "${GREEN}Development environment initialization complete!${NC}"
