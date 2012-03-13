---
layout: post
title: "¿Qué has hecho en mi equipo?"
date: 2012-03-13 15:03
comments: true
categories: 
- Cuaderno-laboratorio
- General
keywords: tightvnc, pyvnc2swf, keylogger
---
Hace ya un tiempo llegué a un artículo del 2007 llamado ["How To Make Your Computer Catch People Stealing Your Porn"](http://consumerist.com/2007/07/how-to-make-your-computer-catch-people-stealing-your-porn.html). Se trata de un test sobre la privacidad de nuestros datos cuando llevamos el ordenador al servicio técnico. Los autores habían preparado un equipo con algunas imágenes golosas (chicas ligeras de ropa) y pedían a diferentes servicios técnicos que hicieran una intervención simple. Generaban vídeos del proceso y así cogieron a algunos técnicos que no actuaban profesionalmente...

Realmente me interesaba el método para conocer que se ha hecho en mi equipo. En este artículo se cuenta como usar un vnc para generar un vídeo. 

Hace muy poco necesitaba buscar otra vez el artículo original y me costó volver a encontrarlo así que una vez hallado voy a preparar el resumen.

<!--more-->
Las herramientas que se utilizan son __TightVNC__ y __pyvnc2swf__.

* TightVNC opera como el grabador. Provee una interfaz de salida para el escritorio del ordenador.

* Pyvnc2swf captura el resultado de esas imágenes y las almacena en un archivo para poder visualizarlos a posteriori. En un equipo con una memoria o CPU limitadas se puede optar por volcados crudos (_raw_) a un archivo VNC. En un equipo mejor dotado se puede volcar directamente a un archivo SWF comprimido 

## Configuración de TightVNC

{% img center /images/tightvncsetup.jpg 'TightVNC setup' 'Configurando TightVNC' %}

Tras instalar TightVNC, se utiliza la aplicación de control para configurar el VNC incluyendo la contraseña y se debe habilitar las conexiones locales (de lookback). Una vez utilizada esa aplicación de control hay que desabilitarla del arranque. Esto es porque no nos interesa que aparezcan en la barra de tareas o de notificación para que no se vea que estamos grabando.

## Pyvnc2swf

El trabajo real lo realiza pyvnc2swf. Éste lo lanzaremos con un archivo _batch_. Usar un archivo _batch_ proporciona una forma fácil de aleatorizar los archivos resultantes y además puede ser lanzado desde un servicio que configuremos al efecto.

La utilidad _srvany.exe_ es un programa que permite ejecutar como un servicio del sistema operativo una aplicación normal de Ms Windows (Xp, es el del ejemplo, pero se supone que en otros Ms Windows habrá algo similar).

Una vez tenemos el archivo _batch_ preparado podemos utilizar este sistema para lanzarlo en el arranque. Como parte del proceso de definición del servicio elegiremos un nombre que suene _"Microsoft-iano"_, como "Windows Image Capture Service". Esto es para que nuestro sistema de captura no sea detectado a primera vista.

```
echo off
"C:\Archivos de Programa\hoyle\wddm.exe" -n -o "C:\Archivos de Programa\hoyle\"%RANDOM%.vnc -P "C:\Archivos de Programa\hoyle\password.txt" localhost
```

Tal como puede verse en el código anterior se configura la contraseña en un archivo de texto (el nombre se puede "mejorar") para poder acceder al VNC. En el archivo basta con que esté la contraseña en su propia línea. El parámetro _%RANDOM%_ garantiza que pyvnc2swf no sobreescriba sus propios archivos al arrancar diferentes veces. Otra opción sería añadir _%TIME%_ u otra similar.

Tras configurar lo anterior habrá que verificar que nuestro servicio personalizado está configurado como "Automático". Tras esto, si todo está configurado correctamente, en cada reinicio del computador éste comenzará a grabar los contenidos del escritorio en la carpeta que previamente hayamos definido.

Posteriormente se puede utilizar la herramienta _"edit"_ de pyvnc2swf para convertir los archivos según nuestras necesidades.

En cuanto a la configuración restante faltaría, por ejemplo, regular con que frecuencia se captura la imagen del escritorio (probablemente con 1 o 2 imágenes por segundo bastará).

## Captura de Teclado. 

Complementando la captura del escritorio en vídeo podemos instalar un keylogger que nos capture también las teclas. 

Para esto nos basamos en el artículo [How to Use Home Keylogger to Monitor Your Kids - Jimmy Vidzem](http://voices.yahoo.com/how-home-keylogger-monitor-kids-2303677.html). Seguro que hay opciones más elaboradas en cuanto a captura y ocultación pero para lo que queremos debería ser suficiente...

Los _keyloggers_ son aplicaciones diseñadas para capturar las pulsaciones del teclado. En este caso utilizaremos [Home Keylogger](http://www.spyarsenal.com/keylogger). Este keylogger en particular es _freeware_. Y comenzaremos bajándolo e instalándolo.

Tras instalarlo aparece una ventana donde podemos comprobar que funciona correctamente. En el área de notificación hay un icono negro. Haciendo clic en él y seleccionando "->View Log" deberíamos ver lo que habíamos tecleado previamente. 

Podemos hacer que se inicie con cada reinicio haciendo clic en el icono de nuevo y seleccionando "Autorun". Para ocultar el keylogger habrá que hacer clic de nuevo y seleccionar "Hide icon". Aparecerá un pop-up diciendo "To show press CTRL+ALT+SHIFT+M" y tan pronto como le demos a OK desaparecerá el icono del área de notificación. Para volver a hacerlo aparecer tendremos que volver a pulsar la misma combinación de teclas (CTRL+ALT+SHIFT+M)

Tal vez se podría iniciar utilizando el mismo _batch_ comentado arriba... Y no estaría de más revisar si hay opciones para lanzarlo oculto directamente.

## Observaciones

1. Estos mecanismos no funcionarán si el equipo arranca en Modo Seguro (safe mode) ya que en ese caso no se inician los servicios y programas que no sean críticos en el sistema.

2. Los servicios son diferenciables ya que los que nosotros ponemos no son de "sistema" sino de "usuario".

