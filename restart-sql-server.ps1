# ========================================
# TỰ ĐỘNG TÌM VÀ RESTART SQL SERVER
# Chạy với quyền Administrator
# ========================================

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  TỰ ĐỘNG RESTART SQL SERVER" -ForegroundColor Cyan
Write-Host "========================================`n" -ForegroundColor Cyan

# Kiểm tra quyền Admin
$isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

if (-not $isAdmin) {
    Write-Host "❌ Cần quyền Administrator!" -ForegroundColor Red
    Write-Host "💡 Click phải PowerShell → Run as Administrator`n" -ForegroundColor Yellow
    Read-Host "Press Enter to exit"
    exit
}

Write-Host "✅ Running with Administrator privileges`n" -ForegroundColor Green

# Tìm tất cả SQL Server services
Write-Host "[1/3] Tìm SQL Server services..." -ForegroundColor Yellow

$sqlServices = Get-Service -Name "*SQL*" -ErrorAction SilentlyContinue | Where-Object {
    $_.Name -like "MSSQL*" -or $_.Name -eq "MSSQLSERVER"
}

if ($sqlServices.Count -eq 0) {
    Write-Host "  ❌ Không tìm thấy SQL Server service!" -ForegroundColor Red
    Write-Host "  💡 Kiểm tra SQL Server đã cài đặt chưa`n" -ForegroundColor Yellow
    Read-Host "Press Enter to exit"
    exit
}

Write-Host "  ✅ Tìm thấy $($sqlServices.Count) service(s):`n" -ForegroundColor Green

foreach ($service in $sqlServices) {
    $statusColor = if ($service.Status -eq "Running") { "Green" } else { "Yellow" }
    Write-Host "     • $($service.DisplayName)" -ForegroundColor Gray
    Write-Host "       Name: $($service.Name)" -ForegroundColor Gray
    Write-Host "       Status: $($service.Status)" -ForegroundColor $statusColor
    Write-Host ""
}

# Restart services
Write-Host "[2/3] Restarting SQL Server services..." -ForegroundColor Yellow

foreach ($service in $sqlServices) {
    try {
        Write-Host "  → Restarting: $($service.DisplayName)..." -ForegroundColor Gray
        
        if ($service.Status -eq "Running") {
            Stop-Service -Name $service.Name -Force -ErrorAction Stop
            Start-Sleep -Seconds 2
        }
        
        Start-Service -Name $service.Name -ErrorAction Stop
        Start-Sleep -Seconds 2
        
        $newStatus = (Get-Service -Name $service.Name).Status
        if ($newStatus -eq "Running") {
            Write-Host "  ✅ $($service.DisplayName) restarted!" -ForegroundColor Green
        } else {
            Write-Host "  ⚠️  $($service.DisplayName) status: $newStatus" -ForegroundColor Yellow
        }
        
    } catch {
        Write-Host "  ❌ Failed to restart $($service.DisplayName): $($_.Exception.Message)" -ForegroundColor Red
    }
}

# Kiểm tra SQL Browser
Write-Host "`n[3/3] Checking SQL Server Browser..." -ForegroundColor Yellow

try {
    $browser = Get-Service -Name "SQLBrowser" -ErrorAction Stop
    
    if ($browser.Status -ne "Running") {
        Write-Host "  → Starting SQL Browser..." -ForegroundColor Gray
        Start-Service -Name "SQLBrowser"
        Set-Service -Name "SQLBrowser" -StartupType Automatic
        Write-Host "  ✅ SQL Browser started!" -ForegroundColor Green
    } else {
        Write-Host "  ✅ SQL Browser already running!" -ForegroundColor Green
    }
    
} catch {
    Write-Host "  ⚠️  SQL Browser not available" -ForegroundColor Yellow
}

# Summary
Write-Host "`n========================================" -ForegroundColor Cyan
Write-Host "  SUMMARY" -ForegroundColor Cyan
Write-Host "========================================`n" -ForegroundColor Cyan

Write-Host "✅ SQL Server restart completed!`n" -ForegroundColor Green

Write-Host "📝 Next steps:" -ForegroundColor Yellow
Write-Host "   1. Open SSMS (SQL Server Management Studio)" -ForegroundColor Gray
Write-Host "   2. Run the complete setup script (see below)" -ForegroundColor Gray
Write-Host "   3. Run: node server-sql-auth.js`n" -ForegroundColor Gray

Write-Host "📋 Complete SQL Script (run in SSMS):" -ForegroundColor Yellow
Write-Host @"
-- Copy this into SSMS and press F5:

USE master;
GO
EXEC xp_instance_regwrite N'HKEY_LOCAL_MACHINE', N'Software\Microsoft\MSSQLServer\MSSQLServer', N'LoginMode', REG_DWORD, 2;
GO

CREATE LOGIN hamtuser WITH PASSWORD = 'HamtPass123!';
GO

CREATE DATABASE [HAMT.SQL];
GO

USE [HAMT.SQL];
GO

CREATE USER hamtuser FOR LOGIN hamtuser;
GO

ALTER ROLE db_datareader ADD MEMBER hamtuser;
ALTER ROLE db_datawriter ADD MEMBER hamtuser;
GO
"@ -ForegroundColor Gray

Write-Host "`n========================================`n" -ForegroundColor Cyan

Read-Host "Press Enter to exit"

