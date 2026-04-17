# MELODIESPARK ENGINE v1.0.0
# PowerShell Build & Application Generator

param(
    [ValidateSet("Build","Deploy","Full","GenerateApp","HealthCheck","Clean")]
    [string]$Action = "Full",
    [ValidateSet("development","staging","production")]
    [string]$Environment = "development",
    [string]$Version = "0.1.0"
)

$ProjectRoot = Split-Path -Parent $MyInvocation.MyCommandPath
$Timestamp = Get-Date -Format "yyyy-MM-dd_HH-mm-ss"

Write-Host "╔════════════════════════════════════════════════════════════╗" -ForegroundColor Cyan
Write-Host "║     MELODIESPARK ENGINE v1.0.0" -ForegroundColor Cyan
Write-Host "║     Production Build & Application Generator" -ForegroundColor Cyan
Write-Host "╚════════════════════════════════════════════════════════════╝" -ForegroundColor Cyan

Write-Host "`nAction: $Action | Environment: $Environment | Version: $Version`n" -ForegroundColor Green

# Create Logs directory
$LogsDir = Join-Path $ProjectRoot "Logs"
if (-not (Test-Path $LogsDir)) { New-Item -ItemType Directory -Path $LogsDir | Out-Null }

# Create Release Build directory
$ReleaseBuild = Join-Path $ProjectRoot "ReleaseBuild"
if (-not (Test-Path $ReleaseBuild)) { New-Item -ItemType Directory -Path $ReleaseBuild | Out-Null }

# Create Generated App directory
$GenApp = Join-Path $ProjectRoot "GeneratedApp"
if (-not (Test-Path $GenApp)) { New-Item -ItemType Directory -Path $GenApp | Out-Null }

function Write-Success { Write-Host "✓ $args" -ForegroundColor Green }
function Write-Error-Log { Write-Host "✗ $args" -ForegroundColor Red }
function Write-Info { Write-Host "→ $args" -ForegroundColor Cyan }

switch ($Action) {
    "Build" {
        Write-Info "Installing dependencies..."
        Push-Location $ProjectRoot
        pnpm install --frozen-lockfile
        Write-Info "Building packages..."
        pnpm -r build
        Pop-Location
        Write-Success "Build completed"
    }
    "Deploy" {
        Write-Info "Building Docker images..."
        Push-Location $ProjectRoot
        docker-compose build
        Write-Info "Starting services..."
        docker-compose up -d
        Start-Sleep -Seconds 10
        Write-Info "Running health checks..."
        docker-compose ps
        Pop-Location
        Write-Success "Deployment completed"
    }
    "Full" {
        Write-Info "Starting FULL pipeline..."
        Push-Location $ProjectRoot
        
        Write-Info "Step 1: Install dependencies"
        pnpm install --frozen-lockfile
        
        Write-Info "Step 2: Lint code"
        pnpm lint
        
        Write-Info "Step 3: Build packages"
        pnpm -r build
        
        Write-Info "Step 4: Build Docker images"
        docker-compose build
        
        Write-Info "Step 5: Start services"
        docker-compose up -d
        Start-Sleep -Seconds 10
        
        Write-Info "Step 6: Run health check"
        docker-compose ps
        
        Pop-Location
        Write-Success "Full pipeline completed"
    }
    "GenerateApp" {
        Write-Info "Generating WPF Application..."
        
        # Create app structure
        $appDirs = @("Modules", "Services", "Models", "ViewModels", "Views", "Properties", "Resources")
        foreach ($dir in $appDirs) {
            $path = Join-Path $GenApp $dir
            if (-not (Test-Path $path)) {
                New-Item -ItemType Directory -Path $path | Out-Null
                Write-Success "Created $dir"
            }
        }
        
        Write-Success "WPF Application structure generated"
        Write-Info "Location: $GenApp"
    }
    "HealthCheck" {
        Write-Info "Running health checks..."
        Push-Location $ProjectRoot
        
        try {
            $api = Invoke-WebRequest -Uri "http://localhost:3000" -TimeoutSec 5 -UseBasicParsing
            Write-Success "API responding (3000)"
        } catch {
            Write-Error-Log "API not responding"
        }
        
        try {
            $web = Invoke-WebRequest -Uri "http://localhost:3001" -TimeoutSec 5 -UseBasicParsing
            Write-Success "Web responding (3001)"
        } catch {
            Write-Error-Log "Web not responding"
        }
        
        Write-Info "Container status:"
        docker-compose ps
        
        Pop-Location
    }
    "Clean" {
        Write-Info "Cleaning up..."
        Push-Location $ProjectRoot
        docker-compose down
        Remove-Item -Path "*/dist" -Recurse -Force -ErrorAction SilentlyContinue
        Remove-Item -Path "*/.next" -Recurse -Force -ErrorAction SilentlyContinue
        Pop-Location
        Write-Success "Cleanup completed"
    }
}

Write-Host "`n✓ Engine execution completed`n" -ForegroundColor Green
