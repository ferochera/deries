---
layout: post
title: Mover sitios web entre servidores con ISPConfig
categories:
- mini-servidor
permalink: /archives/21-Mover-sitios-web-entre-servidores-con-ISPConfig.html
s9y_link: http://xarx.es/deries/archives/21-Mover-sitios-web-entre-servidores-con-ISPConfig.html
date: 2008-02-12 19:31:33.000000000 +01:00
---

<p>Esta entrada es básicamente la traducción de la <a href="http://www.howtoforge.com/forums/showthread.php?t=2717" title="Forum Howtoforge: Moving ISPconfig">entrada del forum en Howtoforge.com</a> donde falko lo explica...</p>
<p>Partimos de un servidor en &quot;producción&quot; y otro limpio (desde ispconfig.org se puede acceder a las guías de instalación).</p>

**1.** Crear una copia de los archivos:

        /etc/passwd, /etc/shadow, /etc/group, 
        Vhosts_ispconfig.conf (situado /etc/apache2/vhosts para debian, ubuntu,...), 
        /etc/postfix/local-host-names, /etc/postfix/virtusertable, 
        named.conf y todos los archivos de zona pri.* (¿situados en /etc/bind9/?) y 
        los archivos /etc/proftpd/proftpd*.conf

**2.** Crear una copia de seguridad de las bases de datos. Se puede usar phpMyAdmin si está disponible o si no se puede usar mysqldump desde la consola:</p>

```
mysqldump -h localhost -u usuario -pcontraseñadeeseusuario -c --add-drop-table --add-locks --all --quick --lock-tables --databases db1 db2 db3 > sqldump.sql
```

Donde debe observarse que entre -p y la contraseña no hay espacio (si no se pone nada la aplicación la pregunta), que el usuario debe tener suficientes permisos (lo normal es usar el usuario root de acceso al mysql), que si solo se quiere volcar una base de datos se puede quitar --databases y poner solo el nombre de la base de datos deseada.

**3.** crear una copia de la carpeta raíz del servidor web (ej /var/www para ubuntu) **conservando los propietarios y los permisos**. Para ello se usa la opción -p con tar:

```
cd /var; tar -pcjvf www.tar.bz2 www/
```

**4.** Si los buzones de correos están en formato mbox habría que parar postfixy copiar los buzones. Si se usa Maildir los buzones están incluidos en el www.tar.bz2.

**5.** En el servidor de destino recuperar las bases de datos desde los volcados del servidor original con phpMyAdmin o desde la consola:

```
mysql -h localhost -u usuario -pcontraseña nombredeladb < sqldump.sql
```

**6.** Revisar los usuarios y permisos para uso de mysql. Incluir los usuarios y permisos en el servidor de destino que hubiese en el de origen.

**7.** Copiar local-host-names y virtusertable a /etc/postfix. Abrir local-host-names y reemplazar el viejo hostname por el nuevo. Ejecutar:

```
postmap /etc/postfix/virtusertable
```

    Reiniciar postfix (ej /etc/init.d/postfix restart desde ubuntu)

**8.** Reemplazar el Vhosts_ispconfig.conf del servidor destino por el que hemos obtenido del servidor de origen.

**9.** Transferir y descomprimir en el lugar adecuado (ej que quede en /var/www) www.tar.bz2 (en este caso no tengo claro si es necesario usar la opción -p con tar)

**10.** Si usasemos mailbox este sería el momento de descomprimirlo en su destino.

**11.** Alterar /etc/passwd, /etc/shadow y /etc/group comparando el del servidor de origen y el de destino. Añadir en el de destino los usuarios, grupos, etc adecuados (los que no existan en el destino y estén relacionados con los sitios a transportar)

**12.** Transferir la configuración de dns (named.conf y pri*). Transferir la configuración de proftp (proftpd*.conf). Revisar las configuraciones anteriores para cambiar la IP de la de origen a la de destino.

**14.** Reiniciar proftpd y apache:

```
/etc/init.d/proftpd restart
/etc/init.d/apache2 restart
```

**15.** Aunque Falko no lo dice creo que sería buena idea reiniciar también ispconfig

**16.** Entrar a la interfaz de administración de ispconfig en el servidor destino y cambiar la/s IP/s del servidor (de las del origen a las del destino). Ir a la gestión de DNS y revisar también las IPs de los registros dns por si fuera necesario cambiarlas.

**17.** Solo faltará que el correo se redirija desde el servidor origen al destino mientras se actualizan los valores en los registros MX. Para ello sobre el servidor original hacemos:

```
echo "* smtp:[<IP del servidor destino>]" >> /etc/postfix/transport
postmap /etc/postfix/transport
/etc/init.d/postfix restart
```

En el servidor destino faltará añadir la dirección del servidor de origen al final del /etc/postfix/local-host-names para que el servidor de destino acepte los correos que le envíe el de origen.

Con esto y un bizcocho la cosa debería funcionar

Actualizaciones y Comentarios previos
--------------------------------------

**Comentario 1**

Un par de comentarios respecto al proceso:

1. El paso 17 lo hice a medias (no incluí la dirección del viejo en el nuevo). Espero no haber perdido correos debido a la hora que era y a que los dns cambiaran rapidito :-O

2. Al problema de mover los sitios se me juntó que en una actualización reciente había cambiado la versión de php (un cambio menor). Esto hizo que eAccelerator se quejara y no arrancara php. _Solución_: Recompilar para la versión actual de php (Un consejo, hacer _make test_ después del _make install_ de eAccelerator, que si se hace sin el _make install_ usa la versión previa y sigue quejándose) 

