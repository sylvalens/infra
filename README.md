# SylvaLens - Infrastructure

The deployment and orchestration hub for the SylvaLens multi-repository architecture.

## Platform Architecture
The SylvaLens platform consists of four repositories:
1. `sylvalens/frontend` (Next.js)
2. `sylvalens/backend` (NestJS)
3. `sylvalens/raster` (FastAPI)
4. `sylvalens/infra` (This repository)

## Local Development Loop
To run the full stack locally for development:

1. Clone all 4 repositories side-by-side in the same parent folder.
2. Ensure you have the `forest-res` datasets directory located alongside the repositories.
3. Validate your dataset structure:
   ```bash
   # Windows
   ./scripts/validate_data.ps1
   
   # Linux/macOS
   ./scripts/validate_data.sh
   ```
4. Start the database and raster service dependencies:
   ```bash
   docker-compose -f docker-compose.local.yml up -d
   ```
5. Navigate to the `backend` and `frontend` directories to run `pnpm run dev` natively.

## Production Deployment
The production stack uses an Nginx edge proxy to secure the internal network topology.

1. Configure the environment:
   ```bash
   cp .env.prod.example .env
   # Edit .env to set FOREST_DATA_ROOT, JWT_SECRET, etc.
   ```
2. Start the production stack:
   ```bash
   docker-compose -f docker-compose.prod.yml up -d --build
   ```

Nginx will route `/api/*` to the NestJS backend and all other traffic to the Next.js frontend. The PostGIS database and Raster services are completely isolated on the internal Docker network.