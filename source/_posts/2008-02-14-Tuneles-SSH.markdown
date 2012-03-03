---
layout: post
title: Tuneles SSH
categories:
- General
permalink: /archives/23-Tuneles-SSH.html
s9y_link: http://xarx.es/deries/archives/23-Tuneles-SSH.html
date: 2008-02-14 12:27:37.000000000 +01:00
---

Realmente no se trata solo de túneles sino de un manual en castellano hecho por HellGuest en vilecha.com: <a href="http://www.vilecha.com/Hellguest/ssh.asp"><b>Utilizando SSH</b></a>

Es realmente interesante tener un resumen reducido pero además aclara el uso de túneles con ssh-agent como puede verse en el capitudo dedicado a ello y que reproduzco...

<!--more-->
## Utilizando SSH


###Crear túneles con SSH

OpenSSH nos permite crear dos clases de túneles: locales y remotos. En los locales se redirecciona un puerto de la máquina local (cliente) hacia un puerto en una máquina remota a la que el servidor tenga acceso. En los túneles remotos, lo que se hace es redireccionar un puerto desde una máquina remota a la que el servidor tenga acceso hacia un puerto de la máquina local.

**Túneles locales**

La forma de crear túneles locales con OpenSSH es mediante la opción -L, cuya sintaxis es:

```
-L [dirección_escucha:]puerto_escucha:máquina_remota:puerto_máquina_remota
```

En caso de emplear direcciones IPv6, se puede utilizar la siguiente sintaxis:

```
-L [dirección_escucha/]puerto_escucha/máquina_remota/puerto_máquina_remota
```

Los túneles locales se establecen de la siguiente forma: primero se crea un conector (socket) de escucha en la máquina local, asociado al puerto puerto_escucha y, opcionalmente, a la dirección dirección_escucha. Cuando se realice una conexión al puerto en el que está escuchando el conector, OpenSSH encauzará la conexión a través del canal seguro hacia la máquina remota a la que el servidor tenga acceso, indicada por la IP máquina_remota y el puerto puerto_máquina_remota.

Para demostrar como funcionan los túneles locales, me basaré en el siguiente diagrama ilustrativo:

{% img center /images/ssh_tunel_local1.png 'Esquema ssh tunnel local' 'Esquema ssh tunnel local' %}

En el diagrama tenemos que nos encontramos en el equipo llamado alpha.local.net, y lo que queremos es acceder al servidor web (puerto 80) que hay en el equipo web.remoto.net, el problema es que entre nosotros y el servidor hay un router denominado router.remoto.net que nos impide acceder al servidor. Obviamente, el router ha de tener un servidor de SSH funcionando al que nosotros tengamos acceso, cumpliendose esta premisa, lo que vamos a hacer es redireccionar el puerto 80 (web) del servidor web.remoto.net hacia, por ejemplo, el puerto 8080 de nuestro equipo:

```
[hell@alpha.local.net] $ ssh-agent -L 8080:web.remoto.net:80 router.remoto.net
Enter passphrase for key '/home/hell/.ssh/id_dsa':
[hell@router.remoto.net] $
```

Hemos iniciado una sesión SSH interactiva en el router, pero además, ahora, en nuestro equipo, se habrá abierto el puerto 8080:

```
[hell@alpha.local.net] $ netstat -an | grep LISTEN
    tcp   0   0  127.0.0.1.8080  .   LISTEN
    tcp   0   0  .22            .   LISTEN
[hell@alpha.local.net] $
```

El túnel está creado, ahora, mientras no cerremos la sesión SSH con el router, cada vez que nos conectemos al puerto 8080 de nuestro equipo (localhost o alpha.local.net), nuestra conexión estará siendo reenviada al puert 80 del servidor web.remoto.net. Por ejemplo, para acceder a el desde un navegador, tendríamos que usar una URL del estilo: _http://localhost:8080/_

Hasta aquí, bien, pero... si nos fijamos, en la salida del comando netstat que hay arriba, el túnel sólo acepta conexiones desde alpha.local.net, porque el conector (socket) que creo está asociado a la IP 127.0.0.1, también conocida como localhost, que sirve para referirse al propio equipo, así es que, ¿qué pasaría si lo que buscásemos fuese que otro equipo se conecte al servidor web.remoto.net a través de nuestro equipo? Añadamos ese nuevo equipo a nuestro diagrama:

{% img center /images/ssh_tunel_local2.png 'Esquema ssh tunnel local (2)' 'Esquema ssh tunnel local (2)' %}

Para permitir que beta.local.net también pueda beneficiarse de nuestro túnel, tenemos que hacer que el socket no se asocie con la IP 127.0.0.1, esto se consigue poniendo un asterisco (*), o, la IP del propio alpha.local.net en el parámetro opcional dirección_escucha, ejemplo:

```
[hell@alpha.local.net] $ ssh-agent -L :8080:web.remoto.net:80 router.remoto.net
Enter passphrase for key '/home/hell/.ssh/id_dsa':
[hell@router.remoto.net] $
```

Si ahora ejecutásemos otra vez el comando netstat en alpha.local.net veríamos lo siguiente:

```
[hell@alpha.local.net] $ netstat -an | grep LISTEN
    tcp 0 0 .8080 . LISTEN
    tcp 0 0 .22 . LISTEN
[hell@alpha.local.net] $
```

