---
layout: post
title: Restaurar imagen de WinXp en otro hardware.
categories:
- Cuaderno-Laboratorio
permalink: /archives/31-Restaurar-imagen-de-WinXp-en-otro-hardware..html
s9y_link: http://xarx.es/deries/archives/31-Restaurar-imagen-de-WinXp-en-otro-hardware..html
date: 2008-10-03 11:06:54.000000000 +02:00
---
<br />
<p align="justify">No dudes que el camino bueno es el que indican las ayudas de los programas de imágenes. Es decir... &quot;preparar&quot; la instalación para realizar la imagen con la utilidad <a title="Sysprep en Wikipedia (inglés)" href="http://en.wikipedia.org/wiki/Sysprep"> sysprep</a> de Microsoft y posteriormente realizar la imagen. Así cuando restauremos y arranquemos haremos como una finalización de instalación del S.O.</p><p align="justify">Podemos encontrar información de le herramienta en <a title="Cómo utilizar la herramienta Sysprep.exe para automatizar la correcta implementación de Windows XP" href="http://support.microsoft.com/kb/302577/es">support de Microsoft</a> o <a title="Manual de SYSPREP para clonar un Windows XP en distintos PC(pdf)" href="http://download-linkat.xtec.cat/d83/sysprep.pdf">aquí</a>.</p><p align="justify">Pero ¿qué pasa si se te ha fastidiado el hardware y quieres restaurar una imagen reciente en tu hardware nuevo? </p><p align="justify">Puedes seguir el tutorial &quot;<b>Cómo cambiar una placa sin reinstalar Windows</b>&quot; (<a title="Cómo cambiar una placa sin reinstalar Windows" href="http://www.noticias3d.com/articulo.asp?idarticulo=903">web1</a> o <a title="Cómo cambiar una placa sin reinstalar Windows" href="http://www.comunicopy.com/foros/viewtopic.php?t=79">web2</a>)</p><p align="justify">En mi caso, tras un fallo multiorgánico del equipo, tuve que recurrir a un hardware algo más antiguo con lo que tras la restauración de la imagen no había manera de que arrancara...</p>

**¿Qué podemos hacer?**

Se puede hacer una instalación encima cambiando la HAL (presionar F5 mientras dice algo así como "si tienes drivers para controlador específico pulsa F6" al principio de la instalación; elegir el hal adecuado para tu máquina) y proceder con la instalación diciendole al instalador que mantenga el S.O. que previo (eso si, después hay que volver a aplicar los service packs y actualizaciones, cosa que hace que el tema sea muy lento). Como dice [Vicente Navarro](http://www.vicente-navarro.com/blog/)... Lo hice y lo entendí, aunque yo lo hice y lo sufrí.

La segunda opción es más rápida. Supongamos, como era mi caso, que la imagen está restaurada pero no arranca. Podemos seguir el tutorial anterior en la parte que hace referencia a la sustitución de la hal. Para ello extraemos los archivos de kernel y hal adecuados para nuestra máquina del service pack (ej c:\WINDOWS\Driver Cache\i386\sp2.cab) correspondiente (o de c:\WINDOWS\Driver Cache\i386\driver.cab) desde otra máquina (o arrancando con un livecd y extrayendolo del disco restaurado si no tenemos otra a mano). Les cambiamos el nombre y los colocamos en c:\WINDOWS\system32 de nuestro equipo siguiendo las recomendaciones del tutorial (krnl.exe, krnlpa.exe y halnew.dll). Posteriormente alteramos el boot.ini (archivo oculto y de solo lectura situado en la raíz c:\ que contiene las opciones de arranque).

Lo que hacemos es introducir una nueva opción:

```
    [boot loader]
    timeout=10
    default=multi(0)disk(0)rdisk(0)partition(1)\WINDOW S

    [operating systems]
    multi(0)disk(0)rdisk(0)partition(1)\WINDOWS="Microsoft Windows XP ..." /fastdetect /NoExecute=OptIn
    multi(0)disk(0)rdisk(0)partition(1)\WINDOWS="Windows XP cambio hal" /noexecute=alwaysoff /fastdetect /sos /kernel=krnl.exe /hal=halnew.dll
```

Arrancaremos seleccionando esta nueva entrada. Detectará la hal diferente y copiara los archivos sobre los ntoskrnl.exe, ntkrnlpa.exe y hal.dll. Tras eso podemos reiniciar y arrancar con la opcion normal. Después borraremos del boot.ini la opción que nos ha servido para restaurar la hal adecuada.

Solo nos faltará reactivar el windows.

Actualizaciones y Comentarios previos
--------------------------------------

**Comentario 1**

[Windows xp setup ACPI key, F10 F2 F6 F5 y otras teclas de función]
(http://miguesmart.blogspot.com/2008/08/windows-xp-setup-acpi-key-f10-f2-f6-f5.html)

Durante la instalación puede usar varias teclas de función para activar ciertas características y comandos. En la lista siguiente se detallan las teclas de función, lo que hacen y cómo se pueden usar.

Se pueden usar tres teclas cuando se carga el programa de instalación y cuando se le pide que presione la tecla de función F6 para instalar la interfaz estándar de equipos pequeños (SCSI, Small Computer System Interface) de terceros y los controladores de las controladoras de host:

> * F5: para la selección de la capa de abstracción de hardware (HAL) o del tipo de equipo
> * F6: para instalar controladores de controladoras de host y SCSI de terceros
> * F7: para ejecutar el programa de instalación sin Interfaz avanzada de configuración y energía (ACPI)


Cuando aparece la pantalla de bienvenida, se pueden usar las teclas de función siguientes:

> * F2: para iniciar automáticamente el proceso de Recuperación automática del sistema (ASR).
> * F10: para omitir las pantallas de menú y cargar la Consola de recuperación

Durante la instalación en modo de interfaz gráfica de usuario (GUI), se pueden usar las siguientes teclas de función:
> * MAYÚS+F10: para habilitar el acceso a un símbolo del sistema durante la instalación en modo GUI
> * MAYÚS+F11: para mostrar los asistentes al "estilo antiguo" que ofrecen más detalles

**Comentario 2 (el loco)**

Hola, como estan?, tengo un problema con respecto al siguiente tema: Hice una imagen de un windows xp con todos los parches de seguridad y todo instalado y testeado, lo instale todo en una maquina rapida, (solo utilice el disco rigido) y no instale ningun driver ni nada (ya que no eran de la maquina en la que finalmente funcionarian), y luego cuando lleve ese disco a una maquina mas antigua el xp no arranca... se queda en la pantalla negra con el cursor titilando, no llega a mostrar la pantalla del windows cargando... y se que hay una solucion en el arranque, pero no se donde... (ya probe con los sectores de arranque y demas del disco pero no hay forma...) queria saber si tienen alguna solucion? sin tener que reinstalar nada.. Gracias.

**Respuesta**

Lee la documentación enlazada (las webs) y trata de averiguar que 'hal' le corresponde a tu equipo.

Luego puedes seguir el procedimiento que te cuento de poner los archivos a mano para que los cargue en el siguiente arranque.

Saludos. 
