#!/bin/bash

LOGFILE="/var/log/auth.log"
# For CentOS/RHEL, use: LOGFILE="/var/log/secure"

# Alert email (optional)
ALERT_EMAIL="your_email@example.com"

# Tail the log and monitor for successful logins
tail -F "$LOGFILE" | while read LINE; do
    if echo "$LINE" | grep -q "Accepted password"; then
        # Extract relevant info
        USER=$(echo "$LINE" | awk '{print $9}')
        IP=$(echo "$LINE" | awk '{print $11}')
        TIMESTAMP=$(echo "$LINE" | awk '{print $1, $2, $3}')

        # Alert message
        MESSAGE="SSH Login Alert: User=$USER, IP=$IP, Time=$TIMESTAMP"
        echo "$MESSAGE"

        # Send alert (optional)
        if [[ -n "$ALERT_EMAIL" ]]; then
            echo "$MESSAGE" | mail -s "SSH Login Alert" "$ALERT_EMAIL"
        fi
    fi
done
