OUTPUT_FILE="/var/www/html/viikko3/index.html"
WARNING_LIMIT=80

get_disk_usage() {
    df / | awk 'NR==2 {print $5}' | tr -d '%'
}

get_disk_status() {    local usage="$1"
    if [ "$usage" -ge "$WARNING_LIMIT" ]; then
        echo "WARNING"
    else
        echo "OK"
    fi
}

generated_at=$(date "+%Y-%m-%d %H:%M:%S %Z")
uptime_text=$(uptime -p)
disk_usage=${1:-$(get_disk_usage)}
disk_status=$(get_disk_status "$disk_usage")
ram_total=$(free -h | awk '/^Mem:/ {print $2}')
ram_available=$(free -h | awk '/^Mem:/ {print $7}')

echo "Disk usage: ${disk_usage}% -> ${disk_status}"

cat > "${OUTPUT_FILE}.tmp" <<EOF
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Server Status</title>
  <style>
    body { max-width: 800px; margin: 40px auto; padding: 0 20px;
           font-family: sans-serif; line-height: 1.6;
           background: #000000; color: #ffffff; }
    h1, h2 { color: #ff3333; }
    a { color: #ff6666; }
    table { border-collapse: collapse; width: 100%; }
    td { padding: 8px; border-bottom: 1px solid #333333; }
    .OK { color: #33ff66; font-weight: bold; }
    .WARNING { color: #ffcc00; font-weight: bold; }
  </style>
</head>
<body>
  <h1>My Little Linux Box - Server Status</h1>
  <p>Report</p>

  <table>
    <tr><td>Report generated</td><td>${generated_at}</td></tr>
    <tr><td>Uptime</td><td>${uptime_text}</td></tr>
    <tr><td>Disk usage (/)</td><td>${disk_usage} %</td></tr>
    <tr><td>Disk status</td><td class="${disk_status}">${disk_status}</td></tr>
    <tr><td>Total RAM</td><td>${ram_total}B</td></tr>
    <tr><td>Available RAM</td><td>${ram_available}B</td></tr>
  </table>
 <p><a href="docs.html">Documentation</a> | <a href="https://github.com/JapeJJ/linux-admin-viikko3">Source code on GitHub</a></p>
<img src="linux.jpg" alt="Sad Linux penguin" style="max-width: 100%;">
</body>
</html>
EOF

mv "${OUTPUT_FILE}.tmp" "$OUTPUT_FILE"
