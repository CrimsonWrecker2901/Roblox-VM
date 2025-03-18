# Use the official Ubuntu base image
FROM ubuntu:20.04

# Avoid interactive prompts during package installation
ENV DEBIAN_FRONTEND=noninteractive

# Update and install necessary packages
RUN apt-get update && apt-get install -y \
    software-properties-common \
    wget \
    apt-transport-https \
    gnupg2 \
    software-properties-common \
    && rm -rf /var/lib/apt/lists/*

# Add Wine repository and key
RUN dpkg --add-architecture i386 && \
    wget -nc https://dl.winehq.org/wine-builds/winehq.key && \
    apt-key add winehq.key && \
    add-apt-repository 'deb https://dl.winehq.org/wine-builds/ubuntu/ focal main' && \
    apt-get update && \
    apt-get install -y --install-recommends winehq-stable

# Install Roblox dependencies
RUN apt-get install -y \
    winetricks \
    && rm -rf /var/lib/apt/lists/*

# Create a user and switch to it
RUN useradd -ms /bin/bash robloxuser
USER robloxuser
WORKDIR /home/robloxuser

# Install Roblox using winetricks
RUN winetricks -q roblox

# Set environment variables for Wine
ENV WINEPREFIX=/home/robloxuser/.wine
ENV WINEARCH=win32

# Create an entrypoint script to start Roblox
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
