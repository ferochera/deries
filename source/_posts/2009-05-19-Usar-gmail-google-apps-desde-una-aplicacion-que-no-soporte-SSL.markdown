---
layout: post
title: Usar gmail-google apps desde una aplicación que no soporte SSL
categories:
- Cuaderno-Laboratorio
permalink: /archives/42-Usar-gmail-google-apps-desde-una-aplicacion-que-no-soporte-SSL.html
s9y_link: http://xarx.es/deries/archives/42-Usar-gmail-google-apps-desde-una-aplicacion-que-no-soporte-SSL.html
date: 2009-05-19 18:00:47.000000000 +02:00
---
<br />
<p><b>Planteamiento inicial:</b></p><p>Suponemos que usamos gmail o google apps para nuestro correo electrónico y resulta que queremos utilizarlo desde una aplicación que aunque sea capaz de usar pop3-smtp no soporte conexiones encriptadas como las que necesita la cuenta de google.</p><p><b>Como configurar pop3-smtp en el cliente segun google:</b></p><br />
<p>(<a title="Instrucciones de configuración para clientes pop en google" href="http://mail.google.com/support/bin/answer.py?answer=13287">instrucciones de configuración generales</a>)</p><br />
<ol><li><a href="http://mail.google.com/support/bin/answer.py?answer=13273">Habilita el acceso POP en tu cuenta de Gmail</a>. No olvides hacer clic en <b>Guardar cambios</b> una vez finalizado el proceso.</li><li>Configura tu cliente para que cumpla la siguiente configuración:</li><ul><li><font size="-1"><strong>El servidor de correo entrante (POP3) requiere SSL:</strong></font><font face="Courier New, Courier, mono" size="-1"> pop.gmail.com</font><font size="-1">, <strong>Usar SSL</strong>: Sí, <strong>Puerto</strong>: 995 </font></li><li><font size="-1"></font><font size="-1"><strong>El servidor de correo saliente (SMTP) requiere TLS:</strong></font> <font face="Courier New, Courier, mono" size="-1">smtp.gmail.com</font><font size="-1"> (usar autenticación) , <strong>Usar autenticación</strong>: Sí, <strong>Usar STARTTLS</strong>: Sí (en algunos clientes se denomina SSL), <strong>Puerto</strong>: 465 o 587<br />
</font></li><li><font size="-1"><strong>Nombre de cuenta:  </strong></font><font size="-1">tu nombre de usuario de Gmail (incluido <font face="Courier New, Courier, mono">@gmail.com</font> o midominio.es).</font></li><li><font size="-1"><strong>Dirección de correo electrónico: </strong></font><font size="-1">tu dirección de correo electrónico completa de Gmail (<font face="Courier New, Courier, mono">nombredeusuario@gmail.com</font>) </font></li><li><font size="-1"> </font><font size="-1"><strong>Contraseña: </strong></font><font size="-1">tu contraseña de Gmail/google apps</font> <font size="-1"></font></li></ul></ol><ol><p><br />
Si no estás usando el <a href="http://mail.google.com/support/bin/answer.py?answer=47948">modo reciente</a> para descargar el correo a varios clientes, asegúrate de que hayas optado por no dejar los mensajes en el servidor. La <a href="http://mail.google.com/support/bin/answer.py?answer=13273">Configuración de Gmail</a><br />
determina si tus mensajes permanecen o no en el servidor de modo que<br />
esta configuración en tu cliente no afectará la manera en que Gmail<br />
controle tu correo.<br />
</p><p>Ten en cuenta que si tu cliente no admite la autenticación<br />
SMTP, no podrás enviar mensajes a través del cliente con tu dirección<br />
de Gmail.</p></ol> 

Solución:
----------

Utilizar stunnel para que se encargue de la parte de comunicación encriptada. Stunnel se define en su web como 
> "Stunnel is a program that allows you to encrypt arbitrary TCP connections inside SSL (Secure Sockets Layer) available on both Unix and Windows. 
> Stunnel can allow you to secure non-SSL aware daemons and protocols (like POP, IMAP, LDAP, etc) by having Stunnel provide the encryption, requiring no changes to the daemon's code."

<!--more-->

En este texto voy a utilizarlo en un equipo con el S.O. Microsoft Windows XP profesional por lo que a la hora de bajar e instalar habrá que buscar los ejecutables correspondientes. El objetivo es instalar un servicio "stunnel" que se inicie al arrancar el sistema y que provea una especie de servidor smtp en el puerto local 25 y otro pop3 en el 110 que resulten los extremos del tunel con ya comunicación desencriptada.

1. Bajar el ejecutable de la sección de downloads de la web de stunnel. En el momento de escribir este texto la versión más moderna es la 4.27

2. Instalar stunnel-XX-installer.exe. Este pone el ejecutable, la documentación, las dll y la configuración en la carpeta que le indicamos. Además instala unos accesos directos para arrancar el programa, instalarlo/desinstalarlo como servicio, etc.

3. Antes de instalar el servicio debemos preparar la configuración... Un ejemplo de archivo stunnel.conf es el siguiente:

```
    cert = stunnel.pem
    socket = l:TCP_NODELAY=1
    socket = r:TCP_NODELAY=1
    debug = 7
    output = stunnel.log
    client = yes
    [pop3s]
    accept  = 127.0.0.1:110
    connect = pop.gmail.com:995
    [smtps]
    accept  = 127.0.0.1:25
    connect = smtp.gmail.com:465
```

El certificado es uno de ejemplo que viene con la instalación. Para más información revisar la documentación y en concreto este enlace.

Configurar el cliente (ej. thunderbird):

```
    Servidor pop3: 127.0.0.1, puerto 110
    Servidor smtp: 127.0.0.1, puerto 25
    Usuario: el usuario completo de gmail/google apps
    Password: la de gmail/google apps
```

Es necesario asegurarse de que el cliente se autentifica también cuando trata de enviar (smtp)

Para hacer una prueba podemos utilizar un programa como por ejemplo thunderbird u otro que tengamos ya instalado y probar a enviar y recibir emails.

