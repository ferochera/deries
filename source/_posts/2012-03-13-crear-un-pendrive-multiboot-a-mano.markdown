---
layout: post
title: "Crear un pendrive multiboot a mano"
date: 2012-03-13 15:31
comments: true
categories: 
- Cuaderno-laboratorio
- General
keywords: pendrive, multiboot, clonezilla, gparted, system rescue cd, wifiway, knoppix, hiren's boot cd
---
Aunque hay un montón de automatizaciones o semi-automatizaciones para crear pendrives con diferentes _livecd_'s decidí hacerlo a mano para aprender un poco más de **syslinux/isolinux** como gestor de arranque y porque, creo recordar, ninguno incluía _Hiren's Boot CD_.

Los livecds/utilidades que incluí son:

* Hiren's Boot CD 14.1
* HDD Regenerator 2011
* Hardware Detection Tool 0.5.0
* KNOPPIX 6.7.1
* WIFIWAY 2.0.3
* CLONEZILLA 1.2.10
* GPARTED 0.9.1
* SYSTEM RESCUE CD
* GHOST RECOVERY CD

<!--more-->La base del proceso fue el artículo [http://www.taringa.net/posts/info/10670342/USB-Multiboot-sin-formatear_-paso-a-paso-_01_11_11_.html](http://www.taringa.net/posts/info/10670342/USB-Multiboot-sin-formatear_-paso-a-paso-_01_11_11_.html).

De él obtuve el archivo [MultibootLFM](/downloads/MultibootLFM.7z) que me sirvió de base. En él se incluía opciones para arrancar el Hiren's boot cd y también para lanzar la instalación de windows desde USB. Se trata de ir modificando la configuración de syslinux para adaptarla a las opciones que deseamos. 

Lo que hice es adaptar las configuraciones de cada live en las que el arranque era a través de isolinux para lanzarlas desde la pantalla de entrada principal. 

La configuración principal de syslinux me quedó...
{% include_code syslinux.cfg %}

Cada una de las configuraciones parciales había que revisarlas para añadirles una entrada de volver al principal y revisar el _path_ de los archivos añadidos al pendrive.

El contenido del pendrive. Creo que basta con 8GB pero yo usé uno de 16GB.

```
drwx------        8192 nov 10 09:51 autorun
drwx------        8192 nov 10 11:36 boot
drwx------        8192 ene 31  2011 bootdisk
-r--r--r--      438840 dic 17  2007 bootmgr
drwx------        8192 nov  9 11:32 boot_wifiway
-rw-r--r--         135 nov  8 20:31 Clonezilla-Live-Version
-rw-r--r--        1236 nov 10 10:54 contenido.txt
drwx------        8192 ene 20  2008 docs
drwx------        8192 ene 20  2008 driver validation
drwx------        8192 nov 10 10:39 EFI
-rw-r--r--         525 nov  9 14:18 GParted-Live-Version
drwx------        8192 ago 22  2011 HBCD
drwx------        8192 nov  8 20:31 home
drwx------        8192 sep 14 18:28 KNOPPIX
-r--r--r--       32256 feb 29 18:05 ldlinux.sys
drwx------        8192 nov  8 20:31 liveclz1210
drwx------        8192 nov  9 14:18 livegptd010
drwx------        8192 mar  2  2010 ntpasswd
drwx------        8192 ene 20  2008 sources
-r--r--r--      663206 ene 20  2008 symdriverinfo.xml
-r--r--r--         147 ene 20  2008 syminfo.xml
-rw-r--r--   302059520 ago 23  2011 sysrcd.dat
drwx------        8192 ene 20  2008 updatelocator
drwx------        8192 sep 15 19:19 wifiway
```

El contenido de /boot/syslinux es:

```
-rw-r--r--   193094 nov 10 15:06 base.png
-rw-r--r--     2048 sep 14 18:29 boot.cat
-rw-r--r--      360 jun  6  2011 boothdd.lst
-rw-r--r--    20192 abr 18  2011 chain.c32
-rw-r--r--     6138 nov  9 13:42 clonezilla.cfg
-rw-r--r--     4748 abr 18  2011 config.c32
-rw-r--r--    43283 sep 20 06:34 drblwp.png
-rw-r--r--     4011 nov  9 14:23 gparted.cfg
-rwxr-xr-x   285260 jun  7  2011 grub.exe
-rw-r--r--   642444 nov  9 14:18 Gsplash.png
-rw-r--r--   350388 may 17  2011 hdt.c32
-rw-r--r--    24576 abr 18  2011 isolinux.bin
-rw-r--r--     4516 dic 28  2010 kbdmap.c32
-rw-r--r--  1474560 feb  7  2009 knoppix_balder.img
-rw-r--r--       93 sep 14 15:00 knoppix_boot.msg
-rw-r--r--     3181 nov  4 20:52 knoppix.cfg
-rw-r--r--     1335 sep 14 18:28 knoppix_f2
-rw-r--r--     1324 sep 14 18:28 knoppix_f3
-rw-r--r--  3688752 sep  9  2011 knoppix_linux
-rw-r--r--  3955456 sep  9  2011 knoppix_linux64
-rw-r--r--    20052 feb  7  2009 knoppix_memdisk
-rw-r--r--   124648 mar  9  2011 knoppix_memtest
-rw-r--r--   951242 sep 13 05:01 knoppix_minirt.gz
-rw-r--r--    32768 may 17  2011 ldlinux.sys
-rw-r--r--    18186 jun 23  2011 logo.16
drwx------     8192 sep 26  2010 maps
-rw-r--r--    26140 may 30  2011 memdisk
-rw-r--r--    56164 abr 18  2011 menu.c32
-rw-r--r--     5150 jul 24  2007 novafont.psf
-rw-r--r--    46464 sep 20 06:34 ocswp.png
-rw-r--r--   709349 may 31  2011 pci.ids
-rw-r--r--      800 abr 18  2011 reboot.c32
-rw-r--r--  9767104 ago 22  2011 syrcd_altker32
-rw-r--r--  9898672 ago 22  2011 syrcd_altker64
-rw-r--r--  8743112 ago 23  2011 syrcd_initram.igz
-rw-r--r--    25340 dic 28  2010 syrcd_memdisk
-rw-r--r--  9804944 ago 13  2011 syrcd_rescue64
-rw-r--r--  9477120 ago 23  2011 syrcd_rescuecd
-rw-r--r--     3209 nov 10 14:47 syslinux.cfg
-rw-r--r--    23017 nov  9 15:16 sysrescd.cfg
-rw-r--r--     1461 ago 23  2011 sysrf1boot.msg
-rw-r--r--     1329 sep 26  2010 sysrf2images.msg
-rw-r--r--     1768 sep 26  2010 sysrf3params.msg
-rw-r--r--     1564 sep 26  2010 sysrf4arun.msg
-rw-r--r--     1667 sep 26  2010 sysrf5troubl.msg
-rw-r--r--     1282 sep 26  2010 sysrf6pxe.msg
-rw-r--r--     1364 sep 26  2010 sysrf7net.msg
-rw-r--r--      723 may 17  2011 tema_base.cfg
-rw-r--r--   155792 abr 18  2011 vesamenu.c32
-rw-r--r--     6414 nov  9 11:34 wifiway.cfg
```

y los archivos de configuración utilizados son bajables pinchando [en este enlace](/downloads/syslinux_cfgs.7z).

El resto del procedimiento consiste en mezclar los distintos archivos de cada liveCD. Como puede verse en los listados se ha copiado el contenido importante de los livecds pero algunos nombres de carpeta se han adaptado para que los contenidos no se machaquen.

