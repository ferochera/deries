---
layout: post
title: "Cable de red: rígido vs flexible"
date: 2009-02-26 23:33
comments: true
categories: guifi.net
keywords: guifi.net, cable red
---
He extraido un par de comentarios que pueden ser útiles a la hora de elegir cable de red. La idea es ver que ventajas e inconvenientes tiene el uso de cable rígido y/o cable flexible.

Aunque los fragmentos están en inglés al final he añadido unas conclusiones simples...

##Comentario 1:

{% blockquote msc_data http://reviews.ebay.com/Solid-vs-Stranded-Network-Cabling-Which-to-choose_W0QQugidZ10000000002065324 Solid vs. Stranded Network Cabling - Which to choose? : eBay Guides %}
Category 5e and Category 6 network cable comes in a solid conductor format, and in stranded conductor formats. People often ask which is appropriate for their application. We'll detail the difference between two types of cable, and help you decide which application is suits which cable.

Solid conductor uses 1 solid wire per conductor, so in a standard Cat-5e or Cat-6 4 pair (8 conductor) roll, there would be a total of 8 solid wires. Stranded conductor uses multiple wires wrapped around each other in each conductor, so in a 4 pair (8 conductor) 7 strand roll (typical configucation), there would be a total of 56 wires.

Solid conductor cable is most useful for structured wiring within a building. It is easily punched down onto wall jacks and patch panels since it is a single conductor. The wire seats properly into insulation displacement connector. Solid is less useful when you are terminating with standard RJ45 connectors, as used when making patch cables. Most RJ45 connectors use 2 prongs which penetrate the conductor itself. This is not desirable, since solid cable has the tendency to break when penetrated by the prong. Using a 3 prong style RJ45 connectors creates a much better connection as it doesn't break the conductor - the 3 prongs style connection wraps around the conductor instead of penetrating it. All being said, it is recommended that stranded network cable be used for patch cables - they make better quality RJ45 termination connections than even using 3 prong connectors. Stranded cable is much less useful for punching down on wall jacks because the strands do not keep their perfect round shape when thrust into a insulation displacement connector. For best results, use solid for wall jacks and stranded for crimp connectors.

Stranded cable is typicalled used to create patch cables. The cable itself is more flexible, and rolls up well. The RJ45 terminators have a better, and more flexible and complete connection to stranded wires than solid wire.
{% endblockquote %}

##Comentario 2:

{% blockquote Syscon Cables http://www.connectworld.net/syscon/support.htm CAT-5, CAT-5e, CAT-6, CAT-7 Patch Cables %}
UTP stands for Unshielded Twisted Pair. It is a cable type with pairs of twisted insulated copper conductors contained in a single sheath. UTP cables are the most common type of cabling used in desktop communications applications.

Stranded cable has several small gauge wires in each separate insulation sleeve. Stranded cable is more flexible, making it more suitable for shorter distances, such as patch cords.

Solid has one larger gauge wire in each sleeve. Solid cable has better electrical performance than stranded cable and is traditionally used for inside walls and through ceilings - any type of longer run of cable.

Patch Cables are made of stranded copper conductors for flexibility. This construction is great for the flexing and the frequent changes that occur at the wall outlet or patch panel. The stranded conductors do not transmit data signals as far as solid cable. The TIA/EIA 568A which is the governing standard regarding commercial cabling systems limits the length of patch cables to 10 meters in total length. Does that mean you can't use stranded cable for longer runs? Not at all, we've seen installations running stranded cable over 100 feet with no problems - it's just not recommended. This is why we don't sell patch cables over 30 feet in length.
{% endblockquote %}

##Conclusiones:

*    El cable sólido se recomienda para instalaciones alejadas (largas tiradas de cable) y fijas (cableado de edificio, por ejemplo) mientras que el flexible se recomienda para latiguillos.
*    El cable rígido es recomendable cuando está finalizado en rosetas. Cuando debe acabar en un conector rj45 macho debe buscarse uno que no seccione el cable, sino que lo rodee. Este problema no se presenta con el cable flexible.
*    Para cableado en exteriores debería usarse FTP en vez de UTP por su mayor resistencia al medio ambiente.

