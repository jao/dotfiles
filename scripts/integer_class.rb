class Integer
  def factorial
    return 1 if self == 0
    (1..self).inject { |i,j| i*j }
  end
  
  def perc_of? v
    self.to_f/v*100
  end
  
  def tries options = {}, &block
    return if self < 1
    yield attempts ||= 1
    rescue options[:ignoring] || Exception => e
    retry if (attempts += 1) <= self
  end
  
  def to_t
    Time.at(self) + 10800
  end
end