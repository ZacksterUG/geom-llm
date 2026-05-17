# Docker Compose Setup for Stereometry Project

## Prerequisites
- Docker and Docker Compose installed
- At least 8 GB RAM (for Ollama model)
- Git (optional)

## Quick Start

1. **Copy environment variables:**
   ```bash
   cp .env.example .env
   ```
   Edit `.env` if you need to change defaults (passwords, ports).

2. **Start all services:**
   ```bash
   docker-compose up -d
   ```
   This will start:
   - PostgreSQL database (`geom-db`) on port 5432
   - PgAdmin web interface (`geom-pgadmin`) on port 5050
   - Ollama server (`geom-ollama`) on port 11434
   - Liquibase migration (`geom-liquibase`) - runs once and exits

3. **Pull the Ollama model (required once):**
   ```bash
   docker-compose --profile pull-model up geom-ollama-pull
   ```
   This will download the Qwen 2.5 7B model (~4.5 GB). Wait for completion.

4. **Verify services:**
   - PostgreSQL: `docker-compose logs geom-db`
   - Ollama: `curl http://localhost:11434/api/tags`
   - PgAdmin: Open http://localhost:5050 (login from .env)

## Service Details

### PostgreSQL (`geom-db`)
- Database: `stereometry_db`
- User/password: from `.env`
- Port: `5432` (mapped to host)
- Data volume: `geom-postgres-data`
- Healthcheck: `pg_isready`

### PgAdmin (`geom-pgadmin`)
- Web interface for database management
- Login: email/password from `.env`
- Port: `5050` → `80` in container
- Add server: host `geom-db`, port `5432`, database `stereometry_db`

### Ollama (`geom-ollama`)
- Local LLM server with Qwen 2.5 7B
- Port: `11434`
- Model volume: `geom-ollama-models`
- Healthcheck: API `/api/tags`

### Liquibase (`geom-liquibase`)
- Runs database migrations from `liquibase/` directory
- Executes once on startup (depends on healthy `geom-db`)
- Creates tables and inserts example tasks

### Network (`geom-network`)
- Internal Docker network for service communication
- All services use service names as hostnames

## Useful Commands

```bash
# View logs
docker-compose logs -f

# Stop all services
docker-compose down

# Stop and remove volumes (WARNING: deletes data)
docker-compose down -v

# Rebuild and restart
docker-compose up -d --build

# Check service status
docker-compose ps

# Access database directly
docker-compose exec geom-db psql -U geom_user -d stereometry_db

# Pull model manually (alternative)
docker-compose exec geom-ollama ollama pull qwen2.5:7b
```

## Troubleshooting

### Ollama model not loading
- Check if model is pulled: `docker-compose exec geom-ollama ollama list`
- Pull manually: `docker-compose --profile pull-model up geom-ollama-pull`
- Increase Docker memory allocation (Settings → Resources → Memory)

### Database connection issues
- Wait for PostgreSQL healthcheck (can take 30 seconds)
- Check logs: `docker-compose logs geom-db`
- Verify credentials in `.env` match Liquibase settings

### Port conflicts
- Change port mappings in `.env` (POSTGRES_PORT, PGADMIN_PORT, OLLAMA_PORT)
- Restart: `docker-compose down && docker-compose up -d`

## Next Steps
- Implement backend FastAPI service (uncomment in `docker-compose.yml`)
- Build frontend React application
- Update `.env` with backend/frontend configuration