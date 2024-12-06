# Use a slim debian base
FROM debian:bullseye-slim

# Set environment variables
ENV NODE_VERSION=20.x
ENV PYTHON_VERSION=3.9

# Install essential system dependencies
RUN apt-get update && apt-get install -y \
  curl \
  git \
  ffmpeg \
  python${PYTHON_VERSION} \
  python3-pip \
  cron \
  && rm -rf /var/lib/apt/lists/*

# Install Node.js
RUN curl -fsSL https://deb.nodesource.com/setup_${NODE_VERSION} | bash - \
  && apt-get install -y nodejs \
  && npm install -g typescript ts-node

# Set working directory
WORKDIR /app

# Now clone your repository (replace with your actual repo URL)
RUN git clone https://github.com/KyleCodes/BeatHarvest.git ./BeatHarvest

# Change to repository directory
WORKDIR /app/BeatHarvest

# Install Node.js dependencies
RUN npm install

# Install Python dependencies
RUN pip3 install spotdl

# Set up cron job
RUN echo "0 * * * * cd /app/BeatHarvest && /usr/bin/node -r ts-node/register src/scripts/downloadPlaylists.ts >> /var/log/cron.log 2>&1" | crontab -

CMD ["cron", "-f"]

# Start cron service
# COPY start.sh /start.sh
# RUN chmod +x /start.sh
# ENTRYPOINT ["/start.sh"]
