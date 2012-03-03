---
layout: post
title: Renombrar muchos archivos desde linea de comandos
categories:
- Cuaderno-Laboratorio
permalink: /archives/35-Renombrar-muchos-archivos-desde-linea-de-comandos.html
s9y_link: http://xarx.es/deries/archives/35-Renombrar-muchos-archivos-desde-linea-de-comandos.html
date: 2008-10-31 13:35:31.000000000 +01:00
---
La sintaxis de rename:

```
rename [ -v ] [ -n ] [ -f ] perlexpr [ files ]
```

donde -v indica modo 'verboso', -n indica no-action (no se ejecuta el renombramiento), y -f indica forzar el cambio.

En la expresión de perl lo habitual es 's/viejo/nuevo' que indica que hay que sustituir (s) el texto 'viejo'  por el texto 'nuevo'.

**Ejemplos:**

* Cambiar parte del nombre:

```
rename -v 's/IMG_/\foto_/' *;.jpg
```

* Cambiar la extensión:

```
rename -v 's/\.htm$/\.html/' *.htm
```

Cambiará los archivos con extensión htm y les pondrá html. 

Dado que '.' significa cualquier carácter en una expresión normal habrá que &quot;escaparlo&quot; para ello usamos '\.' ya que queremos que coincida con el punto de la extensión. El símbolo '$' indica fin de nombre/cadena. Esto hará que se cambie el nombre para archivos &#42;.htm pero no para otros que tengan algo más detras de la 'm', por ejemplo &#42;.htms

* Incluir texto:

```
rename -v 's/\.jpg$/_mini\.jpg/' *.jpg
```

Si queremos hacer explicito que se trata de miniaturas (thumbnails) podemos añadir a cada una el texto _mini justo delante de la extensión.

**Más información:**

* man rename
* <a href="http://jupabeans.blogspot.com/2007/04/renombrar-archivos-con-rename-linux.html">Renombrar archivos con rename (Linux)</a>
* <a href="http://tips.webdesign10.com/how-to-bulk-rename-files-in-linux-in-the-terminal">How to Bulk Rename Files in Linux (Terminal or GUI)</a>

