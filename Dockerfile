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
  openssh-server \
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

# Create directory for SSH daemon run
RUN mkdir /var/run/sshd

# Set up SSH access
RUN echo 'root:BeatHarvest' | chpasswd
RUN sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config

# SSH login fix. Otherwise user is kicked off after login
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

# Expose SSH port
EXPOSE 22

# Set up cron job
RUN echo "*/0 * * * * cd /app/BeatHarvest && /usr/bin/node -r ts-node/register src/scripts/downloadPlaylists.ts >> /var/log/cron.log 2>&1" | crontab -

# Start both cron and SSH services
COPY start.sh /start.sh
RUN chmod +x /start.sh
ENTRYPOINT ["/start.sh"]
