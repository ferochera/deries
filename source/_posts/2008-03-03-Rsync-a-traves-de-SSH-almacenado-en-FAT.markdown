---
layout: post
title: Rsync a través de SSH. Almacenado en FAT
categories:
- Cuaderno-Laboratorio
permalink: /archives/24-Rsync-a-traves-de-SSH-almacenado-en-FAT.html
s9y_link: http://xarx.es/deries/archives/24-Rsync-a-traves-de-SSH-almacenado-en-FAT.html
date: 2008-03-03 18:53:35.000000000 +01:00
---
<br />
<p>La intención es respaldar una serie de carpetas en un equipo cliente a otro servidor. Realmente manteniendo una copia (mirror) de la original sin compresión, ni backups incrementales o diferenciales.</p><p>Las características de los sistemas hacen que usemos:</p>

    1. rsync en el cliente-origen de la información
    2. la transferencia sea a través de ssh
    3. el servidor-receptor de la información carece de demonio rsync
    4. el sistema de archivos en el que se almacena la información es FAT

Realmente el cliente es el taperserver del que ya hemos hablado anteriormente y el servidor en el que se almacena la información es un NSLU2 de Linksys al que se le ha modificado el firmware hasta un Unslung V2.3R63-uNSLUng-6.8 (ver <a href="http://www.nslu2-linux.org/" title="Linux en el NSLU2">nslu2-linux</a> para mas detalle). Ambos están conectados a internet con conexiones de banda ancha (o más bien estrecha) de diferentes proveedores y en lugares separados.

<div align="justify">
Para poner en marcha esta copia necesitamos que inicialmente en el equipo cliente esté instalado rsync, cron y openssh. Este último es necesario para crear las claves para que no haya que introducir las claves cada vez y podamos automatizar la copia usando cron. En el servidor bastará con openssh.</div><div align="justify"></div><div align="justify"></div><div align="justify">Lo primero que deberemos hacer es probar manualmente que se puede realizar la copia. En la mayor parte de los tutoriales recomiendan ejecutar desde el cliente:</div>

```
$ rsync -avz -e ssh carpeta-del-contenido-a-copiar/ usuarioremoto@serverdestino:/carpeta-destino/
```

<div align="justify">donde las opciones son a:archive(=-rlptgoD), v:verbose y z:comprimir. Si se usa la opción --dry-run podemos hacer una prueba con todo menos con la copia real por lo que es una buena opción a incluir inicialmente.</div><div align="justify"></div>

<!--more-->
Dado que tratamos de almacenar en un sistema FAT tendremos problemas con los nombres, con los permisos, con las fechas,... vamos que no nos sirve el -a. Se podría forzar el montaje del sistema de archivos con opciones de "lower" o "mixed" dependiendo de lo que nos convenga pero en el nslu2 con ese firmware me ha parecido que no permite seleccionarlo.

Las opciones típicas para rsync sobre FAT son "rsync -rvt --modify-window=1 --delete origen/ destino/" sin embargo también se deben considerar --size-only y --checksum (=-c). Esta última es más lenta pero es la que a mi me ha funcionado.

Una vez verificado el funcionamiento de rsync prepararemos las claves para que se pueda conectar sin pedirnos contraseña. Generamos en el equipo cliente el par de claves pública y privada:

```
$ ssh-keygen -t rsa -b 2048 -f /home/usuario/clave-de-este-host
```

Copiamos el archivo con la extensión .pub al servidor y lo añadimos en el archivo known_hosts de la carpeta .ssh del usuario que vamos a utilizar. En el cliente tenemos dos opciones, usar la opción -i cuando llamemos a ssh seguido del archivo de la clave privada o bien renombrarla como id_rsa y id_rsa.pub y moverlas a la carpeta .ssh del usuario que ejecutará la copia para que se tomen como las claves por defecto.
Finalmente solo nos queda añadir la linea adecuada al cron del usuario:

{% codeblock 'Añadir a cron (ejemplo: crontab -e)' %}
#sincronizar respaldo
05 01 * /usr/bin/rsync -rvc -e 'ssh -c blowfish-cbc' carpeta-copiar/ usuario@nslu2:/carpeta-destino/ >> ~/archivo.log
{% endcodeblock %}

donde la opción -c blowfixh-cbc tiene que ver con acelerar la transmisión con una encriptación menor. Dependiendo de que se vaya a transferir también se puede comprimir la transferencia con la opción adecuada en el ssh. Sin embargo la idea es que el nslu2 tenga la menor carga posible y además muchos de los archivos a transferir serán pdf, jpg o archivos ya comprimidos con lo que tampoco ganamos nada volviendo a comprimir.

