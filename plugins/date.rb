module Octopress
  module Date

    # Traducción de los días y meses de "Vigo"
    # https://github.com/vigo/octopress/blob/master/plugins/date.rb
    MONTHNAMES_TR = [nil,
      "Enero", "Febrero", "Marzo", "Abril", "Mayo", "Junio",
      "Julio", "Agosto", "Septiembre", "Octubre", "Noviembre", "Diciembre"
    ]
    ABBR_MONTHNAMES_TR = [nil,
      "Ene", "Feb", "Mar", "Abr", "May", "Jun",
      "Jul", "Ago", "Sep", "Oct", "Nov", "Dic"
    ]
    DAYNAMES_TR = [
      "Domingo", "Lunes", "Martes", "Mi&eacute;rcoles", "Jueves",
      "Viernes", "S&aacute;bado"
    ]
    ABBR_DAYNAMES_TR = [
      "Dom", "Lun", "Mar", "Mi&eacute;", "Jue",
      "Vie", "S&aacute;b"
    ]


    # Returns a datetime if the input is a string
    def datetime(date)
      if date.class == String
        date = Time.parse(date)
      end
      date
    end

    # Returns an ordidinal date eg July 22 2007 -> July 22nd 2007
    def ordinalize(date)
      date = datetime(date)
      "#{date.strftime('%b')} #{ordinal(date.strftime('%e').to_i)}, #{date.strftime('%Y')}"
    end

    # Returns an ordinal number. 13 -> 13th, 21 -> 21st etc.
    def ordinal(number)
      if (11..13).include?(number.to_i % 100)
        "#{number}<span>th</span>"
      else
        case number.to_i % 10
        when 1; "#{number}<span>st</span>"
        when 2; "#{number}<span>nd</span>"
        when 3; "#{number}<span>rd</span>"
        else    "#{number}<span>th</span>"
        end
      end
    end

    # Formats date either as ordinal or by given date format
    # Adds %o as ordinal representation of the day
    def format_date(date, format)
      date = datetime(date)
      if format.nil? || format.empty? || format == "ordinal"
        date_formatted = ordinalize(date)
      else
	#these replacings are not working properly!!!! so direct substitution
        #format.gsub!(/%b/, ABBR_MONTHNAMES_TR[date.mon])
        #format.gsub!(/%B/, MONTHNAMES_TR[date.mon])
        #format.gsub!(/%a/, ABBR_DAYNAMES_TR[date.wday])
        #format.gsub!(/%A/, DAYNAMES_TR[date.wday])
        #date_formatted = "(" + date.wday.to_s() + ":" + DAYNAMES_TR[date.wday] + ") "+ date.strftime(format)
	format = DAYNAMES_TR[date.wday] +", %d de " + MONTHNAMES_TR[date.mon] + " de %Y"
        date_formatted = date.strftime(format)
        #date_formatted.gsub!(/%o/, ordinal(date.strftime('%e').to_i))
      end
      date_formatted
    end

  end
end


module Jekyll

  class Post
    include Octopress::Date

    # Convert this post into a Hash for use in Liquid templates.
    #
    # Returns <Hash>
    def to_liquid
      date_format = self.site.config['date_format']
      self.data.deep_merge({
        "title"             => self.data['title'] || self.slug.split('-').select {|w| w.capitalize! || w }.join(' '),
        "url"               => self.url,
        "date"              => self.date,
        # Monkey patch
        "date_formatted"    => format_date(self.date, date_format),
        "updated_formatted" => self.data.has_key?('updated') ? format_date(self.data['updated'], date_format) : nil,
        "id"                => self.id,
        "categories"        => self.categories,
        "next"              => self.next,
        "previous"          => self.previous,
        "tags"              => self.tags,
        "content"           => self.content })
    end
  end

  class Page
    include Octopress::Date

    # Initialize a new Page.
    #
    # site - The Site object.
    # base - The String path to the source.
    # dir  - The String path between the source and the file.
    # name - The String filename of the file.
    def initialize(site, base, dir, name)
      @site = site
      @base = base
      @dir  = dir
      @name = name

      self.process(name)
      self.read_yaml(File.join(base, dir), name)
      # Monkey patch
      date_format = self.site.config['date_format']
      self.data['date_formatted']    = format_date(self.data['date'], date_format) if self.data.has_key?('date')
      self.data['updated_formatted'] = format_date(self.data['updated'], date_format) if self.data.has_key?('updated')
    end
  end
end
