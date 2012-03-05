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

<!--more-->
Procedimiento a seguir:
-----------------------

1. Descargar el simulador desde la[web de la herramienta](http://www.csse.uwa.edu.au/cnet/).

2. Descomprimir el simulador en una carpeta de tu directorio _$HOME_ que elijas, por ejemplo cnet (X indica la versión): _tar zxf cnet-X.tgz_

3. Editar el ﬁchero _$HOME/cnet/Makefile_ y cambiar el valor de _PREFIX_ a la carpeta donde queremos que quede instalado. Por ejemplo _/home/usuario/cnet-X_.

4. Editar el ﬁchero _$HOME/cnet/src/Makefile.linux_ y cambiar el valor de _XLIBS_ a _"-ltcl8.4 -ltk8.4 -lX11"_. (Las versiones de tcl y tk pueden variar dependiendo del sistema y se pueden conocer haciendo locate tcl)

5. Compilar el simulador ejecutando el comando _make_ en el directorio _$HOME/cnet_. Pueden aparecer errores derivados de que no se encuentren las librerías tcl, tk y X. Lo adecuado sería asegurarse de que tenemos las versiones adecuadas (y sus paquetes -dev) instaladas. Al compilar en este punto aparecen errores debidos a que no se encuentran las cabeceras tcl.h y tk.h. Se puede proceder de dos maneras:

    * Creando enlaces desde la carpeta include a los elementos necesarios (J.M.C. afirma son todas las cabeceras de la carpeta tcl8.4)

```
    # cd /usr/include
    # ln -s /usr/include/tcl8.4/tclDecls.h ./tclDecls.h
    # ln -s /usr/include/tcl8.4/tcl.h ./tcl.h
    # ln -s /usr/include/tcl8.4/tclPlatDecls.h ./tclPlatDecls.h
    # ln -s /usr/include/tcl8.4/tkDecls.h ./tkDecls.h
    # ln -s /usr/include/tcl8.4/tk.h ./tk.h
    # ln -s /usr/include/tcl8.4/tkPlatDecls.h ./tkPlatDecls.h
```

    * La otra opción es modificar las fuentes de cnet para que apunten donde toca (ej. _#include "tcl.h"_ --> _#include "tcl8.4/tcl.h"_). Y seguir modificando dependiendo de los posibles mensajes de error.

Instalar con _make install_. Esto moverá los archivos necesarios de _$HOME/cnet_ a _$HOME/cnet-X_ según el ejemplo anterior (según el comentario inferior será necesario tener creado el directorio de destino). Con esto solo conseguimos tener separado los fuentes de los archivos instalados y por tanto no es estrictamente necesario.

Ejecutar los dos siguientes comandos del shell:

     export CNETPATH=$HOME/cnet-X:$HOME/cnet-X/cnetlib

y

     export PATH=$PATH:$HOME/cnet-X

Estos dos comandos deben ser ejecutados en cualquier terminal (ventana) nueva que se pretenda utilizar; alternativamente, es posible personalizar el sistema incluyendo estos dos comandos en el ﬁchero de arranque apropiado (.profile, .cshrc, etc., dependiendo del shell disponible).

Actualizaciones y Comentarios previos
--------------------------------------

**Comentario 1**

cuando ejecuto sudo make install me da el siguiente error=>

     cp: no se puede crear el fichero regular `/home/usuario/Programas/cnet-2.0.10/bin/cnet': No existe el fichero ó directorio
     make: *** [install] Error 1

PREFIX = /home/usuario/Programas/cnet-2.0.10

**Respuesta** 

Es probable que me haya dejado la creación del directorio de destino y que el instalador solo cree los subdirectorios necesarios. Intentaló y si te funciona te agradecería que me lo contaras para que modifique el texto.

**Comentario 2**

x fa necesito el simulador de red

**Respuesta**

Tal vez no has visto el enlace a la web del simulador... por si acaso te dejo el enlace a la hoja de bajar el programa en texto plano:

* [http://www.csse.uwa.edu.au/cnet/install.html](http://www.csse.uwa.edu.au/cnet/install.html)

Y también a la versión más actual del programa:

* [http://www.csse.uwa.edu.au/cnet/cnet-2.0.10.tgz](http://www.csse.uwa.edu.au/cnet/cnet-2.0.10.tgz)

**Comentario 3** 

no puedo instalar el cnet, en un cd live slax o si?

por que hey intentado lo que dice y me sale q sudo apt-get comand no found bueno soy novato en linux es ams es al priemra vez que manejo este SO asi que me dieran sitios donde aprender mas de este SO les estaria agredecido pero primero ayudenme a solucionar este problema

**Respuesta**
Lee el procedimiento detallado.

Lo importante es compilar con la versión que tienes de tcl y tk. Por ejemplo, si tienes la versión 8.3 podrías poner XLIBS como -ltcl8.3 -ltk8.3 -lX11 y debería funcionar. Para ver que version tienes puedes ejecutar 'locate tcl' desde la linea de comandos.

No se como funciona la actualización de paquetes en slax (y menos si se puede en un livecd). Apt-get es la herramienta para manejo de paquetes en debian y derivadas. Por cierto, había un error, es '... apt-get install...'

En [http://txuspe.bandaancha.st/instalar-cnet.html](http://txuspe.bandaancha.st/instalar-cnet.html) podeis encontrar otro tutorial de instalación del simulador de red CNET en Ubuntu.

