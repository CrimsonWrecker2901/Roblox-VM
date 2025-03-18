FROM ubuntu:20.04

# Install necessary packages
RUN dpkg --add-architecture i386 && \
    apt-get update && \
    apt-get install -y wine64 wine32 wget xvfb

# Download and install Roblox
RUN wget -O roblox.exe "https://setup.rbxcdn.com/version-2.664.714-Roblox.exe" && \
    xvfb-run wine roblox.exe /silent

# Create a user to run Roblox
RUN useradd -m robloxuser

# Switch to the new user
USER robloxuser
WORKDIR /home/robloxuser

# Entry point to start Roblox
ENTRYPOINT ["xvfb-run", "wine", "C:\\Program Files (x86)\\Roblox\\Versions\\version-2.664.714\\RobloxPlayerLauncher.exe"]
