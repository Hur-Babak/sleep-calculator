# Generates programmatic SEO pages for common wake-up times.
# Re-run anytime to refresh. Output: public/sleep/wake-at-<slug>/index.html
# All non-ASCII characters in HTML output use HTML entities to be immune to
# PowerShell encoding quirks (Windows PowerShell 5.1 reads .ps1 as Windows-1252
# unless a UTF-8 BOM is present).

$wakeTimes = @(
  @{ hour = 5;  minute = 0;  label = "5:00 AM";  slug = "5am" },
  @{ hour = 6;  minute = 0;  label = "6:00 AM";  slug = "6am" },
  @{ hour = 6;  minute = 30; label = "6:30 AM";  slug = "6-30am" },
  @{ hour = 7;  minute = 0;  label = "7:00 AM";  slug = "7am" },
  @{ hour = 7;  minute = 30; label = "7:30 AM";  slug = "7-30am" },
  @{ hour = 8;  minute = 0;  label = "8:00 AM";  slug = "8am" }
)

$CYCLE = 90
$FALL_ASLEEP = 15

function Format-Bedtime {
  param([int]$wakeHour, [int]$wakeMin, [int]$cycles)
  $wakeTotal = $wakeHour * 60 + $wakeMin
  $bedTotal = $wakeTotal - ($cycles * $CYCLE + $FALL_ASLEEP)
  while ($bedTotal -lt 0) { $bedTotal += 1440 }
  $h = [math]::Floor($bedTotal / 60)
  $m = $bedTotal % 60
  $period = if ($h -ge 12) { "PM" } else { "AM" }
  $h12 = if ($h -eq 0) { 12 } elseif ($h -gt 12) { $h - 12 } else { $h }
  return ("{0}:{1:D2} {2}" -f $h12, $m, $period)
}

$outRoot = Join-Path $PSScriptRoot "..\public\sleep"
New-Item -ItemType Directory -Path $outRoot -Force | Out-Null

