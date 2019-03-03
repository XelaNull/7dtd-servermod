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

- COMPO-PACK 38 Prefabs installed, providing over 250 new buildings.

- Custom RWG Modlet set:

  - Very large biomes, in a circular map, with prairie lands in the surrounding border.
  - Highly-Customized Prefab placement

    - Wide varying city sizes from small to mega-city
    - Stylized cities such as Asia Town
    - Maximized for best chance at maximum unique and total prefab counts

- Over 450 Modlets pre-installed for easy activation, including Alloc's Server Fixes, ServerTools, Bad Company, CSMM Patrons, The Wild Land, and many more

More modlets will be added in the near future.

*****Please be patient with us as this project is still under development.*****

**Future features:**

- Backup/Restore of Modlet selections & Game Saves
- Better game update support, without full wipe
- Update individual Modlet or all Modlets, from web interface
- Improved log viewer
