---
layout: post
title: "Crear imagen de firmware de Ubiquiti con quagga"
date: 2009-05-15 00:20
comments: true
categories: 
- guifi.net
- Cuaderno-Laboratorio
keywords: firmware, airos, ubiquiti, quagga, nanostation5
---
El objetivo es crear un archivo bin con el firmware de ubiquiti para nano5 o wispstation5 modificado de modo que incluya quagga como implementación de enrutamiento dinámico (usando ospf). Dado que el toolchain no ha cambiado desde la versión de inveneo en vez de aplicar sus cambios y compilar lo que haremos es abrir el firmware de inveneo extraer los scripts, librerias y ejecutables y añadirselos a la última versión (actualmente la 3.3.2).

Este procedimiento está basado en la información compartida en las webs [http://dren.dk/ubi.html](http://dren.dk/ubi.html) y [http://rotobator.es](http://rotobator.es) y a ellos corresponde lo esencial del mérito.

<!--more-->Procedimiento seguido:

0- Bajar los firmwares: versión 3.3.2 de ubiquiti (http://www.ubnt.com/downloads/XS-fw/v3.3.2/XS5.ar2313.v3.3.2.4257.090214...) y versión 3.2 con quagga de inveneo.org (http://community.inveneo.org/downloads/ubnt/XS5/XS5.latest.bin)

1- Bajar la toolchain de la web de Ubiquiti ([http://www.ubnt.com/downloads/sdk/toolchain-mips-ls_0.1-1.deb](http://www.ubnt.com/downloads/sdk/toolchain-mips-ls_0.1-1.deb)), instalarla (sudo dpkg -i toolchain-mips-ls_0.1-1.deb)

2- Bajar el SDK de la versión a utilizar ([http://www.ubnt.com/downloads/XS-fw/v3.3.2/SDK.UBNT.v3.3.2.4257.tar.bz2](http://www.ubnt.com/downloads/XS-fw/v3.3.2/SDK.UBNT.v3.3.2.4257.tar.bz2)), descomprimirlo.

3- Instalar las herramientas recomendadas ([http://wiki.ubnt.com/wiki/index.php/AirOS-SDK](http://wiki.ubnt.com/wiki/index.php/AirOS-SDK)) para poder compilar, incluida sharutils.

4- Bajar el patch para compilar en las últimas versiones de ubuntu (wget [http://dren.dk/dl/SDK.UBNT.v3.3.2.4257-compilefixes.diff](http://dren.dk/dl/SDK.UBNT.v3.3.2.4257-compilefixes.diff)) y aplicarlo al código del SDK:

    patch -p0 < SDK.UBNT.v3.3.2.4257-compilefixes.diff

5- Compilar el firmware "make xs5". No vamos a usar ese firmware sino que los que nos interesa es que se compilen las utilidades para abrir el firmware (mkfwimage,...) situadas en SDK.../tools/bin

6- Copiar las utilidades de dren.dk (diff-dir, patch-fw, unwrap-fw) a la carpeta de utilidades del sdk (SDK.../tools/bin)

7- Se podría realizar el resto del procedimiento de un modo automático utilizando el script patch-fw de dren.dk pero voy a hacerlo manual para saber realmente que se está haciendo (rarito que es uno ;-)). Basandome en ese scritp y en el de rotobator.es (http://rotobator.es/arxius/imagen_fs.sh) realizo las siguientes acciones:

7.1- desde SDK.../tools/bin ejecuto lo sgte para montar las imágenes

    ./unwrap-fw ../../../XS5.ar2313.v3.2.SDK.090218.1511.bin ../../../XS5-3.2-quagga
    ./unwrap-fw ../../../XS5.ar2313.v3.3.2.4257.090214.1458.bin ../../../XS5-3.3.2

para que quede, dentro de carpetas al mismo nivel que el SDK los firmwares abiertos de ambas versiones

7.2- Copiar y revisar los siguientes archivos desde las versión abierta de la versión 3.2-quagga a la 3.3.2. La lista está ordenada teniendo en cuenta la carpeta del archivo

    'bin/ospfd',
    'bin/quaggad-restart.sh',
    'bin/ripd',
    'bin/saveconfig',
    'bin/watchquagga',
    'bin/zebra',
    'lib/libospf.la',
    'lib/libospf.so.0.0.0',
    'lib/libzebra.la',
    'lib/libzebra.so.0.0.0',

y los enlaces

    'lib/libospf.so',
    'lib/libospf.so.0',
    'lib/libzebra.so',
    'lib/libzebra.so.0',

además de los archivos de configuración:

    'usr/etc/ospfd.conf',
    'usr/etc/poststart.d',
    'usr/etc/poststart.d/quagga.sh',
    'usr/etc/ripd.conf',
    'usr/etc/zebra.conf',
    'usr/etc/rc.poststart',
    'usr/etc/rc.poststop',
    'usr/etc/rc.prestart',
    'usr/etc/rc.prestop',

Comparamos entre las 2 versiones para ver si hay diferencias...

    'usr/etc/rc.d/rc', --> si que hay diferencias
    'usr/etc/system.cfg', --> faltaría copiarlo o adecuarlo con las lineas de org.inveneo...

Y finalmente:
    'usr/lib/inveneo',
    'usr/lib/inveneo/inveneo-utils.sh'

7.3- Una vez copiados y tras comparar acabo añadiendo lo siguiente en el urs/etc/system.cfg. También quito el telnetd. Para más datos sobre la configuración sería bueno visitar la wiki de inveneo.

    org.inveneo.rip=disabled
    org.inveneo.rip.config.manual=disabled
    org.inveneo.rip.export.kernel-routes=disabled
    org.inveneo.ospf=enabled
    org.inveneo.ospf.config.manual=enabled
    org.inveneo.strip.default-route=disabled

    sshd.status=enabled
    sshd.port=22

7.4- Revisemos las diferencias en el script rc

```
$ diff XS5-3.3.2/fs/usr/etc/rc.d/rc XS5-3.2-quagga/fs/usr/etc/rc.d/rc
10,11c10,11
< if [ -f /etc/persistent/rc.prestop ]; then
< . /etc/persistent/rc.prestop
---
> if [ -f /usr/etc/rc.prestop ]; then
> . /usr/etc/rc.prestop
19,20c19,20
< if [ -f /etc/persistent/rc.prestart ]; then
< . /etc/persistent/rc.prestart
---
> if [ -f /usr/etc/rc.prestart ]; then
> . /usr/etc/rc.prestart
43,44c43,44
< if [ -f /etc/persistent/rc.poststop ]; then
< . /etc/persistent/rc.poststop
---
> if [ -f /usr/etc/rc.poststop ]; then
> . /usr/etc/rc.poststop
```

Acabo copiando el rc de inveneo también. Ojo esto hace que el único script que se coge de /etc/persistent sea el rc.poststart, que debería ser justamente el que arranque quagga tras el inicio del sistema.

En teoría ya están hechas todas las modificaciones. Ahora habrá que volver a empaquetar el firmware en un archivo bin... Para ello de nuevo nos fijamos en los scripts de [rotobator.es](http://rotobator.es) y [dren.dk](http://dren.dk/ubi.html)

8- Crear el nuevo firmware (siguiendo script de rotovator y comparándolo con dren.dk)

8.1- Cambiar la versión. Cambiar /usr/lib/version (XS5.ar2313.v3.3.2.4257.090214.1458) por la nueva (XS5.ar2313.v3.3.2.4257.090214.1458.quagga)

    $ find fs -type f -exec sed -i s/XS5.ar2313.v3.3.2.4257.090214.1458/XS5.ar2313.v3.3.2.4257.090214.1458.quagga/g {} \;

8.2- Crear el enlace correspondiente en la carpeta /usr/www

    $ (cd fs/usr/www && ln -sf . XS5.ar2313.v3.3.2.4257.090214.1458.quagga)

y borrar el enlace previo

    $ rm XS5.ar2313.v3.3.2.4257.090214.1458

8.3- Para el empaquetado volvemos al script de dren.dk (porque era el que hemos usado para el desempaquetado). Renombramos el cramfs: fw.cramfs --> fw.cramfs.viejo a modo de backup por si acaso y, a continuación, creamos el nuevo

    cd airos (donde estén las carpetas SDK.., XS5-3.3.2, XS5-3.2...)
    $ fakeroot SDK.UBNT.v3.3.2.4257/tools/bin/mksquashfs XS5-3.3.2/fs XS5-3.3.2/fw.cramfs -be -all-root -noappend

8.4- Cambio también el archivo versión que hay en la carpeta de fw para que corresponda con la actual. Esto creo que es superfluo y que es simplemente información que se había creado al desempaquetar pero por si acaso estoy equivocado lo cambio.

8.5- Reconstruir el firmware a partir de los archivos fw.* y version. Se usa la herramienta mkfwimage conla información contenida en fw.txt (que indica los tamaños y posiciones de cada parte en él)

    cd a la carpeta donde está el fw.cramfs, en mi caso XS5-3.3.2/
    $../SDK.UBNT.v3.3.2.4257/tools/bin/mkfwimage -v XS5.ar2313.v3.3.2.4257.090214.1458.quagga -i fw.txt -o ../XS5.ar2313.v3.3.2.4257.090214.1458.quagga.bin

Atención: existe una diferencia de tamaño de 327680bytes (320kB) que viene a ser el tamaño de las aplicaciones o sea que debería ser correcto. Para ello también nos ha de sobrar espacio según el fw.txt (realmente cuando generamos la imagen nos dice que todavía nos sobra tamaño respecto del reservado).

**9.** Probar el firmware...

Lo primero que hice fue cargar ese firmware (XS5.ar2313.v3.3.2.4257.090214.1458.quagga.bin). Lo que se observa es que no carga la configuración que le hemos puesto en el firmware.

Mi conclusión momentanea es que dado que ya existe configuración en la partición dedicada a ello esa prevalece y no se genera una nueva a partir del firmware. Suponiendo que eso sea cierto ¿cómo podemos forzar esa regeneración de la configuración? Podríamos intentar cargar en el firmware una partición de configuración vacía que machaque la que haya (jugamos con fuengo ¿no?)

Para ver si podemos hacerlo todo de una vez voy a recrear un firm igual que el anterior pero con la partición de configuración con todos los bytes a 0 para que se regenere el system.cfg (almenos) desde el del firmware... (ver [http://ubnt.com/forum/viewtopic.php?t=2184](http://ubnt.com/forum/viewtopic.php?t=2184))

9.1-. Creo el archivo fw.cfgfix lleno de 0

    $ dd if=/dev/zero of=fw.cfgfix bs=64k count=2

9.2- modifico fw.txt --> fw2.txt añadiendo la linea:

    cfg 0x03 0xBFFC0000 0x00020000 0x00000000 0x00000000 fw.cfgfix

Donde las separaciones deben ser tabuladores (\t, para los amigos) en vez de espacios.

9.3- Regeneramos el archivo bin con el firmware usando de nuevo mkfwimage:

    $ ../SDK.UBNT.v3.3.2.4257/tools/bin/mkfwimage -v XS5.ar2313.v3.3.2.4257.090214.1458.quagga -i fw2.txt -o ../XS5.ar2313.v3.3.2.4257.090214.1458.quagga-cfgfix.bin
    $ ../SDK.UBNT.v3.3.2.4257/tools/bin/mkfwimage -v XS5.ar2313.v3.3.2.4257.090214.1458.quagga-cfgfix -i fw2.txt -o ../XS5.ar2313.v3.3.2.4257.090214.1458.quagga-cfgfix.bin

Esto genera la salida:

    Firmware version: 'XS5.ar2313.v3.3.2.4257.090214.1458.quagga'
    Output file: '../XS5.ar2313.v3.3.2.4257.090214.1458.quagga-cfgfix.bin'
    Part count: 4
    RedBoot: 181960 bytes (free: 14648)
    kernel: 497774 bytes (free: 354194)
    cramfs: 2662400 bytes (free: 221184)
    cfg: 131072 bytes (free: 0)

En esta salida vemos que todavía nos cabría en el sistema de archivos (cramfs) aplicaciones hasta unos 200kB

9.4 Y a probar de nuevo con el nuevo firmware (XS5.ar2313.v3.3.2.4257.090214.1458.quagga-cfgfix.bin). Es posible que me toque recuperar con tftp pero ya veremos. Por si acaso sería muy importante (si nos interesa la configuración previa) hacer una copia de seguridad.

Por si hay por esos mundos algún otro "descerebrao" que quiera probar este firmware lo adjunto ;-) Falta regenerarlo de nuevo ya que me dice "Bad Firmware update image" al intentar subirlo con la interfaz web. Supongo que tiene que ver con el la versión tal como está arriba o debo ponerle la versión en todo (¿?). O quizá simplemente no soporta que suba esa partición.

Otra opción recomendada es subir con tftp pero para ello debo desmontar la MaxStation así que de momento lo dejo aquí.

**Seguimiento:**

##APENDICE 1. 

Vamos a ver que significa el mensaje del "mal firmware".

Revisando upgrade.cgi se ve que se llama a la función fw_validate que está en www/lib/system.inc... Para ver que ocurre se puede subir el archivo a mano (scp) y lo renombramos a /tmp/fwupdate.bin para seguidamente ejecutar "/sbin/fwupdate -c" con lo que obtenemos:

    FW image partition "cfg" (4) has a base address, 0xBFFC0000 outside the flash memory map. Valid range is 0xBE000000-0xBE400000.

Dado que doy por hecho que la configuración no ha cambiado respecto de la versión 3.0 a la que se hace referencia en el hilo del forum [http://ubnt.com/forum/viewtopic.php?t=2184](http://ubnt.com/forum/viewtopic.php?t=2184) esto me hace suponer que los desarrolladores de ubiquiti han introducido limitaciones en las últimas versiones de fwupdate. Esto me deja con la última opción de intentarlo vía tftp.

Como opinión personal de este momento comentar que sería más fácil entrar vía ssh/scp y modificar/copiar la configuración para adaptarla en vez de tratar de regenerarla.

##APENDICE 2.

La instalación via tftp funciona:

```
_Reset con el botón de unos 10s_
$ tftp 192.168.1.20
tftp> bin
tftp> put flash_update (en los últimos firmwares no hace falta renombrar a este nombre)
tftp> quit
_esperar unos 10min_
```

Como ya he comentado se instala y se reconstruye la configuración incluyendo los valores adecuados (los de org.inveneo... y el servidor de ssh).

¿Por qué no arranca quagga(zebra+ospfd)? Mi impresión es que /etc/rc.d/rc también debía ser cambiado de un modo similar al punto 7.4 en lo que corresponde al poststart

##APENDICE 3.

Los firmwares finales son los que se presentan a continuación. Para usarlos se deberán descomprimir (el zip es para que me deje subir el adjunto) y aunque no debe ser necesario se puede quitar la última extensión para dejarlo como *.bin.

["XS5.ar2313.v3.3.2.4257.090214.1458.quagga.bin(.sincfgfix-rcmodif)"](/downloads/XS5.ar2313.v3.3.2.4257.090214.1458.quagga.bin.sincfgfix-rcmodif.zip): Versión sin el cfgfix y tras modificar el script rc. He comprobado que ahora arranca automáticamente quagga

["XS5.ar2313.v3.3.2.4257.090214.1458.quagga.bin(.cfgfix-rcmodif)"](/downloads/XS5.ar2313.v3.3.2.4257.090214.1458.quagga.bin.cfgfix-rcmodif.zip): Versión CON el cfgfix y tras modificar el script rc. Solo se puede actualizar a través de tftp con el procedimiento de recuperación. Esto supone tener acceso al botón de reset, cosa que no siempre es cierta sin desmontar.

En cualquier caso hará falta revisar que la configuración es la adecuada (ospf activado y con la configuración manual habilitada). También hará falta añadir los archivos de configuración adecuados (zebra.conf y ospfd.conf en /etc/persistent/) y asegurarse que todo se almacena ejecutando 

    saveconfig

o lo que es lo mismo

    cfgmtd -w -p /etc/
