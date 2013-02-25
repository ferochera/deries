---
layout: post
title: "Script ddnsupd de nslu2 para solucionar incompetencia de ONO"
date: 2012-07-02 00:36
comments: true
categories:
- Cuaderno-Laboratorio
- mini-servidor
- ONO
---

Mi experiencia con los routers de ONO lleva años siendo mala (sí, ya se... cambia de proveedor!). 

He sufrido con un Scientific Atlanta epr2320 y, recientemente, con un Netgear cg3100d. Y la conclusión es que entiendo los comentarios en internet recomendando usarlos únicamente como modems.

Ya me explayaré sobre el tema. Pero la cuestión es que en los firmwares más recientes han capado las habilidades del router. Por ejemplo ya no son accesibles a través de ssh ni saben manejar dyndns. Y también hay problemas al redireccionar puertos. Vamos una joya de cacharro (o de firmware, que igual el cacharro puede y algunos no lo dejan).

La situación es que necesitaba poner en marcha una actualización de ip dinámica en dyndns. Aunque hay soluciones como dyndns o tinydyndns en los repositorios (ubuntu-debian) he decidido utilizar una opción que ya conocía... así que rescaté un script que usaba en un [nslu2](http://www.nslu-linux.org) y que aquí incluyo:

{% include_code Script de Actualización de IP para dyndns ddnsupd.sh lang:bash %}

El script se ejecuta temporizado desde cron y utiliza archivos temporales localizados en /var/tmp y también escribe un par de archivos de log situados en /var/log

La ventaja que le veo sobre la solución dyndns de los repositorios es que no utiliza un demonio más sino que lo lanza cron. Debe, por tanto, ser un script ejecutable con los permisos adecuados. Quizá como inconveniente tiene que los datos de configuración están en el mismo script (y accesibles).