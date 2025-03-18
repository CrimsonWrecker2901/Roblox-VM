FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive

# Install sudo and other necessary packages
RUN apt-get update && apt-get install -y \
    sudo \
    software-properties-common \
    wget \
    apt-transport-https \
    gnupg2 \
    && rm -rf /var/lib/apt/lists/*

# Add i386 architecture
RUN sudo dpkg --add-architecture i386

# Download and add WineHQ key
RUN wget -nc https://dl.winehq.org/wine-builds/winehq.key && \
    sudo mkdir -p /etc/apt/keyrings && \
    sudo mv winehq.key /etc/apt/keyrings/winehq-archive.key

# Add WineHQ repository
RUN echo "deb [signed-by=/etc/apt/keyrings/winehq-archive.key] https://dl.winehq.org/wine-builds/ubuntu/ focal main" | sudo tee /etc/apt/sources.list.d/winehq.list

# Update package list and install Wine
RUN sudo apt-get update && \
    sudo apt-get install -y --install-recommends winehq-stable

# Install Roblox dependencies
RUN sudo apt-get install -y winetricks && rm -rf /var/lib/apt/lists/*

# Create a user and switch to it
RUN useradd -ms /bin/bash robloxuser
USER robloxuser
WORKDIR /home/robloxuser

# Install Roblox using winetricks
RUN winetricks -q roblox

# Set environment variables for Wine
ENV WINEPREFIX=/home/robloxuser/.wine
ENV WINEARCH=win32

# Copy and set permissions for entrypoint script
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN sudo chmod +x /usr/local/bin/entrypoint.sh

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
