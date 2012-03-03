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
<br />
<p>Vuelvo a incluir los cambios respecto del datagrid &quot;oficial&quot;.</p><p><b>ChangeLog:</b></p><p>1-. eliminar un intval en la opción linktoedit (modo view) que forzaba a que los campos que se usaban como enlaces correspondiesen a una &quot;Primary Key&quot; que fuese un entero. Esto no tiene por que ser cierto (por ejemplo, la clave primaria de la BD de Wview - <a title="Estación Meteorológica del Planetari de Castelló" target="<u>blank" href="http://www.castello.es/archivos/598/img/index.html">estación meteorológica</a> - es un datetime)</p><p>2-. Cuando se usa una selección múltiple, los elementos seleccionados se concatenan y se separan con '-'. Yo lo he modificado para que se concatenen con '</u>' pues en el caso anterior de 2 datetimes la separación entre año, mes y día era también '-' por lo que había conflictos y los campos no se identificaban correctamente.</p><p><b>Los archivos:</b></p><p>1-. Diferencias respecto de la versión modificada anterior: <a href="http://xarx.es/deries/uploads/datagrid.class.v2.diff" title="datagrid.class.v2.diff" target="_blank">datagrid.class.v2.diff</a></p><p>2-. Diferencias respecto de la versión oficial 4.20: <a href="http://xarx.es/deries/uploads/datagrid.class.v2total.diff" title="datagrid.class.v2total.diff" target="_blank">datagrid.class.v2total.diff</a></p><div align="justify"><br />
</div>
