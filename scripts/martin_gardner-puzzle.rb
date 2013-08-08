#!/usr/bin/env ruby

# Martin Gardner's Hardest Puzzle
# A number's persistence is the number of steps required to reduce
# it to a single digit by multiplying all its digits to obtain a
# second number, then multiplying all the digits of that number to
# obtain a third number, and so on until a one-digit number is
# obtained. For example, 77 has a persistence of four because it
# requires four steps to reduce it to one digit: 77-49-36-18-8.
# The smallest number of persistence one is 10, the smallest of
# persistence two is 25, the smallest of persistence three is 39,
# and the smaller of persistence four is 77. What is the smallest
# number of persistence five?

require "rubygems"
require "rspec"

n = 0
persistence = 0

def multiply_each_character number, step=1
  if number.to_s.size > 1
    result = number.to_s.each_char.map(&:to_i).reduce(:*)
    if result.to_s.size == 1
      step
    else
      multiply_each_character result, step+1
    end
  else
    0
  end
end

def persistence_calculator n
  multiply_each_character n
end

# while n += 1 do
#   new_persistence = persistence_calculator(n)
#   if new_persistence > persistence
#     puts "#{n} has a persistence of #{new_persistence}"
#     persistence = new_persistence
#   end
#   break if persistence >= 7
# end

describe "Martin Gardner's Puzzle" do
  it "The smallest number of persistence one is not 9" do
    persistence_calculator(9).should_not == 1
  end

  it "The smallest number of persistence one is 10" do
    persistence_calculator(10).should == 1
  end

  it "The smallest number of persistence two is not 24" do
    persistence_calculator(24).should_not == 2
  end

  it "The smallest number of persistence two is 25" do
    persistence_calculator(25).should == 2
  end

  it "The smallest number of persistence three is not 38" do
    persistence_calculator(38).should_not == 3
  end

  it "The smallest number of persistence three is 39" do
    persistence_calculator(39).should == 3
  end

  it "The smallest number of persistence four is not 76" do
    persistence_calculator(76).should_not == 4
  end

  it "The smallest number of persistence four is 77" do
    persistence_calculator(77).should == 4
  end

  it "The smallest number of persistence five is not 678" do
    persistence_calculator(678).should_not == 5
  end

  it "The smallest number of persistence five is 679" do
    persistence_calculator(679).should == 5
  end
end