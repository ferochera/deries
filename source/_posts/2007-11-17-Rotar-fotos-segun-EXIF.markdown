---
layout: post
title: Rotar fotos según EXIF
categories:
- Programillas
permalink: /archives/15-Rotar-fotos-segun-EXIF.html
s9y_link: http://xarx.es/deries/archives/15-Rotar-fotos-segun-EXIF.html
date: 2007-11-17 16:04:18.000000000 +01:00
---
<br />
La mayoría de las cámaras compactas digitales actuales, y en concreto la mía, una Canon IXUS 60, almacenan información de la orientación en su información <a href="http://es.wikipedia.org/wiki/Exif" target="_blank" title="Exif en la wikipedia">EXIF</a>.<p>Si a eso le juntamos que a muchos nos interesa subir las imágenes de una cámara a algúna galería en internet llegamos al momento de pensar como podemos automatizar el enderezado (giro de la imagen adecuado) para que todas se vean bien.</p> 

<!--more-->
Buscando por la web he encontrado la página Pilpi.net donde se ofrece esta herramienta al "mundo".

La idea es incluir como menú contextual del explorador de archivos (Windows) o de konqueror (linux-kde) una entrada que rote las imágenes automáticamente. Está basado en el uso de las bibliotecas de funciones jhead y jpegtran y en la aplicación image-magick

Desde [pilpi.net](http://pilpi.net) se puede bajar la versión para MS Windows de auto-rotate.

Para Kde, una vez tengamos instalado jhead y jpegtran (_apt-get install jhead exiftran_ y sus paquetes asociados si los hay) podemos hacer que aparezcan con 3 enlaces en la carpeta adecuada (_~/.kde/share/apps/konqueror/servicemenus/_) en la que se describen las acciones. También podemos bajarnos desde pilpi.net un zip que ya contiene los archivos .desktop y los descomprime en el lugar adecuado si partimos de nuestra carpeta de usuario ~:

**1.** Rotar automáticamente un archivo. Crear el enlace _"jpeg-exif_autorotate.desktop"_ que contenga lo siguiente...

    [Desktop Entry]
    Encoding=UTF-8
    ServiceTypes=image/jpeg
    Actions=JPEG-EXIF_autorotate

    [Desktop Action JPEG-EXIF_autorotate]
    Name=Auto-rota la imagen
    Exec=jhead -autorot %f
    Icon=kfm

**2.** Rotar automáticamente todos los archivos de una carpeta. Crear el enlace _"jpeg-exif_autorotatedir.desktop"_ conteniendo...

    [Desktop Entry]
    Encoding=UTF-8
    ServiceTypes=inode/directory
    Actions=JPEG-EXIF_autorotatedir

    [Desktop Action JPEG-EXIF_autorotatedir]
    Name=Auto-rota los archivos de la carpeta
    Exec=jhead -autorot %f/*
    Icon=kfm


**3.** Rotar automáticamente todos los archivos de una carpeta y sus subcarpetas de un modo recursivo. Crear el enlace _"jpeg-exif_autorotatedir_recursive.desktop"_ conteniendo...

    [Desktop Entry]
    Encoding=UTF-8
    ServiceTypes=inode/directory
    Actions=JPEG-EXIF_autorotatedir_recursive

    [Desktop Action JPEG-EXIF_autorotatedir_recursive]
    Name=Auto-rota los archivos de la carpeta y sus subcarpetas
    Exec=find %f -iname "*.jpeg" -type f -exec /home/a/jhead/jhead -autorot {} \;
    Exec=find %f -iname "*.jpg" -type f -exec /home/a/jhead/jhead -autorot {} \;
    Icon=kfm

Podemos cambiar el texto que aparece en konqueror variando el atributo Name de los archivos anteriores.

Esto puede hacerse con algunas otras acciones (girar independientemente del exif, por ejemplo para cámaras más antiguas) o redimensionados a valores concretos (ej 1200x900, 1500x1125,..), con o sin copia, utilizando imagemagick. O preparar una acción que redimensiones y luego autorote dejando las imágenes preparadas para subirlas.

