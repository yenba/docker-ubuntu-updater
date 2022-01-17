#!/bin/bash

# Defining Colors for text output
red=$( tput setaf 1 );
yellow=$( tput setaf 3 );
green=$( tput setaf 2 );
normal=$( tput sgr 0 );

OTHERGREEN="\033[1;32m"
OTHERNOCOLOR="\033[0m"

echo

# Checking whether script is being run as root

if [[ ${UID} != 0 ]]; then
    echo "${red}
    This script must be run as root or with sudo permissions.
    Please run using sudo.${normal}
    "
    exit 1
fi

# Running Script

# Pulling Docker
echo
echo -e "step 1: ${OTHERGREEN}pulling new docker images${OTHERNOCOLOR}"
docker-compose -f $PWD/docker/docker-compose.yml pull | tee /tmp/update-output.txt
echo
sleep 3

# Updating Docker
echo
echo -e "step 2: ${OTHERGREEN}pulling new docker images${OTHERNOCOLOR}"
docker-compose -f $PWD/docker/docker-compose.yml up -d | tee /tmp/update-output.txt
echo
sleep 3

# Updating APT
echo
echo -e "step 3: ${OTHERGREEN}update apt packages${OTHERNOCOLOR}"
apt-get update | tee /tmp/update-output.txt
echo
sleep 3

# Upgrading APT
echo
echo -e "step 4: ${OTHERGREEN}upgrade packages${OTHERNOCOLOR}"
apt-get upgrade -y | tee -a /tmp/update-output.txt
echo
sleep 3

# Running Auto Remove
echo
echo -e "step 5: ${OTHERGREEN}remove unused packages${OTHERNOCOLOR}"
apt-get --purge autoremove | tee -a /tmp/update-output.txt
echo
sleep 3

# Running Auto Clean
echo
echo -e "step 5: ${OTHERGREEN}clean up${OTHERNOCOLOR}"
apt-get autoclean | tee -a /tmp/update-output.txt
echo
sleep 3

# Check for existence of update-output.txt and exit if not there.

if [ -f "/tmp/update-output.txt"  ]

then

# Search for issues user may want to see and display them at end of run.

echo
echo -e "step 6: ${OTHERGREEN}Checking for actionable messages from install${OTHERNOCOLOR}"
echo

egrep -wi --color 'warning|error|critical|reboot|restart|autoclean|autoremove' /tmp/update-output.txt | uniq
sleep 3

echo
echo -e "step 7: ${OTHERGREEN}Cleaning temp files${OTHERNOCOLOR}"
echo

rm /tmp/update-output.txt
sleep 3

echo
echo -e "step 8: ${OTHERGREEN}Done with upgrade${OTHERNOCOLOR}"
sleep 3
echo

exit 0

else

# Exit with message if update-output.txt file is not there.
echo
echo -e "${OTHERGREEN}No items to check given your chosen options. Exiting.${OTHERNOCOLOR}"
echo
sleep 3

fi

exit 0