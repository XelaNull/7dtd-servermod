# 7 Days To Die - ServerMod Manager

This project seeks to provide a suite of software and automation scripts to simplify the creation and management of a 7 Days to Die dedicated game server. The configuration is handled through a webpage that is provided by the Docker 7DTD projects:

- docker-ubuntu-7dtd: <https://github.com/XelaNull/docker-ubuntu-7dtd>
- docker-centos-7dtd: <https://github.com/XelaNull/docker-c7-7dtd>

**Current features of this project:**

- [7DTD-ServerMod Manager](https://github.com/XelaNull/7dtd-servermod) : Web Interface to manage your server

  - Start/Stop/Force Stop 7DTD Game server
  - View Game server log
  - Edit serverconfig.xml or any XML under Data/Config
  - Easy activation of pre-installed modlets
  - [Auto-Exploration of Map](https://github.com/XelaNull/7dtd-auto-reveal-map)
  - Random-World-Generation analysis to inform you on the placement of prefabs within your generated random seed
  - Authentication utilizes 7DTD Telnet password, to keep the configuration simple

- COMPO-PACK Prefabs installed, providing over 250 new buildings. Suggest using Modlet 'The Wild Land' to implement the Prefabs for placement during RWG.

- Over 450 Modlets pre-installed for easy activation, including Alloc's Server Fixes, ServerTools, Bad Company, CSMM Patrons, The Wild Land, and many more

**Future features:**

- Backup/Restore of Modlet selections & Game Saves
- Better game update support, without full wipe
- Update individual Modlet or all Modlets, from web interface
- Improved log viewer
