---
layout: post
title: Desinstalar nucleos antiguos
categories:
- Cuaderno-Laboratorio
permalink: /archives/37-Desinstalar-nucleos-antiguos.html
s9y_link: http://xarx.es/deries/archives/37-Desinstalar-nucleos-antiguos.html
date: 2008-12-03 18:06:47.000000000 +01:00
---
<br />
<p>1-. listar los nucleos que tenemos instalados:</p><blockquote><pre><font size="3">sudo dpkg --get-selections | grep linux-image</font></pre></blockquote><p>2-. eliminar los que no queramos conservar con apt-get o con aptitude:</p><blockquote><pre><font size="3">sudo apt-get remove --purge linux-image-2.6.20-14-generic</font></pre></blockquote><p>con la opción siguiente también se eliminarán los que aunque sin estar instalados no hayamos quitado sus archivos de configuración y que en la lista de dpkg aparecen como &quot;deinstall&quot;:</p><blockquote><pre><font size="3">sudo aptitude purge linux-image-2.6.22-14-generic</font></pre></blockquote><p>En principio con un par de nucleos funcionantes debería ser suficiente.</p><br />
