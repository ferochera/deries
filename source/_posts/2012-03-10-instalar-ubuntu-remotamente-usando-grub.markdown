---
layout: post
title: "Instalar Ubuntu remotamente usando grub"
date: 2012-03-10 15:24
comments: true
categories: 
- Cuaderno-Laboratorio
- mini-servidor
keywords: Ubuntu, instalación remota, grub2
---

Primero habrá que bajar el kernel y initrd adecuados para instalar desde imagen iso (vmlinuz_hdmedia, initrd_hdmedia) o desde red (vmlinuz_netboot, initrd_netboot), donde los "\_hdmedia" o "\_netboot" los añadí para diferenciarlas.

Después añadiremos las siguientes entradas (una o las dos) en la configuración de grub. Es necesario adecuar la partición donde estén los kernels de arranque. Para hdmedia resultaba interesante poner la imagen _iso_(ubuntu alternate, creo recordar) de instalación en la raíz de una partición vfat.

Fragmento de /etc/grub.d/40_custom:

```
menuentry "Instalacion Ubuntu (ssh-netconsole, hdmedia)" {
      set root=(hd0,5)
      linux /vmlinuz_hdmedia vga=normal ramdisk_size=16386 root=/dev/ram0 locale=en_US console-setup/ask_detect=false console-setup/layoutcode=us netcfg/choose_interface=auto netcfg/disable_dhcp=true netcfg/get_nameservers=132.1.6.55 netcfg/get_ipaddress=132.26.0.9 netcfg/get_netmask=255.255.0.0 netcfg/get_gateway=132.26.0.240 netcfg/confirm_static=true netcfg/get_hostname=halley netcfg/get_domain=aytocastellon.loc netcfg/wireless_wep= hw-detect/load_firmware=true anna/choose_modules=network-console network-console/password=r00tme network-console/password-again=r00tme rw --
      initrd /initrd_hdmedia.gz
}

menuentry "Instalacion Ubuntu (ssh-netconsole, netinstall)" {
      set root=(hd0,5)
      linux /linux_netboot vga=normal ramdisk_size=16386 root=/dev/ram0 locale=en_US console-setup/ask_detect=false console-setup/layoutcode=us netcfg/choose_interface=auto netcfg/disable_dhcp=true netcfg/get_nameservers=132.1.6.55 netcfg/get_ipaddress=132.26.0.9 netcfg/get_netmask=255.255.0.0 netcfg/get_gateway=132.26.0.240 netcfg/confirm_static=true netcfg/get_hostname=halley netcfg/get_domain=aytocastellon.loc netcfg/wireless_wep= hw-detect/load_firmware=true anna/choose_modules=network-console network-console/password=r00tme network-console/password-again=r00tme rw --
      initrd /initrd_netboot.gz
}
```

Finalmente actualizaremos la configuración de grub con 

    $ sudo update-grub2

Para instalar bastará con reiniciar y seleccionar esa entrada. Para hacerlo remotamente también tendremos que cambiar la configuración de grub para que sea esa opción la arranque automáticamente. 
