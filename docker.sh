#!/bin/bash

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color

# Help message
function show_help {
  echo -e "${BLUE}Medical Appointment System - Docker Helper${NC}"
  echo ""
  echo "Usage: $0 COMMAND [SERVICE]"
  echo ""
  echo "Commands:"
  echo "  up           - Start all services or specific services if provided"
  echo "  down         - Stop all services"
  echo "  logs         - View logs for all services or specific services"
  echo "  restart      - Restart all services or specific services"
  echo "  migrate      - Run migrations for all services or specific services"
  echo "  seed         - Run seed data for all services or specific services"
  echo "  console      - Start Rails console for a specific service"
  echo "  test         - Run tests for all services or specific services"
  echo "  reset        - Reset database for all services or specific services"
  echo "  status       - Show status of all services"
  echo "  build        - Rebuild services (use after Gemfile changes)"
  echo ""
  echo "Examples:"
  echo "  $0 up                   - Start all services"
  echo "  $0 up appointments      - Start only the appointments service"
  echo "  $0 logs communications  - View logs for communications service"
  echo "  $0 migrate              - Run migrations for all services"
  echo "  $0 console users        - Start Rails console for users service"
  exit 1
}

# Check if docker-compose is installed
if ! command -v docker-compose &> /dev/null; then
    echo -e "${RED}docker-compose is not installed. Please install it first.${NC}"
    exit 1
fi

# Define services
SERVICES=("appointments" "communications" "log" "patient_records" "users" "video_calls")

# No arguments provided
if [ $# -eq 0 ]; then
  show_help
fi

# Parse command
CMD=$1
shift

case $CMD in
  up)
    if [ $# -eq 0 ]; then
      echo -e "${BLUE}Starting all services...${NC}"
      docker-compose up -d
    else
      echo -e "${BLUE}Starting services: $@${NC}"
      docker-compose up -d "$@"
    fi
    ;;
    
  down)
    echo -e "${BLUE}Stopping all services...${NC}"
    docker-compose down
    ;;
    
  logs)
    if [ $# -eq 0 ]; then
      echo -e "${BLUE}Showing logs for all services...${NC}"
      docker-compose logs -f
    else
      echo -e "${BLUE}Showing logs for: $@${NC}"
      docker-compose logs -f "$@"
    fi
    ;;
    
  restart)
    if [ $# -eq 0 ]; then
      echo -e "${BLUE}Restarting all services...${NC}"
      docker-compose restart
    else
      echo -e "${BLUE}Restarting services: $@${NC}"
      docker-compose restart "$@"
    fi
    ;;
    
  migrate)
    if [ $# -eq 0 ]; then
      echo -e "${BLUE}Running migrations for all services...${NC}"
      for service in "${SERVICES[@]}"; do
        echo -e "${YELLOW}Migrating $service...${NC}"
        docker-compose exec $service rails db:migrate
      done
    else
      for service in "$@"; do
        echo -e "${YELLOW}Migrating $service...${NC}"
        docker-compose exec $service rails db:migrate
      done
    fi
    ;;
    
  seed)
    if [ $# -eq 0 ]; then
      echo -e "${BLUE}Seeding all services...${NC}"
      for service in "${SERVICES[@]}"; do
        echo -e "${YELLOW}Seeding $service...${NC}"
        docker-compose exec $service rails db:seed
      done
    else
      for service in "$@"; do
        echo -e "${YELLOW}Seeding $service...${NC}"
        docker-compose exec $service rails db:seed
      done
    fi
    ;;
    
  console)
    if [ $# -eq 0 ]; then
      echo -e "${RED}Please specify a service name${NC}"
      show_help
    else
      echo -e "${BLUE}Starting Rails console for $1...${NC}"
      docker-compose exec $1 rails console
    fi
    ;;
    
  test)
    if [ $# -eq 0 ]; then
      echo -e "${BLUE}Running tests for all services...${NC}"
      for service in "${SERVICES[@]}"; do
        echo -e "${YELLOW}Testing $service...${NC}"
        docker-compose exec $service rails test
      done
    else
      for service in "$@"; do
        echo -e "${YELLOW}Testing $service...${NC}"
        docker-compose exec $service rails test
      done
    fi
    ;;
    
  reset)
    if [ $# -eq 0 ]; then
      echo -e "${BLUE}Resetting databases for all services...${NC}"
      for service in "${SERVICES[@]}"; do
        echo -e "${YELLOW}Resetting $service...${NC}"
        docker-compose exec $service rails db:reset
      done
    else
      for service in "$@"; do
        echo -e "${YELLOW}Resetting $service...${NC}"
        docker-compose exec $service rails db:reset
      done
    fi
    ;;
    
  status)
    echo -e "${BLUE}Checking status of all services...${NC}"
    docker-compose ps
    ;;
    
  build)
    if [ $# -eq 0 ]; then
      echo -e "${BLUE}Rebuilding all services...${NC}"
      docker-compose build
    else
      echo -e "${BLUE}Rebuilding services: $@${NC}"
      docker-compose build "$@"
    fi
    ;;
    
  *)
    echo -e "${RED}Unknown command: $CMD${NC}"
    show_help
    ;;
esac

exit 0
