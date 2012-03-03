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
De momento la clase datagrid me funciona adecuadamente. Por esto almaceno aquí accesible el diff respecto del original.<p>Modificaciones respecto del original...</p><ol><li>Filtros con funciones Concat(TableName_FieldName1,TableName_FieldName2) ('.'=&gt;'_')</li><li>Tipo campo edit para hash sha1</li><li>Varios lang[] nuevos para algunas cadenas que no estaban traducidas. Ojo con los Charsets</li><li>Forzar que los enlaces en el modo edit sean siempre texto.</li></ol><a target="_blank" title="datagrid.class.diff" href="http://xarx.es/deries/uploads/datagrid.class.diff">datagrid.class.diff</a><br /><div align="justify"><br />
</div>
