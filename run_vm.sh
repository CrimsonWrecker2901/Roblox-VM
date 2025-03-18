#!/bin/bash

# Start the codespace
code .

# Build the Docker image
docker build -t roblox-vm /workspaces/Roblox-VM

# Run the Docker container
docker run -it --rm --name roblox-vm roblox-vm
