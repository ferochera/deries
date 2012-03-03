---
layout: post
title: Instalar y utilizar el simulador de red CNET
categories:
- Cuaderno-Laboratorio
permalink: /archives/18-Instalar-y-utilizar-el-simulador-de-red-CNET.html
s9y_link: http://xarx.es/deries/archives/18-Instalar-y-utilizar-el-simulador-de-red-CNET.html
date: 2008-01-15 16:17:26.000000000 +01:00
---
<br />
Ejemplo: Instalación en Ubuntu 7.10<br />
<blockquote><br />
<pre>1-. Descargar y extraer las fuentes de CNET (versión 2.0.10)<br /><br />2-. Verificar que las bibliotecas tcl y tk están instaladas (y si no instalarlas) con <br />     sudo apt-get install tcl8.4 tcl8.4-dev tk8.4 tk8.4-dev<br /><br />3-. Modificar las fuentes como se indica abajo (en el procedimiento detallado)<br /><br />4-. Cambiar cnetheader.h para que los includes apunten donde toca <br />     tcl.h --&gt; tcl8.4/tcl.h; tk.h --&gt; tcl8.4/tk.h<br /><br />5-. make; make install (con los permisos adecuados)<br /><br />6-. hacer los exports</pre></blockquote><br />
Procedimiento detallado ...<br />
 <br /><a href="http://xarx.es/deries/archives/18-Instalar-y-utilizar-el-simulador-de-red-CNET.html#extended">Continua leyendo "Instalar y utilizar el simulador de red CNET"</a>
