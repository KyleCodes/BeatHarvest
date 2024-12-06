#!/bin/bash

service cron start
# Keep container running by preventing script from exiting
tail -f /var/log/cron.log
