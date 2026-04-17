# ENGINE USAGE GUIDE

## Quick Start

### Full Pipeline (Build + Deploy + Generate App)
```powershell
.\Engine.ps1 -Action "Full" -Environment "development"
```

### Build Only
```powershell
.\Engine.ps1 -Action "Build" -Environment "development"
```

### Deploy Only
```powershell
.\Engine.ps1 -Action "Deploy" -Environment "development"
```

### Generate WPF Application
```powershell
.\Engine.ps1 -Action "GenerateApp"
```

### Health Check Services
```powershell
.\Engine.ps1 -Action "HealthCheck"
```

### Package Release
```powershell
.\Engine.ps1 -Action "Package" -Version "0.1.0"
```

### Clean & Reset
```powershell
.\Engine.ps1 -Action "Clean"
```

## Parameters

- `-Action` - Pipeline phase (Full|Build|Deploy|Test|GenerateApp|Package|HealthCheck|Clean)
- `-Environment` - Target environment (development|staging|production)
- `-Version` - Release version (default: 0.1.0)
- `-Verbose` - Enable verbose logging
- `-NoDeploy` - Skip deployment phase

## Examples

### Development Build
```powershell
.\Engine.ps1 -Action "Full" -Environment "development" -Verbose
```

### Production Build & Package
```powershell
.\Engine.ps1 -Action "Full" -Environment "production" -Version "1.0.0"
```

### Just Lint and Build
```powershell
.\Engine.ps1 -Action "Build" -Environment "staging"
```

## What the Engine Does

### Full Pipeline
1. ✓ Check prerequisites (Node, pnpm, Docker, Git)
2. ✓ Load environment variables
3. ✓ Install dependencies (pnpm install)
4. ✓ Run linters (ESLint, TypeScript)
5. ✓ Build packages (API, Web, shared packages)
6. ✓ Build Docker images (multi-stage)
7. ✓ Start Docker services (PostgreSQL, Redis, API, Web)
8. ✓ Initialize database (migrations + seed)
9. ✓ Health check endpoints
10. ✓ Generate WPF application
11. ✓ Package release artifacts

## Output

### Logs
- Location: `Logs/Engine_YYYY-MM-DD_HH-MM-SS.log`
- Includes: timestamps, levels, and detailed output

### Build Artifacts
- API: `ReleaseBuild/api/` (NestJS dist)
- Web: `ReleaseBuild/web/` (.next)
- App: `ReleaseBuild/app/` (WPF)
- Manifest: `ReleaseBuild/MANIFEST.json`

### Generated App
- Location: `GeneratedApp/`
- Structure: XAML files, C# modules, project file

## Endpoints

After deployment:
- API: http://localhost:3000
- Web: http://localhost:3001
- Database: localhost:5432
- Redis: localhost:6379

## Troubleshooting

### Prerequisites Check Fails
```powershell
# Install Node.js 20
# https://nodejs.org

# Install pnpm
npm install -g pnpm@9

# Install Docker
# https://docker.com
```

### Docker Build Fails
```powershell
# Check Docker daemon
docker version

# Clean Docker
docker system prune -a

# Rebuild
.\Engine.ps1 -Action "Deploy"
```

### Services Not Responding
```powershell
# Check service status
docker-compose ps

# View logs
docker-compose logs -f api
docker-compose logs -f web

# Restart services
docker-compose restart
```

### Build Fails
```powershell
# Clean build
.\Engine.ps1 -Action "Clean"

# Full rebuild
.\Engine.ps1 -Action "Full" -Environment "development"
```

## Color Coding

- 🟢 Green: Success messages
- 🔴 Red: Error messages
- 🟡 Yellow: Warnings
- 🔵 Cyan: Info messages
- ⚫ Gray: Neutral output

## Performance

Typical execution times:
- Full Pipeline: 5-10 minutes
- Build Only: 2-3 minutes
- Deploy Only: 1-2 minutes
- Health Check: 30 seconds
- WPF Generation: 10 seconds

## Advanced Usage

### Custom Environment
```powershell
# Edit .env before running
$env:DATABASE_HOST = "custom-db-host"
$env:API_PORT = "3001"

.\Engine.ps1 -Action "Full"
```

### Parallel Builds
```powershell
# Build in development, deploy to staging
.\Engine.ps1 -Action "Build" -Environment "development"
.\Engine.ps1 -Action "Deploy" -Environment "staging"
```

### Scheduled Builds
```powershell
# Windows Task Scheduler
# Trigger: Daily at 2 AM
# Action: powershell.exe -File "C:\path\to\Engine.ps1" -Action "Full" -Environment "production"
```

---

For more details, see README.md and CONTRIBUTING.md
