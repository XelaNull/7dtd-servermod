7DTD-ServerMod

This project seeks to provide a PHP webpage that can be used to manage a 7DTD Server.

The website should provide the ability to:

- Start, Stop, and Force Stop the 7DTD Server (implemented through scripts provided by my docker-ubuntu-7dtd & docker-centos-7dtd projects)
- View the 7DTD Server Log (implemented, but basic)
- Easy Check/Uncheck applying of Modlets (implemented, with no configuration file required)

The index.php manages files within your 7dtd game server installation so your webserver should be configured to run as the same user that will run your gameserver. If you start your journey with either docker-c7-7dtd or docker-ubuntu-7dtd you will end up with a fully usable 7DTD game server with an easy website to manage your enabled modlets.
