# Docker-BitcoinKnotsGUI
Run Bitcoin Docker with VNC Gui. Fight Bitcoin Network Spam!

Adational Unriad support: https://forums.unraid.net/topic/191428-suppot-bitcoin-gui

Docker varable added to stay on curent version you downloaded or let build script run and update to lattest version.
Bolean (T/F) AUTOUPDATE
**First Run needs AUTOUPDATE True to create files in volume - /config...**

It is best to make your own bitcoin.conf...
Generator: https://bitcoin-knots-config-generator.netlify.app/

You must make the .bitcoin folder and pathing beforehand...
```bash
mkdir -p /mnt/user/appdata/bitcoinknots/.bitcoin
chmod 777 -R /mnt/user/appdata/bitcoinknots/
chown nobody:users -R /mnt/user/appdata/bitcoinknots/
```

Otherwise make it yourself from this Repo:
```bash
git clone ...
cd Docker-BitcoinKnotsGUI
docker build -t bitcoin-knots-gui .
```
Then:
```bash
docker run -d --name=bitcoin-knots-gui -p 5800:5800 -v /YourHostPath:/config bitcoin-knots-gui
```
Then go to your Docker IP:5800 to see the VNC web UI and watch your v27 Bitcoin wallet/node sync.

# Docker - Bitcoin knots GUI Client

Run the Bitcoin knots GUI wallet in a Docker container, accessible via a web browser and VNC. Built over the [jlesage/docker-baseimage-gui](https://github.com/jlesage/docker-baseimage-gui) image (Debian 12).

## Getting Started Docker run commands options

```bash
docker volume create --name=bitcoin-data
docker run -d --name=bitcoin-knots-gui -p 5800:5800 -v bitcoin-data:/config bitcoin-knots-gui
```

Open your browser and go to `localhost:5800`. You should see the Bitcoin knots GUI application running!

**On the first run, the Welcome window will open, where you will be prompted for the data location!
You should set it to somewhere inside `/config`** (by default, it is set to `/config/.bitcoin`).

## Volume (Persistence)

AT FIRST LAUNCH ALWAYS CHOOSE THE 2ND OPTION!!!
![image](https://github.com/user-attachments/assets/a20cc3ec-8af6-40a9-bb6a-cd9019157a87)


The Bitcoin knots data directory is set to `/config/.bitcoin` by default. A volume is created for `/config`,
but you might want to mount the `/config/.bitcoin` directory on another volume or bind mount.

You can even mount subdirectories of the Bitcoin data directory. These are the most important:
- `/config/.bitcoin/blocks` for the blockchain
- `/config/.bitcoin/wallet.dat` for your wallet
- `/config/.bitcoin/bitcoin.conf` for the client configuration
- `/config/xdg/config/Bitcoin/Bitcoin-Qt.conf` for the frontend (bitcoin-qt) configuration

_The `/config` directory is used by the [base image for persisting settings](https://github.com/jlesage/docker-baseimage-gui#config-directory)
of the image tools and the application running. We set it as the HOME directory, so this results in bitcoin-qt
setting the data directory to `/config/.bitcoin` by default._

## Other Settings

Please refer to the [documentation of the base image](https://github.com/jlesage/docker-baseimage-gui) for
VNC/web UI related settings, such as securing the connection and other configurations.

# Licensing

This project is licensed under the MIT License. Please reference original upstream sources:

jlesage/docker-baseimage-gui:
https://github.com/jlesage/docker-baseimage-gui

bitcoin/bitcoin:
https://github.com/willcl-ark/bitcoin-knots-docker   
https://hub.docker.com/r/bitcoin/bitcoin

bitcoinknots:
https://github.com/bitcoinknots/bitcoin
