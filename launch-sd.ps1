# 🧠 Squad Launcher: AMD Ryzen 7 5700G + RX 6650 XT 8GB
$timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
$logPath = ".\logs\launch.log"
$resConfig = ".\configs\resolution.txt"

# 🔍 Detect VRAM
$gpuInfo = Get-CimInstance Win32_VideoController | Where-Object { $_.AdapterRAM -gt 0 }
$vramMB = [math]::Round($gpuInfo.AdapterRAM / 1MB)

# 📖 Read resolution
$resolution = if (Test-Path $resConfig) { Get-Content $resConfig | Select-Object -First 1 } else { "512x512" }
$resParts = $resolution -split "x"
$width = [int]$resParts[0]
$height = [int]$resParts[1]


# 🔘 Toggle VRAM mode
$vramMode = if ($width -ge 512 -or $height -ge 512) { "--medvram" } else { "--lowvram" }

# 🧠 Build flags
$flags = "--use-directml --precision full --no-half $vramMode --disable-nan-check --skip-torch-cuda-test --loglevel INFO"

# 🐦 Squawk if VRAM is low
$squawk = if ($vramMB -lt 8000) { "🔴 SQUAWK! VRAM below optimal threshold." } else { "🟢 VRAM OK." }

# 📊 Log launch
Add-Content $logPath "`n[$timestamp] VRAM: $vramMB MB"
Add-Content $logPath "Resolution: $resolution"
Add-Content $logPath "Mode: $vramMode"
Add-Content $logPath "Flags: $flags"
Add-Content $logPath "Status: $squawk"

Write-Host "🧠 VRAM: $vramMB MB"
Write-Host "📐 Resolution: $resolution"
Write-Host "🔘 Mode: $vramMode"
Write-Host "🚀 Launching with flags: $flags"
Write-Host "$squawk"

# 🚀 Inject flags and launch WebUI
[System.Environment]::SetEnvironmentVariable("COMMANDLINE_ARGS", $flags, "Process")
Start-Process ".\webui-user.bat"