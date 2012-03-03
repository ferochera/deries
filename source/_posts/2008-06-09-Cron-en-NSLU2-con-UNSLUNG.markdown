---
layout: post
title: Cron en NSLU2 con UNSLUNG
categories: []
permalink: /archives/28-Cron-en-NSLU2-con-UNSLUNG.html
s9y_link: http://xarx.es/deries/archives/28-Cron-en-NSLU2-con-UNSLUNG.html
date: 2008-06-09 18:36:07.000000000 +02:00
---
<p>Inicialmente existe un servicio de temporización derivado de la funcionalidad inicial de Linksys. El ejecutable está en <i>/usr/sbin/crond.</i></p><p>En los foros dedicados al tema (ver www.nslu2-linux.org) se recomienda instalar un segundo cron para otros funcionamientos.</p><p>Dado que me interesaba tener actualizado una dirección de dyndns instalé este segundo. Queda situado dentro de opt (<i>/opt/sbin/cron</i>)<br /> </p><p>Dada esta situación y con los 2 en marcha si utilizamos crontab modificamos el primero. Para utilizar el nuevo debemos incluir un nuevo archivo en /opt/etc/cron.d/ con la configuración. Es importante incluir el usuario que ha de ejecutar el comando temporizado... en el ejemplo se trata de root.</p><blockquote>bash-3.2# cat dyndnsupd<br /># Set the interval of the next IP check using a crontab entry.<br /># Once every 15 minutes is good for a home server.<br />*/15 <strong> </strong> <strong> </strong> root /opt/bin/dyndnsupdate.sh &amp;&gt;/dev/null</blockquote><p>Enlaces interantes:</p><ul><li><a href="http://www.nslu2-linux.org/" title="NSLU2-LINUX">NSLU2-LINUX</a><i></i></li></ul>
