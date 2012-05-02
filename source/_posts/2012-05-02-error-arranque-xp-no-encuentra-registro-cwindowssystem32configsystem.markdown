---
layout: post
title: "Error arranque: XP no encuentra uno de los archivos del registro (system)"
date: 2012-05-02 17:33
comments: true
categories: 
- Cuaderno-laboratorio
- General
keywords: Windows XP, registro, arranque, Hiren's Boot CD
---

Mi portatil ya está en su tercera edad, es del 2002, y además ya ha sufrido bastantes achaques... varios transplantes de disco duro...

Hace unas temporadas además se fue de escalada y tubo un traspiés con una caída de 3m que motivó otro trasplante, esta vez de pantalla, y también causó otros rasguños superficiales.

En este accidente creo que también se dañó algo el disco duro porque desde entonces suele fallar algo...

En concreto el error del que voy a hablar hoy ya es la segunda vez que aparece... se trata de que el arranque de Ms Windows XP (Home) no encuentra alguno de los archivos que contienen el registro. Esta última vez no encontraba el archivo _system_ dentro de c:\windows\system32\config

Realmente el archivo estaba allí pero debía haberse quedado en un estado extraño...

Microsoft ofrece un artículo al respecto: [Cómo recuperar un Registro dañado que impide que Windows XP se inicie](http://support.microsoft.com/kb/307545/es)

En el se propone el uso de la consola de recuperación para hacer el proceso en varios pasos...

* Arrancar desde la consola de recuperación y recuperar el registro del día que se instaló el equipo.

* Arrancar con el registro de instalación y copiar los archivos de registro de algún punto de restauración a una localización accesible desde la consola.

* Arrancar desde la consola de recuperación y copiar los archivos del punto de restauración copiados en el paso anterior a otra localización.

* Suerte.

Bien... yo dedicí utilizar el Hiren's Boot CD (HBCD) (versión 14.1) y sus utilidades... Hay una sección dedicada a las utilidades relacionadas con el registro. Entre ellas hay una, de la que no recuerdo el nombre, dedicada a recuperar el registro a un punto de restauración previo... La ejecuté y ¡BIEEEN! ¡¡FUNCIONÓ!! TODOS LOS PASOS DE UN GOLPE.

También tiene otra utilidad de copia de seguridad del registro. En la versión siguiente (15.1) parece que hay una utilidad llamada _Registry Restore Wizard_ que hace esto y seguramente más.

En resumen... una buena herramienta nos hace la vida más fácil.
