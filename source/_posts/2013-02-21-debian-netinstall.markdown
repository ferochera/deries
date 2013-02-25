---
layout: post
title: "Debian NetInstall"
date: 2013-02-21 18:38
comments: true
categories: 
- Cuaderno-Laboratorio
- mini-servidor
- debian
---

El procedimiento es similar al que se muestra en el [post de 2007 de instalación de Ubuntu..](http://xarx.es/deries/archives/12-Instalando-Ubuntu-Gutsy-desde-la-Red.html)

Primero hay que bajar el kernel y el initrd a una partición que sea legible por el bootloader (grub, grub2,...) que tengamos disponible y arrancar aprovechándolo

  [http://ftp.debian.org/debian/dists/wheezy/main/installer-i386/current/images/netboot/debian-installer/i386/](http://ftp.debian.org/debian/dists/wheezy/main/installer-i386/current/images/netboot/debian-installer/i386/)

No tiene mucho más... es como la instalación desde red o hdmedia de ubuntu pero con debian...  Por ejemplo, con grub-legacy podríamos hacer (suponiendo que lo hemos dejado en la partición sda5):

```
> root (hd0,4)
> kernel /linux ramdisk_size=16386 root=/dev/ram0 rw --
> initrd /initrd.gz
> boot
```

El hecho de cambiar de ubuntu a debian tiene que ver con el hecho de que ubuntu, desde 12.04, ya no soporta kernels i386 non-PAE. Esto significa que ya no es usable con el mini-servidor que ya tiene su edad y usa un via C3 como corazón.
