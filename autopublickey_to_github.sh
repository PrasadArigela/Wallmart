$ cat autopublickey_to_github.sh
#!/bin/bash
#title          : Auto SSH Key to GitHub
#description    : Generates SSH key if not present and uploads to GitHub
#author         :   Prasad Arigela
#date           :   29082025
#version        :   1.0
#usage          :   sh autopublickey_to_github.sh
#CopyRights     :   Softility
#Contact        :   XXXXXXXX

echo "Enter your GitHub Personal Access Token: "
read -s token

# Display existing public key if present
cat ~/.ssh/id_rsa.pub 2>/dev/null

# if condition to validate whether ssh keys are already present or not
if [ $? -eq 0 ]
then
    echo "SSH Keys are already present....."
else
    echo "SSH Keys are not present..., Create the sshkeys using ssh-keygen command"
    ssh-keygen -t rsa -b 4096 -C "your_email@example.com" -N "" -f ~/.ssh/id_rsa
    echo "SSH Keys successfully generated"
fi

# Correct way to read ssh key into variable
sshkey=$(cat ~/.ssh/id_rsa.pub)

if [ $? -eq 0 ]
then
   echo "Copying the key to GitHub account"

   curl -L -X POST \
   -H "Accept: application/vnd.github+json" \
   -H "Authorization: token $token" \
   https://api.github.com/user/keys \
   -d "{\"title\":\"SSHKEY\",\"key\":\"$sshkey\"}"

   if [ $? -eq 0 ]
   then
      echo "Successfully copied the SSH key to GitHub"
      exit 0
   else
      echo "Failed"
   fi
else
   echo "Failure in generating the key"
   exit 1
fi

