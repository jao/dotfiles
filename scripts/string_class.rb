class String
  def center size=80
    s = self
    (s.length..size).each do |n|
      s = n % 2 == 0 ? " #{s}" : "#{s} "
    end
    s
  end
  
  def banner size=80, lines=false
    size = WINDOW[0]-3
    max = size
    s = ""
    self.each_line do |l|
      l = l.chomp
      max = l.length if l.length > max
      l += " " while l.length <= size
      s += " #{l} \n"
    end
    el = " "*size
    if max > size
      self.banner(max, lines)
    else
      lines ? "#{el}\n#{s.chomp}\n#{el}" : "#{s.chomp}"
    end
  end
  
  def colorize fg, bg=nil, format=nil
    @fg = fg_color fg
    @bg = bg_color bg
    @format = set_format format
    "\e[#{@format};#{@fg};#{@bg}m#{self}\e[0m"
  end
  
  # color patterns
  def debug
    self.colorize('pink')
  end
  
  def debug! format=nil
    self.colorize('white','pink',format)
  end
  
  def info! format=nil
    self.colorize('black','white',format)
  end
  
  def more_info! format=nil
    self.colorize('blue','white',format)
  end
  
  def success
    self.colorize('green')
  end
  
  def success? condition, bg=false
    bg ? self.colorize(condition ? 'black' : 'white', condition ? 'green' : 'yellow') : self.colorize(condition ? 'green' : 'yellow')
  end
  
  def success! format=nil
    self.colorize('black','green',format)
  end
  
  def warn
    self.colorize('yellow')
  end
  
  def warn! format=nil
    self.colorize('black','yellow',format)
  end
  
  def error
    self.colorize('red')
  end
  
  def error! format=nil
    self.colorize('white','red',format)
  end
  
  protected
  # color aliases using method missing
  def method_missing methodname, *args
    options = methodname.to_s.split('_')
    # if is_color? colors[0]
       self.colorize(options[0], options[1], options[2])
    # else
    #   self.colors[0]
    # end
  end
  
  def is_color? color
    (color =~ /black|red|green|yellow|blue|pink|cyan|white/i)
  end
  
  def is_format? format
    (format =~ /bold|underline|blink|invert|b|u|x/i)
  end
  
  def set_format mode=nil
    case mode
      when 'bold','b': 1
      when 'underline','u': 4
      when 'blink': 5
      when 'invert','x': 7
      else 0
    end
  end
  
  def fg_color color=nil
    case color
      when 'black': 30
      when 'red': 31
      when 'green': 32
      when 'yellow': 33
      when 'blue': 34
      when 'pink': 35
      when 'cyan': 36
      when 'white': 37
      else 37;
    end
  end
  
  def bg_color color=nil
    case color
      when 'black': 40
      when 'red': 41
      when 'green': 42
      when 'yellow': 43
      when 'blue': 44
      when 'pink': 45
      when 'cyan': 46
      when 'white': 47
      else 40;
    end
  end
end
