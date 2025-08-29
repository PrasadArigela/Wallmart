#!/bin/bash
#title          : Auto SSH Key to GitHub
#description    : Generates SSH key if not present and uploads to GitHub
#author         : Prasad Arigela
#date           : 29082025
#version        : 1.0
#usage          : sh autopublickey_to_github.sh
#CopyRights     : Softility
#Contact        : XXXXXXXX

echo "Enter your GitHub Personal Access Token: "
read -s token   # -s hides input

# Check if SSH key exists
if [ -f ~/.ssh/id_rsa.pub ]; then
    echo "SSH Keys are already present....."
else
    echo "SSH Keys are not present..., creating one now..."
    ssh-keygen -t rsa
    echo "SSH Keys successfully generated"
fi

# Read the SSH key
sshkey=$(cat ~/.ssh/id_rsa.pub)

# Upload to GitHub
echo "Copying the key to GitHub account..."
response=$(curl -s -o /dev/null -w "%{http_code}" \
  -X POST \
  -H "Accept: application/vnd.github+json" \
  -H "Authorization: token $token" \
  https://api.github.com/user/keys \
  -d "{\"title\":\"$(hostname)-key\",\"key\":\"$sshkey\"}")


# Check response
if [ "$response" -eq 201 ]; then
    echo "✅ Successfully copied the SSH key to GitHub"
    exit 0
else
    echo "❌ Failed to upload SSH key to GitHub. Response code: $response"
    exit 1
fi

