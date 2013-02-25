---
layout: post
title: "Arrancar Gparted o Clonezilla Live desde el Disco Duro con grub o grub2"
date: 2013-02-21 19:31
comments: true
categories: 
- Cuaderno-Laboratorio
- mini-servidor
---

En un equipo como el mini-servidor del que vengo hablando donde no tenemos lector de cd/dvd, floppy, usb ni otros periféricos, aparte de interfaz de red.

Una forma de utilizar Gparted o Clonezilla es bajar la Live y arrancarlos desde el bootloader previo (grub o grub2)

Grub2 puede iniciar archivos iso almacenados en alguna partición que pueda leer (fat, ext2, ext3,...).

La primera parte es común... Iniciar el SO previo, bajar el zip y descomprimirlo...

	wget "http://downloads.sourceforge.net/project/gparted/gparted-live-stable/0.14.1-6/gparted-live-0.14.1-6-i686-pae.zip?r=&ts=1361810860&use_mirror=switch" -O gparted-live-0.14.1-6-i686-pae.zip
	o 
	wget "http://downloads.sourceforge.net/project/clonezilla/clonezilla_live_stable/2.0.1-15/clonezilla-live-2.0.1-15-i686-pae.zip?r=&ts=1361816054&use_mirror=ignum" -O clonezilla-live-2.0.1-15-i686-pae.zip

Supongamos que disponemos de grub como gestor de arranque y una partición fat en hda4 donde pondremos GParted Live/Clonezilla Live. Comenzaremos descomprimiendo los archivos en esa partición.

	mount /dev/hda4 ./tmpmnt
	unzip *-live-*.zip -d tmpmnt
	mv tmpmnt/live tmpmnt/live-hd

Si no se cambia el nombre del directorio de "live" a "live-hd", por ejemplo, pueden encontrarse problemas si se tiene una versión en el disco duro y se quiere arrancar otra live, en CD o USB.

##GParted Live

A continuación podemos añadir una entrada en menu.lst de grub o, si queremos hacerlo desde la linea de comando de grub teclearemos algo muy similar cuando arranquemos.

*Para GRUB 1.x (Legacy)* editaremos el /boot/grub/menu.lst añadiendo lo siguiente:

	title     GParted live
	root      (hd0,3)
	kernel    /live-hd/vmlinuz boot=live config union=aufs noswap noprompt vga=788 ip=frommedia live-media-path=/live-hd bootfrom=/dev/hda4 toram=filesystem.squashfs
	initrd    /live-hd/initrd.img
	boot
                
Recuérdese que en la sintaxis de la versión 1 de grub, /dev/hda4 es (hd0,3).
        
*Para GRUB 2.x (y 1.9x)* para añadir una entrada de menú deberemos editar /etc/grub.d/40_custom y despues hacer ejecutar update-grub2

	menuentry "GParted live" {
	  set root=(hd0,4)
	  linux /live-hd/vmlinuz boot=live config union=aufs noswap noprompt vga=788 ip=frommedia live-media-path=/live-hd bootfrom=/dev/hda4 toram=filesystem.squashfs
	  initrd /live-hd/initrd.img
	}
                
En este caso aunque la partición sea la misma (hda4) la sintaxis de grub2 comienza a contar en 1 y no en 0 por lo que debemos escribir (hd0,4) en vez de (hd0,3). Como ya se ha comentado tras esto debemos ejecutar _update-grub2_.
 
 Alternativamente se puede ejecutar arrancar desde el archivo iso con grub2. Por ejemplo, con gparted-live-0.5.2-9.iso en /home/isos podríamos modificar /etc/grub.d/40_custom de grub2
 
	menuentry "Gparted live" {
		set isofile="/home/isos/gparted-live-0.5.2-9.iso"
		loopback loop $isofile
		linux (loop)/live/vmlinuz boot=live config union=aufs noswap noprompt vga=788 ip=frommedia toram=filesystem.squashfs findiso=$isofile
		initrd (loop)/live/initrd.img
	}

Y, de nuevo ejecutar _update-grub2_ para actualizar la configuración de grub2

