# Dealership Management System (DMS)

## Setup Instructions

### Prerequisites
- Docker
- Node.js

### Database Setup
1. Build and run PostgreSQL container:
   ```sh
   docker build -t dms-postgres -f Dockerfile.postgres .
   docker run -d --name dms-postgres -p 5432:5432 dms-postgres