El conector del túnel ahora acepta conexiones de cualquier equipo, perfectamente, ahora podríamos abrir un navegador en beta.local.net y poner la siguiente URL: _http://alpha.local.net:8080/_, la conexión sería canalizada a través del canal seguro establecido entre alpha.local.net y router.remoto.net, hasta llegar al puerto 80 de web.remoto.net.

**Túneles remotos**

La forma de crear túneles remotos con OpenSSH es mediante la opción -R, que tiene la siguiente sintaxis:

```
-R [dirección_escucha:]puerto_escucha:máquina_remota:puerto_máquina_remota
```

Pero si se quieren emplear direcciones IPv6, también se permite usar la siguiente sintaxis:

```
-R [dirección_escucha/]puerto_escucha/máquina_remota/puerto_máquina_remota
```

El mecanismo empleado para establecer los túneles remotos es: se crea un conector (socket) en el servidor asociado al puerto indicado por puerto_escucha y, opcionalmente, a la dirección IP dirección_escucha. Posteriormente, cuando se realice una conexión a dicho conector, la conexión será encauzada a través del canal seguro hacia una máquina a la que el equipo local tenga acceso, indicada por la IP máquina_remota y el puerto puerto_máquina_remota.

A modo de ejemplo sobre como se establecen los túneles remotos, basemonos en los equipos del siguiente diagrama:

{% img center /images/ssh_tunel_remoto1.png 'Esquema ssh tunnel remoto' 'Esquema ssh tunnel remoto' %}

Para ponernos en situación, imaginemos que nos encontramos en el equipo alpha.local.net y que lo que queremos es que alguien desde el equipo terminal.remoto.com se pueda conectar a un servidor web (puerto 80) que tenemos en nuestro equipo, el problema está en que el router deja que nosotros podamos conectarnos a terminal.remoto.com, pero impide que el pueda conectarse a nosotros. Entonces, creamos un túnel remoto de la siguiente forma:

```
[hell@alpha.local.net] $ ssh-agent -R 8080:localhost:80 terminal.remoto.net
Enter passphrase for key '/home/hell/.ssh/id_dsa':
[hell@terminal.remoto.net] $
```

Ahora, se habrá creado un conector (socket) en terminal.remoto.net que estará escuchando en el puerto 8080:

```
[hell@terminal.remoto.net] $ netstat -an | grept LISTEN
tcp 0 0 127.0.0.1.8080 . LISTEN
tcp 0 0 .22 .* LISTEN
hell@terminal.remoto.net] $
```

Cada vez que se establezca una conexión al puerto 8080 en terminal.remoto.net, esta conexión, será canalizada por el canal seguro hasta llegar al puerto 80 del equipo alpha.local.net, de esta forma, conseguimos que un equipo ajeno a nuestra red, pueda acceder a nuestro equipo. Pero, ¿qué pasaría si en lugar de a nuestro equipo lo que quisiéramos es que terminal.remoto.com pueda acceder a otro?, usemos el siguiente diagrama para orientarnos:

{% img center /images/ssh_tunel_remoto2.png 'Esquema ssh tunnel remoto (2)' 'Esquema ssh tunnel remoto (2)' %}

De nuevo, nos encontramos en alpha.local.net, pero ahora, el servidor está en web.local.net, y lo que queremos es que terminal.remoto.net pueda acceder a el, pero el router sigue impidiendo que terminal.remoto.net se pueda conectar, y sin embargo, si que deja que nosotros desde alpha.local.net podamos conectarnos a terminal.remoto.net. Entonces, un comando como el siguiente sería suficiente:

```
[hell@alpha.local.net] $ ssh-agent -R 8080:web.local.net:80 terminal.remoto.net
Enter passphrase for key '/home/hell/.ssh/id_dsa':
hell@terminal.remoto.net] $
```

Esto indica que un extremo del túnel se corresponde con el puerto 8080 del equipo al que hemos conectado (terminal.remoto.net), y, el otro extremo, es el puerto 80 del equipo web.local.net, así de simple. Al establezcer una conexión en el puerto 8080 de terminal.remoto.net, la conexión viajará por el canal seguro establecido entre el cliente y el servidor de SSH, y después, se establecerá una nueva conexión entre alpha.local.net y web.loca.net para que los datos puedan fluir hasta su destino.

Actualizaciones y Comentarios previos
--------------------------------------

**Comentario 1**

Utilícese ssh-agent como sinónimo de ssh... por ejemplo:

```
$ ssh -R 8080:web.local.net:80 usuario@terminal.remoto.net
```

**Comentario 2**

Ejemplo de uso donde además de abrir una sesión del usuario en serv1 se crearía 4 túneles (ej.: 2 para escritorio remoto en distintos equipos, otro para el puerto 8080 ej gestion web de otro equipo y la gestión de serv1)

```
$ ssh -L 8080:porta.midom.com:8080 -L 3389:win1.midom.com:3389 -L 3390:win2.midom.com:3389 -L 1081:serv1.midom.com:81 usuario@serv1.midom.com
```

_Atención_: para puertos < 1024 se necesita privilegios de administrador (ej sudo ssh ...) 
