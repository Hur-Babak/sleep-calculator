# Generates PWA app icons (192x192, 512x512, and a 180x180 apple-touch-icon).
# Dark navy rounded-square background with a centred accent crescent moon.
# Uses System.Drawing (Windows PowerShell 5.1). Re-run to refresh.

Add-Type -AssemblyName System.Drawing

function New-Icon {
  param([int]$size, [string]$outPath, [bool]$rounded = $true)

  $bmp = New-Object System.Drawing.Bitmap $size, $size
  $g = [System.Drawing.Graphics]::FromImage($bmp)
  $g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias

  $c1 = [System.Drawing.Color]::FromArgb(255, 11, 16, 32)    # #0b1020
  $c2 = [System.Drawing.Color]::FromArgb(255, 26, 33, 64)    # #1a2140

  # Background (rounded square)
  $rect = New-Object System.Drawing.Rectangle 0, 0, $size, $size
  $bgBrush = New-Object System.Drawing.Drawing2D.LinearGradientBrush $rect, $c1, $c2, 135.0
  if ($rounded) {
    $r = [int]($size * 0.22)
    $path = New-Object System.Drawing.Drawing2D.GraphicsPath
    $d = $r * 2
    $path.AddArc(0, 0, $d, $d, 180, 90)
    $path.AddArc($size - $d, 0, $d, $d, 270, 90)
    $path.AddArc($size - $d, $size - $d, $d, $d, 0, 90)
    $path.AddArc(0, $size - $d, $d, $d, 90, 90)
    $path.CloseFigure()
    $g.SetClip($path)
  }
  $g.FillRectangle($bgBrush, $rect)

  # Crescent moon — accent circle with bg circle cut out
  $accent = [System.Drawing.Color]::FromArgb(255, 124, 158, 255)  # #7c9eff
  $moonBrush = New-Object System.Drawing.SolidBrush $accent
  $md = [int]($size * 0.52)
  $mx = [int](($size - $md) / 2) - [int]($size * 0.04)
  $my = [int](($size - $md) / 2)
  $g.FillEllipse($moonBrush, $mx, $my, $md, $md)
  $cutBrush = New-Object System.Drawing.SolidBrush $c1
  $off = [int]($md * 0.33)
  $g.FillEllipse($cutBrush, ($mx + $off), ($my - [int]($md * 0.12)), $md, $md)

  $bmp.Save($outPath, [System.Drawing.Imaging.ImageFormat]::Png)
  $g.Dispose()
  $bmp.Dispose()
  Write-Output "Generated: $outPath"
}

$root = Join-Path $PSScriptRoot "..\public"
New-Icon 192 (Join-Path $root "icon-192.png") $true
New-Icon 512 (Join-Path $root "icon-512.png") $true
New-Icon 180 (Join-Path $root "apple-touch-icon.png") $false
