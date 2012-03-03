---
layout: post
title: Apagar Linux desde Windows
categories:
- Cuaderno-Laboratorio
- mini-servidor
permalink: /archives/29-Apagar-Linux-desde-Windows.html
s9y_link: http://xarx.es/deries/archives/29-Apagar-Linux-desde-Windows.html
date: 2008-09-03 11:57:10.000000000 +02:00
---

<br />
<div align="justify">Por cuestiones que no vienen al caso necesito permitir que un usuario apague el servidor de un modo simple y sin requerirle mayor información.</div><div align="justify"></div><div align="justify"></div><br /><div align="justify"></div><div align="justify">Para prepararlo crearé un usuario que permita apagar el equipo via ssh con par de claves publica-privada y prepararé un mini-script que muestre un dialogo de confirmación...</div><div align="justify"></div><div align="justify"></div><div align="justify"></div><br /><div align="justify">Para el funcionamiento se requiere que PuTTY esté instalado (realmente solo necesitamos puttygen para la creación de las claves pública y privada y plink para ejecución del comando <i>shutdown</i>)</div><div align="justify"></div><div align="justify"></div><div align="justify"></div> <br />

<!--more-->

1-. Crear el usuario en el equipo a apagar. Suponemos que se trata de un Ubuntu (en otros sabores habrá que retirar el sudo y ejecutar los comandos como root). Preparamos el usuario para que pueda ejecutar el shutdown sin password.

```
    $ sudo groupadd apagador
    $ sudo useradd -d /home/apagador -g users -G apagador -m -s /bin/bash apagador
    $ sudo passwd apagador
    New UNIX password: <password>
    Retype new UNIX password: <password>
    passwd: password updated successfully
    $ sudo visudo

    # Incluimos permiso para que 'apagador' pueda ejecutar shutdown sin password ALL
    apagador ALL = NOPASSWD: /sbin/shutdown
```

2-. Creamos las claves. Para ello hacemos uso de PuTTYGen. En él seleccionamos una clave de 1024 bits del tipo SSH-2 DSA. Tras esto pulsamos el botón de generarla ("Generate").

{% img center /images/puttygen01.jpg 'PuTTYGen' 'Generando las claves con PuTTYGen' %}

Mientras se crea debemos mover el puntero del ratón sobre la zona vacía del programa para aumentar la aleatoriedad de la clave. Tras esto tendremos el par de claves, publica y privada, creadas. Debemos copiar la clave pública al portapapeles desde la ventana donde nos aparece ya preparada para incluirla en el archivo de "authorized_keys" del usuario.

{% img center /images/puttygen03.jpg 'Clave pública' 'Clave pública para copiar y pegar' %}

Una vez hecho esto guardaremos las claves pública y la privada en ficheros, uno para cada una, de modo que plink pueda usar la clave privada (y el cliente la pública a través de su authorized_keys). Para que no nos pida el password de acceso a la clave privada debemos dejar el campo vacío al guardarla.

{% img center /images/puttygen04.jpg 'Passwords' '(No) Asignar contraseñas a las claves con PuTTYGen' %}

Guardamos las dos claves en un lugar acesible en el equipo windows utilizando los botones "Save public key" y "Save private key". Para la privada se sugiere la extensión ppk

{% img center /images/puttygen05.jpg 'PuTTYGen' 'Almacenar las claves en archivo' %}

3-. Incluir la clave pública generada en el authorized_keys del usuario apagador. Para ello podemos usar PuTTY desde el equipo windows. Vamos a editar /home/apagador/.ssh/authorized_keys. Debemos incluir lo que hemos copiado en el apartado 2, tras la creación de la clave. Incluimos como opción que el comando a ejecutar es shutdown y opcionalmente la ip del equipo windows. En la misma linea pegamos la clave pública ("ssh-dss AAAAB3...")

```
    <login como apagador>
    $ cd .ssh (<-- si no existe crearlo con "mkdir .ssh")
    $ nano authorized_keys
    from=”10.0.3.2″,command=”sudo /sbin/shutdown -h -P now” ssh-dss AAAAB3...
```

4-. Ejecutando

```
    plink -T apagador@equipolinux_o_ip -i claveprivada.ppk sudo /sbin/shutdown -h -P now
```

ya debería funcionar (quizá faltara solo las rutas absolutas a plink y claveprivada.ppk). Pero para completar el tema vamos a utilizar un
script vbs que antes de ejecutar el comando mostrará un msgbox de confirmación:

{% include_code Script de Apagado Remoto apagarEquipoLinux.vbs lang:vbnet %}

Solo faltará guardarlo en un archivo de extension vbs (ej apagarEquipoLinux.vbs) y podemos crear un acceso directo a él y colocarlo donde más convenga, el escritorio por ejemplo.

Actualizaciones y Comentarios previos
--------------------------------------

**Comentario 1 (Fabio Rojas)**

Muy bien; excelente.

Lo malo es que cuando yo ejecuto el script desde cualquier máquina: primero, no me genera el mensaje de:

> The server's host key is not cached in the registry. You have no guarantee that the server is the computer you think it is.

> The server's rsa2 key fingerprint is:

> ssh-rsa 2048 76:09:c0:c2:fe:4b:52:30:04:e4:91:47:2f:d3:16:8a

> If you trust this host, enter "y" to add the key to PuTTY's cache and carry on connecting.

> If you want to carry on connecting just once, without adding the key to the cache, enter "n".

> If you do not trust this host, press Return to abandon the connection.

> Store key in cache? (y/n)

Y por supuesto, no puede proseguir y menos ejecutar el comando en el lado del servidor Linux.

Segundo; el ssh key password less, tengo entendido que es para conexión host to host. Yo lo necesito para que funcione desde cualquier máquina Windows.

¿Hay solución para lo primero; por ejemplo mediante algún parámetro u opción de plink que envíe el "yes" o "y" para aceptar la llave ssh-rsa del servidor Linux e ingresarla a la caché de putty en el computador Windows?

Y en lo segundo, ¿es posible dejar la llave pública para conectarse desde cualquier host o PC Windows?

Un abrazo y de antemano gracias por su respuesta.

**Respuesta**

Tienes razón, también habrá que hacer que putty reconozca al servidor como aceptable. Esto deberías hacerlo la primera vez que te conectas a ese servidor.

En cuanto a lo de usar un par de claves (pública+privada) para la identificación de más máquinas no podré serte de mucha ayuda pero me da la impresión (sin documentarme más) que dado que las claves autorizadas están ligadas a una ip supongo que es posible que te diera problemas (lo mejor sería experimentar probándolo).

Si te funciona quizá lo peor es que en el authorized_keys de tu equipo a apagar debería haber una línea por cada uno de los equipos desde los que quieres apagar.

Es probable que existan soluciones mejores. Pero a mi no se me ocurren.

Saludos 

