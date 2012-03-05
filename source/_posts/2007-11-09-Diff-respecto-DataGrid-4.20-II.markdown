---
layout: post
title: Diff respecto DataGrid 4.20 (II)
categories:
- Cuaderno-Laboratorio
- Pedidos PHP
permalink: /archives/13-Diff-respecto-DataGrid-4.20-II.html
s9y_link: http://xarx.es/deries/archives/13-Diff-respecto-DataGrid-4.20-II.html
date: 2007-11-09 19:38:52.000000000 +01:00
---
Vuelvo a incluir los cambios respecto del datagrid &quot;oficial&quot;.

**ChangeLog:**

**1-.** eliminar un intval en la opción linktoedit (modo view) que forzaba a que los campos que se usaban como enlaces correspondiesen a una &quot;Primary Key&quot; que fuese un entero. Esto no tiene por que ser cierto (por ejemplo, la clave primaria de la BD de Wview - [Estación Meteorológica del Planetari de Castelló](http://www.castello.es/archivos/598/img/index.html) - es un datetime)

**2-.** Cuando se usa una selección múltiple, los elementos seleccionados se concatenan y se separan con '-'. Yo lo he modificado para que se concatenen con '\_' pues en el caso anterior de 2 datetimes la separación entre año, mes y día era también '-' por lo que había conflictos y los campos no se identificaban correctamente.


**Los archivos:**

**1-.** Diferencias respecto de la versión modificada anterior: 

{% include_code Diferencias respecto versión modificada anterior datagrid.class.v2.diff lang:diff %}

**2-.** Diferencias respecto de la versión oficial 4.20: 

{% include_code Diferencias respecto versión oficial 4.20 datagrid.class.v2total.diff lang:diff %}

