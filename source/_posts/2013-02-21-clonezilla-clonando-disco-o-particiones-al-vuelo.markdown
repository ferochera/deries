---
layout: post
title: "Clonando disco o partición/es al vuelo con Clonezilla"
date: 2013-02-21 18:27
comments: true
categories: 
- Cuaderno-Laboratorio
- mini-servidor
---

El "ocs-onthefly" se usa para copiar/clonar de disco a disco o de partición a particiónis al vuelo (sin imagen intermedia).

Este comando es diferente de drbl-ocs (o clonezilla). Clonezilla se usa para hacer un clonado masivo, o sea que guarda la máquina "de referencia" como imagen en el servidor clonezilla. Por otro lado, ocs-onthefly se usa para una copia 1 a 1, o sea que no se genera ni almacena una imagen en el servidor. Tan solo clona disco o partición directamente.

Hay 2 formas de ejecutar ocs-onthefly:
    
1- Clonado local: Arranca la máquina como cliente DRBL. A continuación se clona un disco a otro. Es una manera simple de clonar un disco cuando solo se dispone de una máquina.

2- Clonado por red: Arranca las máquinas origen y destino como clientes DRBL. A continuación se clona de la una a la otra. Esto es especialmente útil si se dispone de 2 máquinas y no se quiere desmontar los discos.

USO:

    ocs-onthefly [OPCION]
    Opciones:
	  -e, --resize-partition _Cambia el tamaño del disco de destino en la máquina de destino (soluciona el hecho de restaurar una partición/imagen pequeña en otra mayor)_
	  -f, --source DEV _Especifica el dispositivo de origen como DEV (hda, hda1...)_
	  -g, --grub-install GRUB_PARTITION _Instala grub en hda con el directorio raíz de grub en la partición GRUB_PARTITION cuando la restauración acaba. GRUB_PARTITION puede ser "/dev/hda1", "/dev/hda2"... o "auto" (con "auto" clonezilla detectará la partición raíz de grub automáticamente)_
	  -i --filter PROGRAM _Usar PROGRAM (gzip/lzop/bzip2/cat) antes de enviar los datos de la partición a netcat (solo en modo de clonado de red). El filtro por defecto es gzip. Úsese "cat" si no se quiere comprimir (Bueno para redes rápidas, donde la compresión nos ralentizará las transferencias)_
	  -n, --no-sfdisk _Saltar la creación de la tabla de particiones_
	  -m, --no-mbr-clone _NO clonar el MBR_
	  -o, --load-geometry _Forzar el uso de los CHS almacenados (cylinders, heads, sectors) al usar sfdisk durante la restauración_
	  -p, --port PORT _Especifica el puerto de netcat (Solo para el modo de clonado de red)_
	  -r, --server _Especifica que la máquina donde se ejecuta es el servidor de clonación en la red_
	  -s, --source-IP IP _Especifica la IP de la máquina origen (se usa en la máquina de destino)_
	  -t, --target DEV _Especifica el dispositivo de destino como DEV (hda, hda1...)_
	  -v, --verbose _Imprime información (más) durante la ejecución_

Ejemplo:
    
1. Clonado local: Clonado el 1er disco duro (hda) al 2o (hdb). Se arranca la máquina como cliente DRBL y se ejecute:

    ocs-onthefly -f hda -t hdb

2. Clonado vía red: Clonado del 1er disco duro (hda) de la máquina A al 1er disco duro (hda) de la máquina B. El procedimiento, sin desmontar las máquinas sería:

2.1- Arrancamos la máquina A como cliente DRBL. Supongamos que su IP es, por ejemplo, 192.168.100.1 Ejecutamos: 

    ocs-onthefly -r -f hda

2.2- En un momento de la ejecución se muestra el comando que se debe ejecutar en la máquina B. Será algo como:

    /opt/drbl/sbin/ocs-thefly --source-IP 192.168.100.1 -t [TARGET_DEV] (TARGET_DEV es hda, hdb, hda1, hdb1...)

Siendo el "TARGET_DEV" el disco (o partición) de destino en la máquina B (hda, hdb, hda1). En el ejemplo es hda

2.3 Se arranca la máquina B como cliente DRBL y se ejecuta ese comando completado adecuadamente.

    ocs-onthefly --source-IP 192.168.100.1 -t hda

El proceso de clonado comenzará a continuación... y si hay suerte concluirá sin problemas.