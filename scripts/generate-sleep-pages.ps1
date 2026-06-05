# Generates programmatic SEO pages for common wake-up times.
# Re-run anytime to refresh. Output: public/sleep/wake-at-<slug>/index.html
# All non-ASCII characters in HTML output use HTML entities to be immune to
# PowerShell encoding quirks (Windows PowerShell 5.1 reads .ps1 as Windows-1252
# unless a UTF-8 BOM is present).

$wakeTimes = @(
  @{
    hour = 5;  minute = 0;  label = "5:00 AM";  slug = "5am";
    who = "A 5:00 AM alarm is the realm of athletes, gym-before-work early risers, early-shift workers, and the famous &ldquo;5 AM club.&rdquo; It&rsquo;s a powerful, productive start &mdash; but only if you protect your bedtime ruthlessly.";
    extraHead = "Making 5 AM work without wrecking yourself";
    extraBody = "<p>Waking at 5:00 AM is only sustainable if you go to bed early enough to bank a full night, and that&rsquo;s where most 5 AM hopefuls fail. To get a healthy 5 cycles you need to be asleep around 9:15 PM &mdash; which means starting your wind-down by 8:30 PM, before the evening is really over. If that feels impossible, build up gradually: shift your bedtime 15 minutes earlier every few nights rather than lurching from a midnight habit to a 9 PM one overnight.</p><p>For athletes and gym-goers, the early-night deep sleep you&rsquo;d sacrifice by going to bed late is exactly the stage where your body releases growth hormone and repairs muscle &mdash; so a poorly-timed 5 AM wake-up undercuts the very training you&rsquo;re getting up for. Anchor your wake time, get bright light immediately on rising, and treat the 9 PM bedtime as non-negotiable on training days.</p>"
  },
  @{
    hour = 5;  minute = 30; label = "5:30 AM";  slug = "5-30am";
    who = "5:30 AM is the wake-up time for serious-but-not-extreme early risers: parents who want quiet hours before the household wakes, gym-goers fitting a workout in before work, and commuters with a long haul ahead. It&rsquo;s early enough to need planning, but a touch gentler than a 5 AM start.";
    extraHead = "Building a sustainable 5:30 routine";
    extraBody = "<p>The make-or-break factor at 5:30 AM is your bedtime, not your willpower in the morning. Five full cycles means lights-out by about 9:45 PM &mdash; which collides with the most tempting part of the evening, so the people who sustain a 5:30 wake almost always have a fixed wind-down ritual rather than a vague intention to &ldquo;turn in early.&rdquo;</p><p>If you&rsquo;re carving out those early hours for exercise or focused work, protect the early-night portion of your sleep especially hard: the first couple of cycles are where deep, restorative slow-wave sleep concentrates. Trade them away by scrolling past midnight and you undercut the very recovery and clarity you&rsquo;re rising early to gain. Get daylight on your face within minutes of waking to lock the rhythm in place.</p>"
  },
  @{
    hour = 6;  minute = 0;  label = "6:00 AM";  slug = "6am";
    who = "6:00 AM is the classic early-shift and commuter wake-up &mdash; trades, healthcare, transport, manufacturing, and anyone with a long drive before a 9-to-5. It&rsquo;s early enough to demand discipline but common enough to build a normal life around.";
    extraHead = "The early-shift sleep strategy";
    extraBody = "<p>If you&rsquo;re up at 6:00 AM for shift work or a long commute, your biggest enemy is the temptation to stay up as if you were on a later schedule. To hit 5 full cycles you want to be asleep by about 10:15 PM. That clashes with prime-time TV and family evenings, so the trick is a hard wind-down cutoff rather than relying on willpower in the moment.</p><p>Shift and commuter schedules also tend to collapse on weekends, when people sleep in by hours and then can&rsquo;t fall asleep Sunday night &mdash; the classic &ldquo;social jetlag&rdquo; that makes Monday&rsquo;s 6 AM alarm brutal. Keeping your wake time within an hour of 6:00 AM even on days off keeps your body clock stable, so the early start stops feeling like a fresh shock every week.</p>"
  },
  @{
    hour = 6;  minute = 15; label = "6:15 AM";  slug = "6-15am";
    who = "6:15 AM is a classic &ldquo;buffer&rdquo; alarm &mdash; a few extra minutes over 6 AM for people who want a slightly calmer start before a standard commute or school run. It suits parents, teachers, and office workers who like a little breathing room in the morning.";
    extraHead = "Why those extra 15 minutes matter";
    extraBody = "<p>Setting the alarm for 6:15 instead of 6:00 buys you a more relaxed morning, but only if the bedtime keeps pace. Five full cycles means asleep by around 10:30 PM. The trap is treating the later alarm as licence to stay up later too &mdash; the 15 minutes you gained in the morning vanish if you spend 30 extra minutes awake at night.</p><p>Because 6:15 is genuinely close to most people&rsquo;s natural early-workday rhythm, it&rsquo;s one of the easier alarms to hit without a snooze battle &mdash; provided you anchor a consistent bedtime. Aim to wake at the end of a cycle, and those first few minutes of the day feel like easing out of sleep rather than being dragged from it.</p>"
  },
  @{
    hour = 6;  minute = 30; label = "6:30 AM";  slug = "6-30am";
    who = "6:30 AM is the quintessential commuter alarm &mdash; just enough time to get ready, get out, and beat the worst of the traffic before a standard 8:30 or 9:00 start. It&rsquo;s the most common &ldquo;real life&rdquo; wake-up time of all.";
    extraHead = "Winning the commuter morning";
    extraBody = "<p>The 6:30 AM crowd usually has a fixed, immovable start time on the other end, which makes bedtime the only variable you actually control. For 5 cycles, aim to be asleep by about 10:45 PM. The good news is that this lines up reasonably well with a normal evening, so 6:30 AM is one of the more sustainable early starts &mdash; you don&rsquo;t have to abandon your night to make it work.</p><p>The pitfall here is the snooze button. Because 6:30 AM isn&rsquo;t brutally early, it&rsquo;s tempting to set the alarm and then steal three or four nine-minute snoozes. Those fragments of light sleep after your alarm aren&rsquo;t restorative and often leave you groggier than if you&rsquo;d simply gotten up. Timing your bedtime so your last cycle ends right at 6:30 means you wake naturally near the alarm and don&rsquo;t need the snooze at all.</p>"
  },
  @{
    hour = 6;  minute = 45; label = "6:45 AM";  slug = "6-45am";
    who = "6:45 AM is the &ldquo;just enough time&rdquo; alarm &mdash; popular with people on a tight but normal schedule who want to maximise sleep while still making a standard start. Every minute counts in a 6:45 morning, so the routine is usually efficient and well-rehearsed.";
    extraHead = "Making a tight morning work";
    extraBody = "<p>At 6:45 the margins are thin, which makes hitting a clean sleep cycle especially valuable: waking groggy when your morning is already tightly packed sets a stressful tone for the whole day. Five full cycles puts your bedtime around 11:00 PM &mdash; a realistic, mainstream lights-out that fits an ordinary evening.</p><p>The single biggest upgrade for a 6:45 riser is cutting the snooze habit. Those extra nine-minute fragments after the alarm are shallow, non-restorative sleep that often leave you foggier than simply getting up &mdash; and in a tight morning you can&rsquo;t afford the lost time anyway. Time your bedtime so your final cycle ends right around 6:45 and you&rsquo;ll wake close to naturally, no snooze required.</p>"
  },
  @{
    hour = 7;  minute = 0;  label = "7:00 AM";  slug = "7am";
    who = "7:00 AM is the default wake-up time for office workers, students, and parents on a school-run schedule. It&rsquo;s the most-searched alarm time on the internet for a reason &mdash; it fits a standard 9-to-5 day almost perfectly.";
    extraHead = "The standard-schedule sweet spot";
    extraBody = "<p>7:00 AM pairs beautifully with sleep-cycle math. To get 5 complete cycles you simply need to be asleep by about 11:15 PM &mdash; a bedtime that fits a normal adult evening without forcing you to skip your whole night. That&rsquo;s why 7 AM is the easiest mainstream wake-up time to optimise: the ideal bedtime is genuinely realistic.</p><p>For students and parents, consistency is the real lever. Students wrecking their schedule with late-night study and weekend lie-ins lose the predictable rhythm that makes a 7 AM wake feel easy; parents tied to the school run benefit hugely from keeping their own bedtime fixed even when the evening runs long. If you can hold an 11:15 PM lights-out on weekdays, a 7:00 AM alarm stops being something you fight and becomes something your body does on its own.</p>"
  },
  @{
    hour = 7;  minute = 15; label = "7:15 AM";  slug = "7-15am";
    who = "7:15 AM suits people with a slightly later, more comfortable start &mdash; flexible offices, hybrid workers, and anyone whose day begins around 9 with a short commute. It&rsquo;s a relaxed mainstream wake-up with a bit of slack built in.";
    extraHead = "The comfortable-start sweet spot";
    extraBody = "<p>7:15 AM is one of the most forgiving alarms to optimise. Five full cycles puts your bedtime around 11:30 PM, which sits comfortably inside a normal evening &mdash; you don&rsquo;t have to sacrifice your night to make it. That makes 7:15 a genuinely sustainable time for most adults.</p><p>The risk with a slightly later, flexible start is schedule drift: without an early hard deadline, bedtime quietly creeps later until you&rsquo;re waking at 7:15 on too little sleep. Keep your wake time fixed even on days off, get morning light soon after rising, and let the cycle math hold your bedtime steady. Done consistently, 7:15 leaves you both well-rested and unhurried.</p>"
  },
  @{
    hour = 7;  minute = 30; label = "7:30 AM";  slug = "7-30am";
    who = "7:30 AM suits people with a later start &mdash; remote and work-from-home schedules, flexible offices, and later school or university timetables. The extra half hour is a real luxury, if you use it rather than burn it.";
    extraHead = "Making the most of a later start";
    extraBody = "<p>A 7:30 AM wake-up gives you breathing room, and the cycle math is forgiving: 5 full cycles means an 11:45 PM bedtime, comfortably within a normal evening. The risk with a later, more flexible start is that the structure quietly disappears &mdash; without a commute forcing the issue, bedtime drifts later and later until you&rsquo;re waking at 7:30 on far too little sleep.</p><p>If you work from home, the danger is doubled because your &ldquo;morning&rdquo; light exposure and movement often shrink to a few steps from bed to desk. Treat the saved commute time as a chance to get outside for daylight soon after waking; that morning light is what keeps your body clock anchored so a flexible schedule doesn&rsquo;t slide into chronic lateness. Use the half-hour you&rsquo;ve gained on a proper wind-down the night before, and 7:30 AM becomes genuinely restful rather than just later.</p>"
  },
  @{
    hour = 7;  minute = 45; label = "7:45 AM";  slug = "7-45am";
    who = "7:45 AM is a relaxed start for remote workers, hybrid schedules, later school timetables, and anyone who values a slow morning. The extra time is a genuine luxury &mdash; the question is whether you use it or quietly burn it by going to bed too late.";
    extraHead = "Protecting a slow morning";
    extraBody = "<p>A 7:45 AM wake-up is generous: five full cycles only needs lights-out by about midnight, comfortably within any normal evening. The danger of a later, flexible start is that structure evaporates &mdash; with no commute forcing the issue, bedtime slides and the &ldquo;extra&rdquo; sleep never materialises.</p><p>If you work from home, your morning light and movement often shrink to a few steps from bed to desk, which lets your body clock drift later and later. Treat the time you save on commuting as a chance to step outside for daylight soon after waking. Keep the midnight bedtime consistent, time it to full cycles, and 7:45 becomes a calm, well-rested start rather than just a late one.</p>"
  },
  @{
    hour = 8;  minute = 0;  label = "8:00 AM";  slug = "8am";
    who = "8:00 AM is the wake-up time for freelancers, creative workers, night-owl chronotypes, students with afternoon classes, and anyone whose schedule simply starts later. Slept-in mornings aren&rsquo;t lazy &mdash; for genuine night owls they&rsquo;re biologically correct.";
    extraHead = "Sleeping later, on purpose and well";
    extraBody = "<p>An 8:00 AM wake-up only works in your favour if the late start is matched by a late-but-consistent bedtime. For 5 full cycles you want to be asleep by about 12:15 AM. The freedom of a later schedule is real, but it comes with a catch: night owls who drift to 2 or 3 AM and still wake at 8 are simply running a chronic deficit dressed up as a lifestyle.</p><p>If you&rsquo;re a genuine evening chronotype, the goal isn&rsquo;t to force yourself into an early-bird mould &mdash; it&rsquo;s to make your late schedule regular. Pick a fixed bedtime around midnight, hold your 8:00 AM wake time even on weekends, and get bright light as soon as you&rsquo;re up to stop the schedule sliding even later. Done right, an 8 AM wake on a stable late rhythm leaves you just as rested as any early riser &mdash; the cycles are what matter, not the hour on the clock.</p>"
  },
  @{
    hour = 8;  minute = 30; label = "8:30 AM";  slug = "8-30am";
    who = "8:30 AM is a genuinely late wake-up &mdash; the territory of strong night owls, freelancers, remote workers with no fixed start, shift workers recovering from a late finish, and students with midday lectures. It&rsquo;s a luxury start that only pays off if your bedtime is late but disciplined.";
    extraHead = "Owning a late schedule without guilt";
    extraBody = "<p>An 8:30 AM wake-up is only restful if you stop treating it as &ldquo;extra&rdquo; sleep tacked onto a normal-person bedtime. To bank 5 full cycles you need to be asleep by about 12:45 AM. The failure mode for late risers is obvious in hindsight: drifting to 2 or 3 AM and still rising at 8:30 isn&rsquo;t a relaxed lifestyle, it&rsquo;s a slow-building sleep debt with a comfortable cover story.</p><p>If your body genuinely runs late &mdash; and for a real evening chronotype it does &mdash; the win is regularity, not reform. Hold the 8:30 wake time even on weekends, pick a fixed bedtime around 12:45 AM, and get bright light onto your face the moment you&rsquo;re up so the rhythm doesn&rsquo;t slide later still. A late but consistent schedule leaves you every bit as rested as a 6 AM lark; what wrecks people is the drift, not the hour.</p>"
  },
  @{
    hour = 9;  minute = 0;  label = "9:00 AM";  slug = "9am";
    who = "9:00 AM is a properly late start &mdash; the realm of extreme night owls, creative and freelance schedules, night-shift workers sleeping through the morning, teenagers (whose body clocks really do run late), and anyone on a deliberately delayed rhythm. Late isn&rsquo;t lazy, but it does demand structure.";
    extraHead = "Making a 9 AM rhythm actually work";
    extraBody = "<p>Waking at 9:00 AM gives you a long runway, but the sleep-cycle math is unforgiving about bedtime: 5 full cycles means lights-out by roughly 1:15 AM. The trap is assuming a late wake-up automatically means more sleep &mdash; if you&rsquo;re still awake at 3 AM scrolling, a 9 AM alarm just disguises a short night as a leisurely one.</p><p>Teenagers and true evening chronotypes have a biologically delayed clock, so a 9 AM wake can be exactly right for them rather than a sign of indiscipline. The key in every case is consistency: hold your wake time across weekends, anchor a fixed late bedtime, and chase down morning light as soon as you rise to keep the rhythm from sliding into the afternoon. A stable late schedule is restful; a chaotic one just feels late and tired at once.</p>"
  }
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
  $who = $wt.who
  $extraHead = $wt.extraHead
  $extraBody = $wt.extraBody

  $html = @"
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<meta name="p:domain_verify" content="1c54f62131bd5728453cb7db845ee337"/>
<title>Wake up at $label &mdash; What time to go to bed | CycleBed</title>
<meta name="description" content="If you need to wake up at $label, here are the best bedtimes based on 90-minute sleep cycles. Wake up refreshed instead of groggy.">
<meta name="robots" content="index, follow">
<link rel="canonical" href="https://cyclebed.com/sleep/wake-at-$slug/">
<link rel="icon" type="image/svg+xml" href="/favicon.svg">

<script async src="https://pagead2.googlesyndication.com/pagead/js/adsbygoogle.js?client=ca-pub-9728714289190766" crossorigin="anonymous"></script>

<link rel="stylesheet" href="/style.css">
<meta property="og:type" content="article">
<meta property="og:site_name" content="CycleBed">
<meta property="og:image" content="https://cyclebed.com/og-default.png">
<meta property="og:image:width" content="1200">
<meta property="og:image:height" content="630">
<meta name="twitter:card" content="summary_large_image">
<meta name="twitter:image" content="https://cyclebed.com/og-default.png">
<script type="application/ld+json">
{
  "@context": "https://schema.org",
  "@type": "BreadcrumbList",
  "itemListElement": [
    { "@type": "ListItem", "position": 1, "name": "Home", "item": "https://cyclebed.com/" },
    { "@type": "ListItem", "position": 2, "name": "Wake-up times", "item": "https://cyclebed.com/sleep/" },
    { "@type": "ListItem", "position": 3, "name": "Wake up at $label", "item": "https://cyclebed.com/sleep/wake-at-$slug/" }
  ]
}
</script>
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
    <nav class="breadcrumbs"><a href="/">Home</a> &rsaquo; <a href="/sleep/">Wake-up times</a> &rsaquo; <span>Wake up at $label</span></nav>
    <h1>What time to sleep to wake up at $label</h1>
    <p class="lead">If your alarm is set for <strong>$label</strong>, here are the bedtimes that align with full 90-minute sleep cycles &mdash; so you wake up between cycles instead of in the middle of deep sleep.</p>
    <p>$who</p>

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

    <h2>$extraHead</h2>
    $extraBody

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

    <h2>Go deeper</h2>
    <p>Want to understand the science behind these times? Read our in-depth guides:</p>
    <ul>
      <li><a href="/guide/complete-sleep-cycles/">Sleep cycles explained: the four stages of sleep</a></li>
      <li><a href="/guide/fall-asleep-faster/">How to fall asleep faster: 12 methods</a></li>
      <li><a href="/guide/sleep-by-age/">How much sleep you need by age</a></li>
      <li><a href="/guide/sleep-debt/">Sleep debt and how to recover</a></li>
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
      <a href="/guide/">Guides</a>
      <a href="/tools/">Tools</a>
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
