#!/usr/bin/env ruby
STDOUT.sync = true

# get terminal window resolution
WINDOW = HighLine::SystemExtensions.terminal_size

# print in the same line
def psl s=''
  print "\r#{s}#{' '*(WINDOW[0]-s.length)}"
end

# text animation
ANIMATION_COUNTER = {}
def text_animation p
  frames = case p
    when 'bars'
      %w{/ - \ |}
    when 'gym'
      %w{_o_ \o/ |o| \o/}
    when 'gym_long'
      %w{_o_ \o/ |o| \o/ _o_ \o_ |o_ \o_ _o_ _o/ _o| _o/}
    else
      ['.',' ']
  end
  
  ANIMATION_COUNTER[p] = 0 if !ANIMATION_COUNTER.key?(p)
  s = frames[ANIMATION_COUNTER[p]%frames.size]
  duration = ANIMATION_COUNTER[p].to_t
  ANIMATION_COUNTER[p] += 1
  return s
end

def bars; text_animation 'bars'; end
def gym; text_animation 'gym'; end
def gym_long; text_animation 'gym_long'; end

# puts "Testing animation".warn
# i = 0
# start = Time.now.to_i - 10800
# while i < 10
#   duration = Time.now - start
#   frame = bars
#   print "\r" + frame + " "*(WINDOW[0] - frame.length - duration.timesec.length) + duration.timesec
#   i += 1
#   sleep(0.5)
# end
# puts ""

def percentage_bar current, total, width=60
  bar = "|"
  bar += "="*((current.to_f/total)*width).round
  bar += ">"
  bar += " "*(width+2-bar.length)
  bar += "|"
  return "#{bar} #{"%3d\%" % (current*100/total)} "
end

# puts "Testing percetage bar".warn
# i = 1
# start = Time.now.to_i - 10800
# while i <= 150
#   duration = Time.now - start
#   print "\r" + percentage_bar(i, 150, WINDOW[0] - 17) + duration.timesec
#   i += 1
#   sleep(0.1)
# end
# puts ""

trap("INT") {
  print "\n\n"
  exit 128
}