# Generates a branded Open Graph image (1200x630 PNG) for social/Pinterest previews.
# Uses System.Drawing (available in Windows PowerShell 5.1). Re-run to refresh.
# Output: public/og-default.png

Add-Type -AssemblyName System.Drawing

$W = 1200
$H = 630
$bmp = New-Object System.Drawing.Bitmap $W, $H
$g = [System.Drawing.Graphics]::FromImage($bmp)
$g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
$g.TextRenderingHint = [System.Drawing.Text.TextRenderingHint]::AntiAliasGridFit

# Background gradient (dark navy)
$bgRect = New-Object System.Drawing.Rectangle 0, 0, $W, $H
$c1 = [System.Drawing.Color]::FromArgb(255, 11, 16, 32)    # #0b1020
$c2 = [System.Drawing.Color]::FromArgb(255, 20, 26, 46)    # #141a2e
$bgBrush = New-Object System.Drawing.Drawing2D.LinearGradientBrush $bgRect, $c1, $c2, 135.0
$g.FillRectangle($bgBrush, $bgRect)

# Soft accent glow (top-left)
$glow = New-Object System.Drawing.Drawing2D.GraphicsPath
$glow.AddEllipse(-150, -200, 700, 700)
$pgb = New-Object System.Drawing.Drawing2D.PathGradientBrush $glow
$pgb.CenterColor = [System.Drawing.Color]::FromArgb(60, 124, 158, 255)
$pgb.SurroundColors = @([System.Drawing.Color]::FromArgb(0, 124, 158, 255))
$g.FillPath($pgb, $glow)

# Moon (crescent) — accent circle with bg circle cut out
$accent = [System.Drawing.Color]::FromArgb(255, 124, 158, 255)  # #7c9eff
$moonBrush = New-Object System.Drawing.SolidBrush $accent
$mx = 110; $my = 235; $md = 160
$g.FillEllipse($moonBrush, $mx, $my, $md, $md)
$cutBrush = New-Object System.Drawing.SolidBrush $c1
$g.FillEllipse($cutBrush, ($mx + 52), ($my - 18), $md, $md)

# Title text
$titleFont = New-Object System.Drawing.Font "Segoe UI", 84, ([System.Drawing.FontStyle]::Bold)
$whiteBrush = New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::White)
$g.DrawString("CycleBed", $titleFont, $whiteBrush, 320, 215)

# Subtitle text
$subFont = New-Object System.Drawing.Font "Segoe UI", 36, ([System.Drawing.FontStyle]::Regular)
$dimBrush = New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::FromArgb(255, 154, 163, 189))
$g.DrawString("Sleep Cycle Calculator & Tools", $subFont, $dimBrush, 322, 340)

# Bottom tagline
$tagFont = New-Object System.Drawing.Font "Segoe UI", 28, ([System.Drawing.FontStyle]::Regular)
$accentBrush = New-Object System.Drawing.SolidBrush $accent
$g.DrawString("cyclebed.com", $tagFont, $accentBrush, 322, 410)

# Save
$outPath = Join-Path $PSScriptRoot "..\public\og-default.png"
$bmp.Save($outPath, [System.Drawing.Imaging.ImageFormat]::Png)
$g.Dispose()
$bmp.Dispose()
Write-Output "Generated OG image: $outPath"
