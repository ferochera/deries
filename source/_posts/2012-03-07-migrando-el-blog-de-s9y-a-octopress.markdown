---
layout: post
title: "Migrando el blog de s9y a Octopress"
date: 2012-03-07 23:36
comments: true
categories: 
- Cuaderno-Laboratorio
keywords: migración a octopress, ruby, rvm
---
Después de constatar que realmente utilizar un sistema dinámico no me depara beneficios visibles y revisar otros sistemas de creación estática como [nanoc](http://nanoc.stoneship.org) finalmente, y tras conocer [octopres](http://octopress.org) a través del [blog de David Rubert](http://www3.uji.es/~vrubert), decidí mudar mi blog que estaba creado con [Serendipity-sy9](http://www.s9y.org)

Las etapas de este proceso han sido 3:

1. Poner en marcha el sistema de desarrollo.

2. Importar los posts previos.

3. Adaptar octopress.

<!--more-->Vamos a ver éstas etapas con más detalle:

##Preparar el sistema de desarrollo

Procedimiento funcionando en ubuntu 10.04.4

**1.** Instalar rvm y ruby

```
$ bash -s stable < <(curl -s https://raw.github.com/wayneeseguin/rvm/master/binscripts/rvm-installer)
$ rvm notes
$ rvm requirements
$ sudo aptitude install "los requirements"
$ rvm pkg install zlib
$ export C_INCLUDE_PATH=$HOME/.rvm/usr/include
$ rvm pkg install openssl
```
   
adecuar .bash_profile y/o .bashrc para shells con y sin login

```
$ rvm install 1.9.3 --with-zlib-dir=$rvm_path/usr --with-openssl-dir=$rvm_path/usr
```

También instalé en lmde. Al repetir los pasos anteriores me aparecía un error respecto a zlib al usar gem y se solucionó siguiendo las instrucciones de rvm notes (no tengo muy claro si en el puesto en ubuntu ocurrió lo mismo o no)

```
$ rvm get head && rvm install 1.9.3
$ rvm use 1.9.3 --default
$ gem install bundler (.gemrc con proxy si toca)
```

**2.** Preparar Octopress 

```
$ git clone git://github.com/imathis/octopress.git octopress
$ cd octopress         # si la versión de ruby no es adecuada se quejará
$ rvm use default      # usará la 1.9.3 según lo de arriba
$ bundle install       # instala las dependencias
$ rake install         # instala el tema por defecto
```

Si alguna vez da problemas de versiones de las gemas será necesario hacer “_bundle exec rake comando_” en vez de solo “_rake comando_”. Para ver los comandos disponibles se usa "_rake -T_"

##Importar los posts previos

[El importador desde s9y](https://github.com/mojombo/jekyll/pull/399) es una aportación de ["joshi"](https://github.com/joschi) a [jeckyll](https://github.com/mojombo/jekyll) que a su vez es la base de [Octopress](http://octopress.org)

Solo usa la biblioteca estándar de Ruby, sin acceso a base de datos. Las entradas se exportan desde el blog original a través del rss. Con un enlace del tipo

    http://blog.example.com/rss.php?version=2.0&all=1

1. Lo bajé del enlace anterior y lo dejé en la carpeta de plugins.

2. Ejecuté 

        ruby -r './s9y_rss.rb' -e 'Jekyll::S9Y.process("http://blog.example.com/rss.php?version=2.0&all=1")'

3. Moví la carpeta _posts que se había creado al lugar adecuado.

4. Revisé los posts para completarlos con los comentarios interesantes y con el resto del contenido si no estaban completos.

##Adaptar

* Adaptar los paths

En _\_config.yaml_ cambié lo que hacía falta para que el path comenzara en _/deries_ en vez de en _/_

* Traducir algunos elementos (incluir algunos en _config.yaml)

Me gustaría hacer un blog multilingüe pero eso parece algo alejado. Lo que si que he hecho es añadir algunos campos más en _\_config.yaml_ y colocarlos donde toca. También he cambiado algunos otros paths, como quitar _/blog/_ o cambiar _/archives_ por _/archivo_

    (...)
    date_format: "%A, %d de %B de %Y"

    \# Castellano
    excerpt_link: "Leer m&aacute;s &rarr;" 
    search_text: "Buscar"
    blog_nav_text: "Bitácora"
    archives_nav_text: "Archivo"
    recent_posts_aside_title: "Entradas recientes"
    github_aside_title: "Repositorios GitHub"
    older_text: "Anteriores"
    newer_text: "Posteriores"
    (...)

También modifiqué _/plugins/date.rb_ para hacer que la fecha aparezca en castellano. Esto lo hice siguiendo una sugerencia de un turco llamado [_Vigo_](https://github.com/vigo/octopress/blob/master/plugins/date.rb).

    (...)
    MONTHNAMES_TR = [nil,
      "Enero", "Febrero", "Marzo", "Abril", "Mayo", "Junio",
      "Julio", "Agosto", "Septiembre", "Octubre", "Noviembre", "Diciembre"
    ]
    ABBR_MONTHNAMES_TR = [nil,
      "Ene", "Feb", "Mar", "Abr", "May", "Jun",
      "Jul", "Ago", "Sep", "Oct", "Nov", "Dic"
    ]
    DAYNAMES_TR = [
      "Domingo", "Lunes", "Martes", "Mi&eacute;rcoles", 
      "Jueves", "Viernes", "S&aacute;bado"
    ]
    ABBR_DAYNAMES_TR = [
      "Dom", Lun", "Mar", "Mi&eacute;",
       "Jue", "Vie", "S&aacute;b"
    ]

    (...)

      else
        format.gsub!(/%a/, ABBR_DAYNAMES_TR[date.wday])
        format.gsub!(/%A/, DAYNAMES_TR[date.wday])
        format.gsub!(/%b/, ABBR_MONTHNAMES_TR[date.mon])
        format.gsub!(/%B/, MONTHNAMES_TR[date.mon])
        date_formatted = date.strftime(format)
        #date_formatted = date.strftime(format)
        #date_formatted.gsub!(/%o/, ordinal(date.strftime('%e').to_i))

    (...)

* adaptar algunos estilos y otras cosas

Por jugar más que otra cosa...

Me pareció que los carácteres eran de un tamaño de fuente pequeño en el caso de los code_snippets y grande en las citas. Intenté mejorarlo aunque no juraría haberlo conseguido.

También intenté poner un gráfico tipo el pulpo de octopress pero de momento lo que obtuve no fue de mi agrado así que lo retiré.

Todos estos cambios pueden verse en el repositorio de github que los contiene: [https://github.com/ferochera/deries](https://github.com/ferochera/deries)

Finalmente he añadido un _"aside"_ con una nube de etiquetas y también una página de entrada a las categorías que las lista poniendo el número de artículos en cada una.

Ambos elementos vienen del código de nube de tags de [_tokkonopapa_](https://github.com/tokkonopapa/octopress-tagcloud). Eso si ha sido necesario hacer una pequeña modificación en el código ya que los paths no eran correctos.

##Actualización..

La traducción de las fechas no está funcionando correctamente... es como si la función gsub! no hiciese lo que toca ¿? así que he decicido poner el formato a mano mientras averiguo que es lo que ocurre.

    format = DAYNAMES_TR[date.wday] +", %d de " + MONTHNAMES_TR[date.mon] + " de %Y"

##Actualización 2..

Para solucionar el error *"RVM is not a function, selecting rubies with 'rvm use ...' will not work."...* se añade la linea siguiente al final del archivo *.bashrc*

    [[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*
    
## Actualización 3..

La documentación de octopress es accesible en la web [octopres.org/docs](http://octopress.org/docs)

De todas formas los pasos para _"bloguear"_ son:

	(bundle exec) rake new_post["title"]
	_editar archivo markdown creado_
	rake generate   # Generates posts and pages into the public directory
	rake watch      # Watches source/ and sass/ for changes and regenerates
	rake preview    # Watches, and mounts a webserver at http://localhost:4000
