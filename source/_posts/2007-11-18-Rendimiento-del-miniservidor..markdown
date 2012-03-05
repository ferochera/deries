---
layout: post
title: Rendimiento del miniservidor.
categories:
- Cuaderno-Laboratorio
- mini-servidor
permalink: /archives/16-Rendimiento-del-miniservidor..html
s9y_link: http://xarx.es/deries/archives/16-Rendimiento-del-miniservidor..html
date: 2007-11-18 20:42:23.000000000 +01:00
---
<br />
<p>La idea es realizar test sobre una de las webs del miniservidor para comprobar como trabaja y si podemos optimizar algo. Aunque también trataré de aplicarlo a <a href="http://llig.es/" target="_blank" title="Ler Llibreries - Llibres i Gr&agrave;cia">llig.es</a>, que actualmente sirve un PII con menor ram y cpu que el miniservidor.</p><p>Como premisa inicial disponemos del servidor (del hardware ya hablamos en la primera entrada de este tema/categoría) con ubuntu 7.10, ISPconfig y una web habilitada con Joomla recien instalado y vacío. Como documentación contamos especialmente con las charlas sobre php: <a target="_blank" href="http://talks.php.net/">talks.php.net</a></p><p>Para realizar las pruebas utilizamos ab (<a href="http://httpd.apache.org/docs/2.2/programs/ab.html" target="_blank" title="ab de apache">apachebench</a>, que está incluida en apache) o <a href="http://www.joedog.org/JoeDog/Siege" target="_blank" title="homepage de siege">siege</a>. Son similares pero siege puede además simular diferentes clientes. Para más datos se pueden  visitar las páginas de estas aplicaciones o de <a href="http://www.apache-es.org/index.php/2006/12/26/herramientas-de-pruebas-de-carga/" target="_blank" title="herramientas de test de rendimiento para apache">otras alternativas</a>.</p><p>Lo que tratamos de hacer es mejorar la configuración sin modificar el código de joomla o el cms que sea de modo que mejoremos en todos los clientes del isp. Decir sin embargo que este equipo deberá tener uno o dos webs únicamente.</p>

