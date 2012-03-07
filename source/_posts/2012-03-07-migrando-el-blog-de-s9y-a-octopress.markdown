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
    Instalar rvm $ bash -s stable (“rvm.sh”) ver web
    rvm requirements
    sudo aptitude install los requirements
    rvm pkg install zlib
    export C_INCLUDE_PATH=$HOME/.rvm/usr/include
    rvm pkg install openssl
    adecuar .bash_profile y/o .bashrc para shells con y sin login
    rvm install 1.9.3 --with-zlib-dir=$rvm_path/usr --with-openssl-dir=$rvm_path/usr

    En lmde aparecía error respecto a zlib al usar gem y se soluciónó siguiendo las instrucciones de rvm notes

    rvm get head && rvm 1.9.3
    rvm use 1.9.3 --default
    gem install bundler (.gemrc con proxy si toca)

    bajar octopress (git clone) e ir a su carpeta y hacer bundle install para que se bajen todas las gemas que toquen

Si alguna vez da problemas de versiones hacer “bundle exec rake generate” en vez de solo “rake generate”

##Importar los posts previos

usar el importador ...

##Adaptar

* Adaptar los paths

* Traducir algunos elementos (incluir algunos en _config.yaml)

* adaptar algunos estilos

##Por hacer... 

* que se vean las categorías de un artículo. Ver [http://anthonydigirolamo.github.com/blog/2011/09/21/octopress-category-listing/](http://anthonydigirolamo.github.com/blog/2011/09/21/octopress-category-listing/))

* crear una nube de tags en la sidebar. Ver [https://github.com/tokkonopapa/octopress-tagcloud](https://github.com/tokkonopapa/octopress-tagcloud)

#Todavía estamos trabajando en ello.
