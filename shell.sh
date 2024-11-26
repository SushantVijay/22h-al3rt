#!/bin/bash

# Log file location (modify if needed)
LOGFILE="/var/log/auth.log"
# For CentOS/RHEL, use: LOGFILE="/var/log/secure"

# Email alert configuration
ALERT_EMAIL="your_email@example.com"

# Log file for storing alert history
ALERT_LOG="ssh_alert_log.txt"

# Max failed attempts for brute-force detection
MAX_FAILED_ATTEMPTS=5

# GeoIP lookup command (install geoip-bin package if missing)
GEOIP_CMD="geoiplookup"

# Multi-channel alerts (add API tokens here for services like Telegram or Slack)
TELEGRAM_TOKEN="YOUR_TELEGRAM_BOT_TOKEN"
TELEGRAM_CHAT_ID="YOUR_TELEGRAM_CHAT_ID"

# Whitelisted IPs
WHITELIST=("127.0.0.1" "192.168.1.1")

# Function to send email alerts
send_email() {
    local message=$1
    echo "$message" | mail -s "SSH Alert" "$ALERT_EMAIL"
}

# Function to send Telegram alerts
send_telegram() {
    local message=$1
    curl -s -X POST "https://api.telegram.org/bot$TELEGRAM_TOKEN/sendMessage" \
        -d chat_id="$TELEGRAM_CHAT_ID" \
        -d text="$message" > /dev/null
}

# Function to perform GeoIP lookup
get_geoip() {
    local ip=$1
    $GEOIP_CMD "$ip" | awk -F ': ' '{print $2}' || echo "Unknown Location"
}

# Monitor the log file for SSH activity
tail -F "$LOGFILE" | while read LINE; do
    # Detect successful login
    if echo "$LINE" | grep -q "Accepted password"; then
        USER=$(echo "$LINE" | awk '{print $9}')
        IP=$(echo "$LINE" | awk '{print $11}')
        TIMESTAMP=$(echo "$LINE" | awk '{print $1, $2, $3}')
        
        # Skip if IP is whitelisted
        if [[ " ${WHITELIST[@]} " =~ " $IP " ]]; then
            continue
        fi

        # GeoIP lookup
        LOCATION=$(get_geoip "$IP")

        # Alert message
        MESSAGE="SSH Login Alert: User=$USER, IP=$IP, Location=$LOCATION, Time=$TIMESTAMP"
        echo "$MESSAGE"

        # Log the alert
        echo "$TIMESTAMP - $MESSAGE" >> "$ALERT_LOG"

        # Send alerts
        send_email "$MESSAGE"
        send_telegram "$MESSAGE"
    fi

    # Detect failed login attempts
    if echo "$LINE" | grep -q "Failed password"; then
        FAILED_IP=$(echo "$LINE" | awk '{print $11}')
        ATTEMPTS=$(grep "Failed password" "$LOGFILE" | grep "$FAILED_IP" | wc -l)

        # Trigger brute-force alert if attempts exceed the threshold
        if [ "$ATTEMPTS" -ge "$MAX_FAILED_ATTEMPTS" ]; then
            MESSAGE="Brute Force Alert: IP=$FAILED_IP, Attempts=$ATTEMPTS"
            echo "$MESSAGE"

            # Log the alert
            echo "$MESSAGE" >> "$ALERT_LOG"

            # Send alerts
            send_email "$MESSAGE"
            send_telegram "$MESSAGE"

            # Block the IP (optional)
            iptables -A INPUT -s "$FAILED_IP" -j DROP
        fi
    fi
done
