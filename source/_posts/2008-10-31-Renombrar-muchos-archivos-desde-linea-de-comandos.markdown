---
layout: post
title: Renombrar muchos archivos desde linea de comandos
categories:
- Cuaderno-Laboratorio
permalink: /archives/35-Renombrar-muchos-archivos-desde-linea-de-comandos.html
s9y_link: http://xarx.es/deries/archives/35-Renombrar-muchos-archivos-desde-linea-de-comandos.html
date: 2008-10-31 13:35:31.000000000 +01:00
---
<br />
<div align="justify">La sintaxis de rename:<br /><blockquote>rename [ -v ] [ -n ] [ -f ] perlexpr [ files ]</blockquote></div><p /><div align="justify">donde -v indica modo 'verboso', -n indica no-action (no se ejecuta el renombramiento), y -f indica forzar el cambio.</div><p /><p /><div align="justify">En la expresión de perl lo habitual es 's/viejo/nuevo' que indica que hay que sustituir (s) el texto 'viejo'  por el texto 'nuevo'.</div><p /><p /><div align="left">Ejemplos:</div><p /><ul><li>Cambiar parte del nombre:</li></ul><blockquote>rename -v 's/IMG_/\foto_/' &#42;.jpg</blockquote><div align="left"><ul><li>Cambiar la extensión:</li></ul><blockquote>rename -v 's/\.htm$/\.html/' &#42;.htm</blockquote></div><p /><div align="justify">Cambiará los archivos con extensión htm y les pondrá html. Dado que '.' significa cualquier carácter en una expresión normal habrá que &quot;escaparlo&quot; para ello usamos '\.' ya que queremos que coincida con el punto de la extensión. El símbolo '$' indica fin de nombre/cadena. Esto hará que se cambie el nombre para archivos &#42;.htm pero no para otros que tengan algo más detras de la 'm', por ejemplo &#42;.htms</div><p /><ul><li>Incluir texto:</li></ul><blockquote>rename -v 's/\.jpg$/_mini\.jpg/' &#42;.jpg</blockquote><p /><div align="justify">Si queremos hacer explicito que se trata de miniaturas (thumbnails) podemos a?adir a cada una el texto _mini justo delante de la extensión.</div><p /><p /><p>Más información:</p><ul><li>man rename</li><li><a href="http://jupabeans.blogspot.com/2007/04/renombrar-archivos-con-rename-linux.html">Renombrar archivos con rename (Linux)</a></li><li><a href="http://tips.webdesign10.com/how-to-bulk-rename-files-in-linux-in-the-terminal">How to Bulk Rename Files in Linux (Terminal or GUI)</a></li></ul><br />
