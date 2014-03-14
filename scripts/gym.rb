#!/usr/bin/env ruby
# require "~/dotfiles/scripts/util.rb"
require "~/dotfiles/scripts/integer_class.rb"
require "~/dotfiles/scripts/time_class.rb"
trap("INT") {
  print "\n\n"
  exit 128
}

# text animation
ANIMATION_COUNTER = {}
def text_animation p
  frames = case p
    when 'bars'
      %w{/ - \ |}
    when 'gym'
      %w{_o_ \o/ |o| \o/}
    when 'gym_long'
      %w{_o_ \o/ |o| \o/ _o_ \o_ |o_ \o_ <o_ \o_ _o_ _o/ _o| _o/ _o> _o/}
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
i = 0
start = Time.now.to_i - 10800
while i < 15*2
  duration = Time.now - start
  frame = gym_long
  print "\r" + frame + " "*(125 - frame.length - duration.timesec.length) + duration.timesec
  i += 1
  sleep(0.5)
end
puts ""