<!--more-->
**Prueba 1, resultados de ab:**

    Total transferred: 508144 bytes
    HTML transferred: 483896 bytes
    Requests per second: 0.45 [#/sec] (mean)
    Time per request: 6667.406 [ms] (mean)
    Time per request: 2222.469 [ms] (mean, across all concurrent requests)
    Transfer rate: 4.13 [Kbytes/sec] received

**Prueba 2, tras habilitar la compresión gzip y la cache de Joomla**

    Total transferred: 156936 bytes
    HTML transferred: 131801 bytes
    Requests per second: 0.45 [#/sec] (mean)
    Time per request: 6677.524 [ms] (mean)
    Time per request: 2225.841 [ms] (mean, across all concurrent requests)
    Transfer rate: 1.27 [Kbytes/sec] received

Como se ve no aumentamos el número de peticiones atendidas por segundo. Solo reducimos la cantidad de datos transferidos gracias a la compresión gzip.

Instalamos eAccelerator para intentar que esto aumente. Para ello seguimos otro de los manuales de howtoforge.com. En concreto el titulado "Integrating eAccelerator Into PHP5 (Debian Etch)" del que espero que resulte adecuado para Ubuntu. Podemos comprobar si eAccelerator está instalado viendo la versión de php:

    $ php -v
    PHP 5.2.3-1ubuntu6 (cli) (built: Oct 4 2007 23:35:54)
    Copyright (c) 1997-2007 The PHP Group
    Zend Engine v2.2.0, Copyright (c) 1998-2007 Zend Technologies
    with eAccelerator v0.9.5.2, Copyright (c) 2004-2006 eAccelerator, by eAccelerator


**Prueba 3, tras instalar eAccelerator** (bajar, compilar, instalar y configurar /etc/php5/conf.d/eaccelerator.ini cambiando el uso de shared memory de 16 a 32Mb). Ahora mostramos los resultados obtenidos con siege:

    $ siege -r 25 -b -c3 -H 'Accept-Encoding: gzip' http://web.a.probar/

    Transactions: 75 hits
    Availability: 100.00 %
    Elapsed time: 123.05 secs
    Data transferred: 0.18 MB
    Response time: 4.47 secs
    Transaction rate: 0.61 trans/sec
    Throughput: 0.00 MB/sec
    Concurrency: 2.73
    Successful transactions: 75
    Failed transactions: 0
    Longest transaction: 20.68
    Shortest transaction: 1.57

Análisis del resultado: hemos subido a 0.15 transacciones por segundo. Algo hemos hecho. De todas formas también podemos ver que el tiempo de respuesta es de casi cinco segundos.

La siguiente opción es intentar que las cachés se almacenen en memoria, en un tmpfs de modo que sea mucho más rápido acceder a ellas. Esto ya lo hace eAccelerator al usar shm por lo que no tiene sentido intentar otra cosa.

Podemos deshabilitar pues la caché de joomla para que sea eAccelerator quien se encarge. Realmente conseguimos poco. Solo reducir algo los tiempos de respuesta. La compresión gzip solo afecta a la cantidad de datos transferida y no a la de respuesta o a las transacciones por segundo. Los resultados obtenidos son los siguientes:

    Transactions: 75 hits
    Availability: 100.00 %
    Elapsed time: 119.59 secs
    Data transferred: 0.18 MB
    Response time: 4.19 secs
    Transaction rate: 0.63 trans/sec
    Throughput: 0.00 MB/sec
    Concurrency: 2.63
    Successful transactions: 75
    Failed transactions: 0
    Longest transaction: 23.50
    Shortest transaction: 1.58

Por este lado no veo mayor avance posible sin entrar en la implementación en php. Quizá el siguiente paso podría ser intentar mejorar el acceso a la base de datos. Pero esto lo dejaremos de momento.

Al instalar algunos componentes en joomla (joomfish, para site multilenguage castellano-catalán, ZMG, para la galería, joomlexplorer,...) el rendimiento ha bajado casi al nivel inicial. Eso significa que cuanto más cargamos de php más lento. Quizá en máquinas con más potencia de cálculo no sea escesivamente importante pero aquí si que lo es.

Para 'acelerar' la página de entrada almenos hago que sea estática (uso wget desde el servidor para bajarla y guardarla como index.html, y lo repito habitualmente con cron para las actualizaciones)... esto hace que se parezca más a BarraPan que a una web dinámica.

Habrá que pensar en si merece la pena o no hacer una web totalmente/principalmente estática.

Actualizaciones y Comentarios previos
--------------------------------------

**Comentario 1**

¿es que no hay nadie que use mod_caché con joomla? todo el mundo dispone de un maquinon para servir webs dinámicas? Tras buscar no he encontrado más que referencias a los manuales de los módulos y alguna combinación junto a mod_expires. OJO: también he descubierto que joomla envía una expiración fija de 1997 con lo que pasamos a tener que tocar el código (en concreto el index.php principal).

**Comentario 2**

Información sobre caches usando los documentos de error:

* Enlace 1 : [Blog hablando del tema](http://www.phpbsd.net/2007/05/16/cache-de-paginas-estaticas-para-php/)

* Enlace 2 : [Charla](http://www.lerdorf.com/tips.pdf) (más en [talks.php.net](http://talks.php.net)) del año 2002 sobre el mismo tema.

* Enlace 3 : [Clase para el mismo objetivo.](http://cesarodas.com/2007/06/gcache_helping_php_to_work_faster.html)

**Comentario 3**

Para WordPress existen cachés similares a lo que yo busco por ejemplo WP-Cache (de R. Galli) y sus derivados.

Para Joomla hay algunas opciones de pago y también está PageCache. Habrá que experimentar con ello.

Para que pagecache se integre con eaccelerator hemos de cambiar de:

     $ ./configure

a:

     $./configure --with-eaccelerator-shared-memory

mientras seguimos el howto de como instalar eaccelerator

**Comentario 4** 

Gracias por el pequeño análisis!

Yo también tengo un servidor y, buscando información sobre el rendimiento de GZIP, me he encontrado con esta web.

Saludos desde Barcelona!
Roc

