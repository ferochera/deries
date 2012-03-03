---
layout: post
title: Concatenar pdf o ps con gs
categories:
- Cuaderno-Laboratorio
permalink: /archives/33-Concatenar-pdf-o-ps-con-gs.html
s9y_link: http://xarx.es/deries/archives/33-Concatenar-pdf-o-ps-con-gs.html
date: 2008-10-28 12:41:33.000000000 +01:00
---
<br />
<p>Si tenemos ghostscript instalado, cosa bastante habitual, podemos concatenar <b>ps</b> o <b>pdf</b> facilmente y sin herramientas añadidas...</p><p>Concatenando 3 pdf en resultado.pdf:</p><pre>gs -q -dNOPAUSE -dBATCH -sDEVICE=pdfwrite -sOutputFile=resultado.pdf 1er.pdf 2o.pdf 3r.pdf</pre><p>Concatenando 3 ps en resultado.ps:</p><br />
<pre>gs -q -dNOPAUSE -dBATCH -sDEVICE=pswrite -sOutputFile=resultado.ps 1er.ps 2o.ps 3r.ps</pre><p /><p>Información obtenida de: <a href="http://www.linuca.org/body.phtml?nIdNoticia=343">http://www.linuca.org/body.phtml?nIdNoticia=343</a></p><p />
