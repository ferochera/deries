---
layout: post
title: Instalando Ubuntu Gutsy desde la Red
categories:
- Cuaderno-Laboratorio
- mini-servidor
permalink: /archives/12-Instalando-Ubuntu-Gutsy-desde-la-Red.html
s9y_link: http://xarx.es/deries/archives/12-Instalando-Ubuntu-Gutsy-desde-la-Red.html
date: 2007-10-31 20:07:27.000000000 +01:00
---
<br />
<p>Voy allá con lo que no se debería hacer sin causa justificada: Instalar desde cero. Mis razones... que el sistema de momento solo me sirve para experimentación y que tras buscar algo de información en internet no he visto nada sencillo y no me apetecía investigar más. Esto me parecía más interesante.</p><p>Situación y Documentación inicial:</p><ul><li><a href="http://ubuntuforums.org/showthread.php?t=316093">Instalación de Ubuntu a partir de una imagen ISO</a>, sin quemarla. En el caso que nos ocupa solo nos interesa comparar el arranque</li><li>Aprovechamos que el equipo ya tiene un GRUB activo.</li></ul><p>Archivos iniciales:</p><ul><li>Los archivos para instalaciones alternativas: <a href="http://archive.ubuntu.com/ubuntu/dists/gutsy/main/installer-i386/current/images">http://archive.ubuntu.com/ubuntu/dists/gutsy/main/installer-i386/current/images</a></li><li>En concreto los archivos del núcleo (linux) e initrd.gz obtenidos de la carpeta <a href="http://archive.ubuntu.com/ubuntu/dists/gutsy/main/installer-i386/current/images/netboot/386/ubuntu-installer/i386/">http://archive.ubuntu.com/ubuntu/dists/guts...images/netboot/386/ubuntu-installer/i386/</a></li></ul>

<!--more-->Procedemos...

**1-.** Bajamos linux e initrd.gz al equipo a instalar. Utilizo una partición de fat32 (hda5) que gasto de almacen (Grub sabe como manejarlo) y dejo los archivos en la carpeta raíz.

**2-.** Arrancamos y en el menú de GRUB entramos a modo texto y, según los datos anteriores, tecleamos:

    > root (hd0,4)
    > kernel /linux ramdisk_size=16386 root=/dev/ram0 rw --
    > initrd /initrd.gz
    > boot

**3-.** A partir de este momento seguimos la instalación de un servidor ubuntu 7.10 'perfecto'. Realmente no es exactamente lo mismo que hacer la instalación desde un CD de instalación de ubuntu-server pero las diferencias son mínimas. Por cierto que además del nombre del equipo y usuario y la NO selección de ningún paquete además de la instalación base uso el particionado manual para elegir las particiones habituales pero en un espacio más reducido pues voy a mantener la lógica de fat32 (hd5) a la que solo le asigno el punto de montaje y elijo que no sea formateada. Y como el que mucho corre pronto para, realmente debía haber habilitado la instalación del servidor de ssh:

    $ sudo aptitude install openssh-server

Y también otras cosillas como screen, porque me resulta cómodo dejar sesiones abiertas aunque no esté ligada a un terminal... y como aparecía un error con el paquete tzdata ejecuto:

    $ sudo tzselect
    $ sudo aptitude reinstall tzdata

Además como no me hace ninguna ilusión habilitar el usuario 'root' utilizo _sudo -s_ en su lugar para obtener una consola de root y evitar el incluir sudo delante de cada comando para realizar las instalaciones.

Otros comentarios:

    Si estamos trabajando a través de ssh al reconfigurar la interfaz de red probablemente nos tocará borrar la entrada previa en .ssh/known_hosts pues en caso contrario no nos dejará conectarnos.
    Las fuentes de sources.list ya estarán adecuadas con el país. Y dado que la instalación se hace por red actualizadas.

**4-.** A continuación pasamos a la instalación de ISPConfig. Además del 'servidor perfecto' deberemos hacer previamente alguna cosilla más:

    en /etc/debian_version cambiar 'lenny/sid.0' por '4.0' para que ISPConfig se deje instalar.
    instalar además el paquete libxml2-dev (_aptitude install libxml2-dev_)

Actualizaciones y Comentarios previos
--------------------------------------

**Comentario 1**

Atención, atención:

Al bajar ispconfig asegurense de pinchar el enlace adecuado, no como yo, que me bajé la versión de desarrollo y no me funcionaba php.

Veremos si después de borrar, bajar, recompilar,... funciona ;-)

**Comentario 2**

Funciona!

**Comentario 3**

Segunda Instalación: Siguiendo este sistema, pero a partir de la iso (kubuntu altenate), he instalado gutsy en un portatil (Acer aspire 1400 del 2002) al que le falla el lector de DVD/CD (de hecho he tenido que deshabilitar el canal IDE1 para que no detectara el error repetidamente. Algún día lo sustituiré o quizá no :-( ).

Previamente había intentado la actualización pero no acabó de funcionar pues los paquetes del núcleo no se actualizaban así que decidí instalar desde cero (conservando los archivos personales, claro).

Dado que contaba con grub instalado y una partición que pueda leer grub (diferente de donde quiero instalar) baje el vmlinuz y el initrd.gz de la versión actual para [arranque desde 'hdmedia'](http://es.archive.ubuntu.com/ubuntu/dists/gutsy/main/installer-i386/current/images/hd-media/). Después basta con ir a la línea de comandos de grub y seguir las instrucciones del documento del artículo:

    >root (hd0,4)
    >kernel ...
    >initrd ...
    >boot

Si la iso está en la carpeta raíz de la misma partición lo habitual es que el programa de instalación encuentre la iso.

El resto es seguir la instalación habitual...

** Comentario 4**

*kubuntu jaunty*:
Probando la [versión gráfica del instalador](http://archive.ubuntu.com/ubuntu/dists/jaunty/main/installer-i386/current/images/hd-media/gtk/):

Para ello pongo algo más de disco, por si acaso, y las opciones gráficas...

    > root (hd0,4)
    > kernel /vmlinuz video=vesa:ywrap,mtrr vga=789 ramdisk_size=32768 root=/dev/ram0 rw --
    > initrd /initrd.gz
    > boot

* las opciones de video extraidas de internet (ej http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=blob;f=Documentation/fb/vesafb.txt)
* el modo de vga se puede obtener poniendo vga=ask, elegirlo y a la hora de volver a introducirlo ponerl en decimal en vez de hexadecimal (ej 0x315 (800x600x24)--> vga=789)

**Comentario 5**

*repositorios es*: En mi corta experiencia ubuntera he visto que habitualmente funciona mejor _archive.ubuntu.com_ que _es.archive.ubuntu.com_

Quizá esto cambie algún día.

