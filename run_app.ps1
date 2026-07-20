# ============================================================
#  Palmistry App - Smart Build & Run Script
#  Fixes: C drive bloat, 403 network errors, slow builds
# ============================================================

# --- 1. Move ALL caches to D drive (saves C drive space) ---
$env:GRADLE_USER_HOME    = "D:\.gradle"
$env:PUB_CACHE           = "D:\.pub-cache"
$env:FLUTTER_ROOT        = $env:FLUTTER_ROOT  # keep existing

# --- 2. Use Flutter China mirror (fixes 403 from Google Storage) ---
#     This mirror is publicly accessible worldwide, not just China
$env:FLUTTER_STORAGE_BASE_URL = "https://storage.flutter-io.cn"
$env:PUB_HOSTED_URL           = "https://pub.flutter-io.cn"

Write-Host ""
Write-Host "=== Palmistry App Builder ===" -ForegroundColor Cyan
Write-Host "  Gradle cache  -> D:\.gradle" -ForegroundColor Green
Write-Host "  Pub cache     -> D:\.pub-cache" -ForegroundColor Green
Write-Host "  Flutter mirror: storage.flutter-io.cn (bypasses 403)" -ForegroundColor Green
Write-Host ""

# --- 3. Choose what to do ---
$action = $args[0]

if ($action -eq "clean") {
    Write-Host "Cleaning build artifacts..." -ForegroundColor Yellow
    flutter clean
    Write-Host "Done!" -ForegroundColor Green

} elseif ($action -eq "build") {
    # Build only for x64 (your emulator = gphone16k x86 64)
    # This avoids downloading arm/arm64/x86 engine files
    Write-Host "Building APK for x64 emulator only..." -ForegroundColor Yellow
    flutter build apk --debug `
        --target-platform android-x64 `
        --android-skip-build-dependency-validation
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host ""
        Write-Host "SUCCESS! APK is at: build\app\outputs\flutter-apk\app-debug.apk" -ForegroundColor Green
    }

} elseif ($action -eq "run") {
    # Run directly on connected emulator
    Write-Host "Running on emulator..." -ForegroundColor Yellow
    flutter run --android-skip-build-dependency-validation

} elseif ($action -eq "run-arm") {
    # Run on a REAL physical Android device
    Write-Host "Running on physical device..." -ForegroundColor Yellow
    flutter run --android-skip-build-dependency-validation

} elseif ($action -eq "free-space") {
    # Show and clean up disk usage
    Write-Host "=== Cleaning up disk space ===" -ForegroundColor Yellow
    
    $flutterCache = "C:\src\flutter\bin\cache"
    $oldGradle    = "$env:USERPROFILE\.gradle"
    $oldPub       = "$env:USERPROFILE\AppData\Local\Pub\Cache"

    Write-Host "Removing Flutter bin cache from C drive..." -ForegroundColor Yellow
    if (Test-Path $flutterCache) {
        Remove-Item -Recurse -Force "$flutterCache\downloads" -ErrorAction SilentlyContinue
        Write-Host "  Cleared: $flutterCache\downloads" -ForegroundColor Green
    }

    Write-Host "Moving Gradle cache metadata check..."
    if (Test-Path $oldGradle) {
        $size = (Get-ChildItem $oldGradle -Recurse -ErrorAction SilentlyContinue | Measure-Object -Property Length -Sum).Sum
        Write-Host "  Old Gradle cache size on C: $([math]::Round($size/1MB, 1)) MB" -ForegroundColor Yellow
        Write-Host "  Run with 'build' or 'run' now and it will use D:\.gradle going forward." -ForegroundColor Cyan
    }

    Write-Host ""
    Write-Host "Done! Future builds will cache to D drive automatically." -ForegroundColor Green

} else {
    Write-Host "Usage:" -ForegroundColor Cyan
    Write-Host "  .\run_app.ps1 run          # Run on emulator" -ForegroundColor White
    Write-Host "  .\run_app.ps1 run-arm      # Run on physical Android phone" -ForegroundColor White
    Write-Host "  .\run_app.ps1 build        # Build debug APK (x64 only)" -ForegroundColor White
    Write-Host "  .\run_app.ps1 clean        # Clean build artifacts" -ForegroundColor White
    Write-Host "  .\run_app.ps1 free-space   # Show & clean C drive cache" -ForegroundColor White
    Write-Host ""
    Write-Host "Running on emulator by default..." -ForegroundColor Yellow
    flutter run --android-skip-build-dependency-validation
}
