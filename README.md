# GBA-PK-multiplayer

This is a free mod that supports all versions and languages of generation 3 pokemon games. Release 1.0 is now out! It is massively improved to ALPHA 4.0, with new game modes you can access in the new MULTI option found in the start menu.

Dedicated server coming soon.

Youtube: https://www.youtube.com/channel/UCdXg0-BF9FblZ2GTi3u4orQ


Pokecommunity: https://www.pokecommunity.com/showthread.php?t=484949

# Installation

## Prerequisites

* [mGBA Emulator](https://mgba.io/)
* [Server](https://github.com/TheHunterManX/GBA-PK-multiplayer/releases/download/0.4/GBA-PK_Server.ALPHA.4.lua) Scipt
* [Client](https://github.com/TheHunterManX/GBA-PK-multiplayer/releases/download/0.4/GBA-PK_Client.ALPHA.4.lua) Scipt

## Setup on Single PC

### Steps

1. Open mgba and load the game
2. Go to Tools > Scripting > File > Load script...
3. Select the `Server` lua file
4. Go to File > New multiplayer window
5. Repeat steps 1-3 on the new window, except choose the `Client` lua file

## Setup on LAN

### Lua Config

1. Get the IPv4 address of the PC slated to run the `Server.lua` file
2. Open each `Client.lua` file and update the `IPAddress` variable
   - On line 1 replace `127.0.0.1` with the Server's IPv4 address

### Emulator Steps

1. Open mgba and load the game
2. Go to Tools > Scripting > File > Load script...
3. Select the `Server` lua file for the Server machine and `Client` lua file for the Client machines
