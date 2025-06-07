#!/bin/sh
while true
do
  echo "[$(date)] Running Laravel schedule:run" >> /var/www/html/storage/logs/cron.log
  php /var/www/html/artisan schedule:run >> /var/www/html/storage/logs/cron.log 2>&1
  sleep 60
done
