#!/bin/bash

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color

echo -e "${BLUE}Checking status of all services...${NC}"

# Check if docker-compose is installed
if ! command -v docker-compose &> /dev/null; then
    echo -e "${RED}docker-compose is not installed. Please install it first.${NC}"
    exit 1
fi

# Check if the containers are running
echo -e "${YELLOW}Database and Redis:${NC}"
docker-compose ps postgres redis | grep -v NAME

echo -e "\n${YELLOW}Web services:${NC}"
docker-compose ps appointments communications log patient_records users video_calls | grep -v NAME

echo -e "\n${YELLOW}Worker services:${NC}"
docker-compose ps appointments_worker communications_worker log_worker patient_records_worker users_worker video_calls_worker | grep -v NAME

# Check if databases are properly created
echo -e "\n${YELLOW}Checking databases...${NC}"
docker-compose exec postgres psql -U postgres -c '\l' | grep "_development" | awk '{print $1}'

# Check Rails services health endpoints
echo -e "\n${YELLOW}Checking health endpoints...${NC}"
services=("appointments:3001" "communications:3002" "log:3003" "patient_records:3004" "users:3005" "video_calls:3006")

for service in "${services[@]}"; do
  name="${service%%:*}"
  port="${service##*:}"
  echo -n "Checking $name (port $port): "
  if curl -s "http://localhost:$port/up" | grep -q "OK"; then
    echo -e "${GREEN}OK${NC}"
  else
    echo -e "${RED}FAIL${NC}"
  fi
done

echo -e "\n${BLUE}Done checking services!${NC}"
echo -e "If any services are not running, you can start them with: ${GREEN}docker-compose up -d${NC}"
echo -e "To see logs for a specific service: ${GREEN}docker-compose logs -f [service_name]${NC}"
