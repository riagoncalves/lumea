# Medical Appointment System

A comprehensive medical appointment management system built as a microservices architecture.

## Services

- **appointments_service**: Handles appointment scheduling, updates, and cancellations
- **communications_service**: Manages notifications via email, SMS, and other channels
- **log_service**: Centralized logging system
- **patient_records_service**: Manages patient medical records and documents
- **users_service**: Handles user authentication, authorization, and profile management
- **video_calls_service**: Facilitates telemedicine video consultations

## Tech Stack

- Ruby on Rails 8.0 for API backends
- PostgreSQL for databases
- Sidekiq for background job processing
- JWT for authentication
- Docker for containerization
- PNPM workspaces for monorepo management

## Development Setup

### Prerequisites

- Ruby 3.2+
- Node.js 18+
- PostgreSQL 14+
- Redis
- PNPM

### Installation

1. Clone the repository:
   ```
   git clone https://github.com/yourusername/thesis-monorepo.git
   cd thesis-monorepo
   ```

2. Install dependencies:
   ```
   pnpm install
   ```

3. Setup databases:
   ```
   pnpm db:create
   pnpm db:migrate
   pnpm db:seed
   ```

4. Start all services:
   ```
   pnpm dev
   ```

### Individual Service Development

To run a specific service:

```
cd services/appointments_service
pnpm dev
```

## Testing

Run tests across all services:

```
pnpm test
```

## Linting

Run linters across all services:

```
pnpm lint
```

Fix auto-correctable issues:

```
pnpm lint:fix
```

## Deployment

Each service can be deployed independently using Kamal:

```
cd services/appointments_service
bin/kamal deploy
```

## Architecture Overview

This monorepo is organized as a collection of microservices that communicate through RESTful APIs. Each service is responsible for a specific domain and can be deployed and scaled independently.

## Contributing

1. Create a feature branch
2. Make your changes
3. Ensure tests pass and code is linted
4. Submit a pull request

## License

MIT
