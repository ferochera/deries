---
layout: post
title: Respaldo de Gmail con getmail
categories: []
permalink: /archives/25-Respaldo-de-Gmail-con-getmail.html
s9y_link: http://xarx.es/deries/archives/25-Respaldo-de-Gmail-con-getmail.html
date: 2008-03-03 19:49:08.000000000 +01:00
---
<br />
<p>Pretendemos hacer una copia de seguridad de los correos de nuestra cuenta de gmail. Para ello utilizaremos la utilidad <a title="GetMail 4" href="http://pyropus.ca/software/getmail/">getmail</a> configurada para almacenar los correos al estilo MailDir.</p><p>Dado que la utilidad está en los repositorios de ubuntu la instalaremos desde allí (sudo aptitude install getmail4).</p><p>Una vez instalada creamos las carpetas donde almacenaremos el correo:</p>

```
$ mkdir ~/.getmail<br />$ mkdir -p ~/GmailBackup/new  ~/GmailBackup/tmp  ~/GmailBackup/cur
```

<p>la carpeta .getmail es la que utiliza el programa por defecto para almacenar los archivos de configuración. Podemos crear el archivo para nuestra cuenta con cualquier editor. Por ejemplo:</p>

```
nano ~/.getmail/getmailrc.mictagmail
```

<p>Y dentro añadiremos algo como lo siguente:</p>

```
[retriever]
type = SimplePOP3SSLRetriever
server = pop.gmail.com
username = micuenta@gmail.com
password = clavedemictagmail

[destination]
type = Maildir
path = ~/GmailBackup/

[options]
verbose = 2
received = false
delivered_to = false
message_log = ~/.getmail/backupgmail.log
```

<p>eso si con los valores adecuados de username y password. Si en vez de maildir queremos que nuestros correos se almacenen en formato mbox deberíamos poner, por ejemplo,</p>

```
[destination]
type = Mboxrd
path = ~/GmailBackup.mbox
```

<p>Finalmente solo faltaría añadir una tarea al cron para que se ejecute repetidamente y sin nuestra atención:</p>

```
# obtener copia local de la cuenta de gmail 
35 22 * * * /usr/bin/getmail -ln --rcfile getmailrc.mictagmail >> ~/respgmail.log
```

La opción -n indica obtener solo el correo nuevo. Además también se puede seguir el manual de getmail para recuperar más de una cuenta y para variar la carpeta en la que buscar los archivos de configuración.<p />
