---
layout: post
title: Ejecutar aplicaciones X como root en un display de usuario
categories:
- Cuaderno-Laboratorio
permalink: /archives/38-Ejecutar-aplicaciones-X-como-root-en-un-display-de-usuario.html
s9y_link: http://xarx.es/deries/archives/38-Ejecutar-aplicaciones-X-como-root-en-un-display-de-usuario.html
date: 2009-04-30 19:52:30.000000000 +02:00
---
<br />
( Basado en <a href="http://www.bulma.net/body.phtml?nIdNoticia=1038" title="Ejecutar aplicaciones X como root en un display de usuario">http://www.bulma.net/body.phtml?nIdNoticia=1038</a> )<p>Ejemplo de inicio de una aplicación gráfica (xterm) desde la linea de comandos de root. En principio serviría igual con cualquier otro usuario.</p>

```
$ xhost LOCAL:
$ sudo su -
 Password: **********
# export DISPLAY=:0.0
# xterm &amp;
```