$siblingsHtml = ($wakeTimes | ForEach-Object {
  "    <li><a href=`"/sleep/wake-at-$($_.slug)/`">Wake up at $($_.label)</a></li>"
}) -join "`n"

foreach ($wt in $wakeTimes) {
  $t6 = Format-Bedtime $wt.hour $wt.minute 6
  $t5 = Format-Bedtime $wt.hour $wt.minute 5
  $t4 = Format-Bedtime $wt.hour $wt.minute 4
  $t3 = Format-Bedtime $wt.hour $wt.minute 3

  $label = $wt.label
  $slug = $wt.slug

  $html = @"
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Wake up at $label &mdash; What time to go to bed | CycleBed</title>
<meta name="description" content="If you need to wake up at $label, here are the best bedtimes based on 90-minute sleep cycles. Wake up refreshed instead of groggy.">
<meta name="robots" content="index, follow">
<link rel="canonical" href="https://cyclebed.com/sleep/wake-at-$slug/">
<link rel="icon" type="image/svg+xml" href="/favicon.svg">

<script async src="https://pagead2.googlesyndication.com/pagead/js/adsbygoogle.js?client=ca-pub-9728714289190766" crossorigin="anonymous"></script>

<link rel="stylesheet" href="/style.css">
</head>
<body>

<header class="site-header">
  <div class="container">
    <a href="/" class="logo">
      <svg class="logo-icon" width="22" height="22" viewBox="0 0 24 24" fill="#7c9eff" aria-hidden="true"><path d="M21 12.8A9 9 0 1 1 11.2 3a7 7 0 0 0 9.8 9.8z"/></svg>
      <span>CycleBed</span>
    </a>
  </div>
</header>

<main>
  <article class="container article">
    <h1>What time to sleep to wake up at $label</h1>
    <p class="lead">If your alarm is set for <strong>$label</strong>, here are the bedtimes that align with full 90-minute sleep cycles &mdash; so you wake up between cycles instead of in the middle of deep sleep.</p>

    <div class="bedtime-table">
      <div class="bedtime-row recommended">
        <div class="bedtime-time">$t6</div>
        <div class="bedtime-meta"><strong>6 cycles</strong> &middot; 9 hours &middot; <span class="quality good">Ideal</span></div>
      </div>
      <div class="bedtime-row recommended">
        <div class="bedtime-time">$t5</div>
        <div class="bedtime-meta"><strong>5 cycles</strong> &middot; 7.5 hours &middot; <span class="quality good">Recommended</span></div>
      </div>
      <div class="bedtime-row">
        <div class="bedtime-time">$t4</div>
        <div class="bedtime-meta"><strong>4 cycles</strong> &middot; 6 hours &middot; <span class="quality ok">Workable</span></div>
      </div>
      <div class="bedtime-row">
        <div class="bedtime-time">$t3</div>
        <div class="bedtime-meta"><strong>3 cycles</strong> &middot; 4.5 hours &middot; <span class="quality short">Short</span></div>
      </div>
    </div>
    <p class="fall-asleep-note">Times assume ~15 minutes to fall asleep.</p>

    <h2>Why these specific times?</h2>
    <p>Your brain doesn&rsquo;t sleep evenly. It cycles through stages of light sleep, deep sleep, and REM sleep. One full cycle averages <strong>90 minutes</strong>. Waking up at the end of a cycle, during light sleep, feels effortless. Waking up mid-cycle &mdash; especially during deep sleep &mdash; leaves you groggy for an hour or more, a feeling sleep researchers call <strong>sleep inertia</strong>.</p>
    <p>That&rsquo;s why a 7-hour night sometimes feels worse than 6 hours: 7 hours can land you in the middle of a cycle, while 6 or 7.5 hours wake you up cleanly between cycles. If you need to be up at $label, the bedtimes above let your last cycle end right around your alarm.</p>

    <h2>How to pick the right bedtime</h2>
    <p>For most adults, the sweet spot is <strong>5 cycles (7.5 hours)</strong>. If you&rsquo;re recovering from sleep debt, sick, doing intense physical training, or under 25, aim for <strong>6 cycles (9 hours)</strong>. Try to avoid 4 cycles or fewer unless you genuinely have no other option.</p>

    <h2>Tips to actually fall asleep at this time</h2>
    <ul>
      <li><strong>Cool the room</strong> to 18&ndash;20&deg;C (65&ndash;68&deg;F). Your core temperature has to drop for sleep to start.</li>
      <li><strong>Kill the light</strong>. Even small amounts of light suppress melatonin &mdash; your body&rsquo;s sleep signal.</li>
      <li><strong>Stop caffeine after 2 PM</strong>. Its half-life is 5&ndash;7 hours, so afternoon coffee is still active at midnight.</li>
      <li><strong>Cut screens 30 minutes before bed</strong>, or use night-mode filters. Blue light delays melatonin release.</li>
      <li><strong>Keep a consistent schedule</strong>, including weekends. Your circadian rhythm rewards regularity.</li>
    </ul>

    <h2>Need a different wake-up time?</h2>
    <p>Use the <a href="/">full sleep calculator</a> to compute bedtimes for any wake-up time, or jump to another common time:</p>
    <ul>
$siblingsHtml
    </ul>

    <h2>About sleep cycles</h2>
    <p>The 90-minute cycle is an average, not a law. Real cycles vary from 70 to 120 minutes and shift throughout the night &mdash; early cycles contain more deep sleep, later cycles more REM. The calculator gives you a strong starting point, but you may need to adjust by 15&ndash;20 minutes after a few weeks of tracking how you feel.</p>
    <p>If you struggle to fall asleep by the time recommended here, or wake up exhausted regardless of timing, this calculator can&rsquo;t replace a conversation with a doctor. Persistent insomnia, daytime exhaustion, and snoring all deserve professional attention.</p>
  </article>
</main>

<footer class="site-footer">
  <div class="container">
    <nav class="footer-nav">
      <a href="/">Home</a>
      <a href="/about/">About</a>
      <a href="/privacy/">Privacy</a>
      <a href="/terms/">Terms</a>
      <a href="/contact/">Contact</a>
    </nav>
    <p class="footer-note">CycleBed is an informational tool, not medical advice.</p>
    <p class="copyright">&copy; <span id="year">2026</span> CycleBed</p>
  </div>
</footer>

<script>document.getElementById('year').textContent = new Date().getFullYear();</script>
</body>
</html>
"@

  $dir = Join-Path $outRoot "wake-at-$slug"
  New-Item -ItemType Directory -Path $dir -Force | Out-Null
  $utf8NoBom = New-Object System.Text.UTF8Encoding $false
  [System.IO.File]::WriteAllText((Join-Path $dir "index.html"), $html, $utf8NoBom)
  Write-Output "Generated: wake-at-$slug ($label) -> bedtimes $t6 / $t5 / $t4 / $t3"
}

Write-Output ""
Write-Output "Done. $($wakeTimes.Count) pages generated."