*NOTA1*: En los ejemplos anteriores se ha añadido el parámetro "toram=filesystem.squashfs" para que la partición donde están los archivos, /dev/hda4 en el ejemplo, no se bloquee tras arrancar el Live correspondiente desde el disco duro.

*NOTA2*: Recuérdese comprobar los parámetros en syslinux/syslinux.cfg descomprimido desde el archivo zip. Deberemos incluirlos en los ejemplos anteriores. Y lo mismo respecto a los _paths_ a los archivos. 

*NOTA3*: Hay un límite de longitud en para los parametros de arranque en grub1 (256 caracteres, por ejemplo)
    
##Clonezilla Live

El principio es el mismo,... bajar el zip, esta vez Clonezilla Live. Vamos directamente a las entradas de grub y grub2..

*Para GRUB 1.x (Legacy)* editaremos el /boot/grub/menu.lst añadiendo lo siguiente:

    title Clonezilla live on harddrive
    root (hd0,3)
    kernel /live-hd/vmlinuz boot=live live-config noswap nolocales edd=on nomodeset ocs_live_run="ocs-live-general" ocs_live_extra_param="" ocs_live_keymap="" ocs_live_batch="no" ocs_lang="" vga=788 ip=frommedia nosplash live-media-path=/live-hd bootfrom=/dev/sda4 toram=filesystem.squashfs
    initrd /live-hd/initrd.img
    boot

*Para GRUB 2.x (y 1.9x)* para añadir una entrada de menú deberemos editar /etc/grub.d/40_custom y despues hacer ejecutar update-grub2

	menuentry "Clonezilla" {
	  set root=(hd0,4)
	  linux /live-hd/vmlinuz boot=live live-config noswap nolocales edd=on nomodeset ocs_live_run=\"ocs-live-general\" ocs_live_extra_param=\"\" ocs_live_keymap=\"\" ocs_live_batch=\"no\" ocs_lang=\"\" vga=788 ip=frommedia nosplash live-media-path=/live-hd bootfrom=/dev/sda4 toram=filesystem.squashfs
	  initrd /live-hd/initrd.img
    }

Después será necesario ejecutar _update-grub2_ para actualizar la configuración de grub2.

*NOTA4*: Recuérdese poner \ (barra invertida) antes de " (comillas) para "escapar" ese carácter en los parámetros de grub2. De otra forma no se mostrarían en /proc/cmdline y algunas acciones de Clonezilla no funcionarían.

Como ya hemos visto también es posible arrancar directamente del archivo iso con grub2. Supongamos que tenemos el iso en /home/isos/clonezilla-live-1.2.6-24.iso. De nuevo editaremos _/etc/grub.d/40-.custom_. Por ejemplo:

    menuentry "Clonezilla live" {
	  set isofile="/home/isos/clonezilla-live-1.2.6-24.iso"
	  loopback loop $isofile
	  linux (loop)/live/vmlinuz boot=live live-config noswap nolocales edd=on nomodeset ocs_live_run=\"ocs-live-general\" ocs_live_extra_param=\"\" ocs_live_keymap=\"\" ocs_live_batch=\"no\" ocs_lang=\"\" vga=788 ip=frommedia nosplash toram=filesystem.squashfs findiso=$isofile
	  initrd (loop)/live/initrd.img
    }

Y tras ello ejecutamos _update-grub2_ para actualizar la configuración de grub2.

*NOTA5*: Asignamos "live-media-path=/live-hd" ya que los archivos no están en el path por defecto (live). Forzamos "bootfrom=/dev/hda4" (files are on /dev/hda4) para que si hubiese otro Clonezilla-Live, por ejemplo en el lector de CD arranque de todas formas el correcto. De nuevo el parámetro "toram=filesystem.squashfs" se añade para que se pueda usar la partición que tiene los archivos tras arrancar (y se pueda montar, por ejemplo). Si se quiere que live-initramfs copie todos los archivos (de /dev/hda4) se puede usar tan solo el parámetro "toram" (no "toram=filesystem.squashfs"). Esto es útil cuando se tiene en /dev/hda4 algunos archivos personalizados que sean necesarios.

La NOTA2 es de nuevo aplicable en este caso.
