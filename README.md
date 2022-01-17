# docker-ubuntu-updater
This script will update your docker-compose containers and update and upgrade Ubuntu. 

## Prerequisites
Place the file inside your home directory like this `/home/$USERNAME/update.sh`. You must have your docker-compose.yml file in the following directory or else you will need to edit the script `/home/$USERNAME/docker/docker-compose.yml`.

You must have sudo permissions to run this script and you must set the file to executable.

To make the script executable use the following command:

```
sudo chmod +x update.sh
```

## Usage
From your home directory where you placed the `update.sh` file run the following command:
```
sudo ./ubuntu-update.sh
```
