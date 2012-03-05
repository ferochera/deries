---
layout: post
title: Diff respecto DataGrid 4.20
categories:
- Cuaderno-Laboratorio
- Pedidos PHP
permalink: /archives/8-Diff-respecto-DataGrid-4.20.html
s9y_link: http://xarx.es/deries/archives/8-Diff-respecto-DataGrid-4.20.html
date: 2007-10-25 11:15:55.000000000 +02:00
---
De momento la clase datagrid me funciona adecuadamente. Por esto almaceno aquí accesible el diff respecto del original.

Modificaciones respecto del original...

1. Filtros con funciones Concat(TableName_FieldName1,TableName_FieldName2) ('.'=&gt;'_')
2. Tipo campo edit para hash sha1
3. Varios lang\[\] nuevos para algunas cadenas que no estaban traducidas. Ojo con los Charsets
4. Forzar que los enlaces en el modo edit sean siempre texto.

Para ver el código y bajarlo es necesario mostrar el artículo completo...<!--more-->
{% include_code Diferencias respecto del original datagrid.class.diff lang:diff %}

