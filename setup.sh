#!/bin/bash

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${BLUE}Setting up Medical Appointment System...${NC}"

# Check if pnpm is installed
if ! command -v pnpm &> /dev/null; then
    echo -e "${RED}pnpm is not installed. Please install it first.${NC}"
    echo "You can install it via npm: npm install -g pnpm"
    exit 1
fi

# Check if PostgreSQL is installed
if ! command -v psql &> /dev/null; then
    echo -e "${RED}PostgreSQL is not installed. Please install it first.${NC}"
    exit 1
fi

# Check if Redis is installed
if ! command -v redis-cli &> /dev/null; then
    echo -e "${RED}Redis is not installed. Please install it first.${NC}"
    exit 1
fi

# Install dependencies
echo -e "${GREEN}Installing dependencies...${NC}"
pnpm install

# Create .env files from examples
echo -e "${GREEN}Creating .env files...${NC}"
for service in services/*; do
  if [ -f "$service/.env.example" ]; then
    cp "$service/.env.example" "$service/.env"
    echo -e "Created ${service}/.env"
  fi
done

# Setup databases
echo -e "${GREEN}Creating databases...${NC}"
pnpm db:create

echo -e "${GREEN}Running migrations...${NC}"
pnpm db:migrate

echo -e "${GREEN}Seeding databases...${NC}"
pnpm db:seed

echo -e "${BLUE}Setup complete!${NC}"
echo -e "Run ${GREEN}pnpm dev${NC} to start all services"
echo -e "Or run ${GREEN}cd services/appointments_service && pnpm dev${NC} to start a specific service"
