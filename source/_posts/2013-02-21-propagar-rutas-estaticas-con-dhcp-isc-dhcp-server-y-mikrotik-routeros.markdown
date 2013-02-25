---
layout: post
title: "Propagar rutas estáticas con dhcp (isc-dhcp-server y mikrotik routerOs)"
date: 2013-02-21 18:33
comments: true
categories: 
- Cuaderno-Laboratorio
- Guifi.net
- dhcp
---

##isc-dhcp-server

Para empezar podemos utilizar las opciones _option routers_ y _option static-routes_. La primera nos definirá la ruta por defecto (default gw) y la segunda nos permite añadir rutas estáticas a pares (red - gw). Por ejemplo:

    option routers 192.168.100.1;
    option static-routes 192.168.1.0 192.168.100.2, 10.0.0.0 192.168.100.3;

pero *SOLO SIRVE PARA RUTAS "CON CLASE" A(/8), B(/16), C(/24)*
  
o sea que hay que buscar otro camino para las rutas sin clase más habituales

Se declara la opciones siguientes en la sección global de la configuración del servidor (en _/etc/dhcp/dhcpd.conf_)

    option rfc3442-classless-static-routes code 121 = array of integer 8;
    option ms-classless-static-routes code 249 = array of integer 8;

La segunda linea es para los clientes que corren Microsoft Windows, ya que Microsoft decidió que usaría la opción 249 en vez de la que sugiere el estándar (121).

El siguiente paso es usar estas opciones dentro de la definición de la subred. Por ejemplo:

    subnet 192.168.1.0 netmask 255.255.255.0 {
       ... otras optiones ....
       option rfc3442-classless-static-routes 24, 192, 168, 123, 10, 10, 10, 1, 0, 192, 168, 1, 2;
       option ms-classless-static-routes 24, 192, 168, 123, 10, 10, 10, 1, 0, 192, 168, 1, 2;
    }

El formato de estas opciones es:

    <netmask-network1>, <network1-byte1>, <network1-byte2>, <network1-byte3>, <router1-byte1>, <router1-byte2>, <router1-byte3>, <router1-byte4>[, <netmask-network2>, <network2-byte1>,...]

Donde los bytes con valor 0 se omiten. Se repiten los bloques [máscara,red-destino,router] que sean necesarios. 

Debe incluirse de nuevo la ruta por defecto (default-gw) en estas opciones porque el estándar permite que el cliente-dhcp ignore la _option routers x.x.x.x_.

Así que cada una de las lineas anteriores (rfc3442-... y ms-clas..) contiene la siguiente información de enrutado, separada en cada conjunto [máscara, red-destino, router]:

    24, 192, 168, 123, 10, 10, 10, 1  : 192.168.123.0/24 via 10.10.10.1
     0,               192,168,  1, 2  : 0.0.0.0 via 192.168.1.2 (default route)

Visto en [http://www.j-schmitz.net/blog/pushing-static-routes-with-isc-dhcp-server](http://www.j-schmitz.net/blog/pushing-static-routes-with-isc-dhcp-server)

##mikrotik routerOs

Para RouterOs la situación es similar, pero en vez de tener números decimales separados por comas tenemos números hexadecimales (sin separación)

Así por ejemplo podríamos encontrar la configuración:
    /ip dhcp-server option
    add code=121 name=classless value=0x18A000000A016501000A016501
    /ip dhcp-server network
    set 0 dhcp-option=classless
    
Donde primero se define la opción y después se usa. 

De nuevo el valor también incluye la ruta por defecto. Y deberíamos añadir otra opción con código 259 para clientes Microsoft.

    [admin@MikroTik] /ip route> print
    Flags: X - disabled, A - active, D - dynamic, C - connect, S - static, r - rip, b - bgp, o - ospf,
    m - mme, B - blackhole, U - unreachable, P - prohibit
    #      DST-ADDRESS        PREF-SRC        GATEWAY            DISTANCE
    0 ADS  0.0.0.0/0                          10.1.101.1         0
    1 ADS  160.0.0.0/24                       10.1.101.1         0

0x18A000000A016501000A016501 es, en decimal y separado por comas:
24,160,0,0,10,1,101,1,0,10,1,101,1

Visto en [http://wiki.mikrotik.com/wiki/Manual:IP/DHCP_Server#Example](http://wiki.mikrotik.com/wiki/Manual:IP/DHCP_Server#Example)