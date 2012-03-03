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
<p>La idea es realizar test sobre una de las webs del miniservidor para comprobar como trabaja y si podemos optimizar algo. Aunque también trataré de aplicarlo a <a href="http://llig.es/" target="_blank" title="Ler Llibreries - Llibres i Gr&agrave;cia">llig.es</a>, que actualmente sirve un PII con menor ram y cpu que el miniservidor.</p><p>Como premisa inicial disponemos del servidor (del hardware ya hablamos en la primera entrada de este tema/categoría) con ubuntu 7.10, ISPconfig y una web habilitada con Joomla recien instalado y vacío. Como documentación contamos especialmente con las charlas sobre php: <a target="_blank" href="http://talks.php.net/">talks.php.net</a></p><p>Para realizar las pruebas utilizamos ab (<a href="http://httpd.apache.org/docs/2.2/programs/ab.html" target="_blank" title="ab de apache">apachebench</a>, que está incluida en apache) o <a href="http://www.joedog.org/JoeDog/Siege" target="_blank" title="homepage de siege">siege</a>. Son similares pero siege puede además simular diferentes clientes. Para más datos se pueden  visitar las páginas de estas aplicaciones o de <a href="http://www.apache-es.org/index.php/2006/12/26/herramientas-de-pruebas-de-carga/" target="_blank" title="herramientas de test de rendimiento para apache">otras alternativas</a>.</p><p>Lo que tratamos de hacer es mejorar la configuración sin modificar el código de joomla o el cms que sea de modo que mejoremos en todos los clientes del isp. Decir sin embargo que este equipo deberá tener uno o dos webs únicamente.</p> <br /><a href="http://xarx.es/deries/archives/16-Rendimiento-del-miniservidor..html#extended">Continua leyendo "Rendimiento del miniservidor."</a>
