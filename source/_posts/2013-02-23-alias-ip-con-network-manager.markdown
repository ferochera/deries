---
layout: post
title: "Alias IP con Network Manager"
date: 2013-02-23 00:41
comments: true
categories:
- Cuaderno-Laboratorio
- Guifi.net
- dhcp
- ubuntu
---

_Origen: http://askubuntu.com/questions/217357/multiple-ips-for-a-single-wireless-nic_
	
Aunque en el artículo original se hable solo de wireless lo que se incluye es válido para cualquier conexión usable a través de NetworkManager

Para lo que sigue se asume que se utiliza NetworkManager,que las conexiones (cableadas o inhalámbricas) ya se han configurado usando DHCP y que se trata de IPv4.

Aunque no se pueden configurar, esperemos que solo de momento, las direcciones estáticas en en el GUI de NetworkManager hay un truco para hacerlo.

* Averiguar los dispositivos disponibles

	  $ nmcli dev

* Encontrar el UUID de la conexión que nos interesa configurar

	  $ nmcli con

* Añadir un script en /etc/NetworkManager/dispatcher.d/, ej 98AliasIP.sh, conteniendo lo siguiente:

{% codeblock /etc/NetworkManager/dispatcher.d/98AliasIP.sh lang:bash%}
	  #!/bin/bash
	  # interfaz wlan0, conexión correspondiente a ese UUID
	  #  solo añade el/los alias cuando esa conexión está activa
	  WLAN_DEV=wlan0
	  MYCON_UUID=31c48409-e77a-46e0-8cdc-f4c04b978901
	  if [ "$CONNECTION_UUID" == "$MYCON_UUID" ]; then
        # add alias for Network 1: 192.168.0.123/24
        ifconfig $WLAN_DEV:0 192.168.0.123 netmask 255.255.255.0 up
        # add alias for Network 2: 192.168.1.123/24
        ifconfig $WLAN_DEV:1 192.168.1.123 netmask 255.255.255.0 up
	  fi
{% endcodeblock %}

* Asegurarse de que el script tiene los permisos adecuados (chmod +x /path/to/script.sh) y rearrancar NetworkManager:

	  $ sudo service network-manager restart

Una vez se active la conexión se añadiran los 2 alias configurados. Puede comprobarse usando _/sbin/ifconfig_ o _ip addr show_. 