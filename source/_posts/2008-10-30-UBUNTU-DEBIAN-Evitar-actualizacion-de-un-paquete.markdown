---
layout: post
title: ! 'UBUNTU - DEBIAN: Evitar actualización de un paquete'
categories:
- Cuaderno-Laboratorio
permalink: /archives/34-UBUNTU-DEBIAN-Evitar-actualizacion-de-un-paquete.html
s9y_link: http://xarx.es/deries/archives/34-UBUNTU-DEBIAN-Evitar-actualizacion-de-un-paquete.html
date: 2008-10-30 13:38:40.000000000 +01:00
---
<br />
<p>La cuestión es garantizar que la distribución no actualice un paquete determinado (quizá si que lo haga en el caso de una actualización de versión. Aunque la idea es ir de versión LTS a LTS (Ubuntu) con lo que por lo menos habrá una temporada sin cambios.</p><p>Para el ejemplo se usa el paquete tnftp, que es un cliente de ftp procendente de BSD que se utiliza para actualizaciones a través de ftp con <a href="http://www.wviewweather.com/" title="Software para uso con estaciones meteorológicas">wview</a>.</p><h3>Retención con aptitude:</h3><br />

```
$ sudo aptitude hold tnftp
```

**Verificación:**

```
$ aptitude search tnftp
ih  tnftp  - The enhanced ftp client
```

<p>donde la 'i' indica instalado y la 'h' indica que está retenido (hold).</p><p><b>Problema:</b> la retención con aptitude no implica la retención con apt-get o dpkg<br />
</p><p><b>Solución:</b> retener también con dpkg. Esto tiene efecto también con apt-get<br />
<br />
</p><h3>Retención con dpkg:<br />
</h3>

```
$ echo 'tnftp hold' | sudo dpkg --set-selections
```

<p><b>Verificación:</b><br />
</p>

```
$ sudo dpkg --get-selections | grep tnftp
tnftp  hold
```

