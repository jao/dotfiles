#/usr/bin/env ruby

# rename and copy files to the proper directories
# from FILES_ORIG

require 'ftools'

filename = 'game.csv'
file = File.new(filename, 'r')

@phones = []

file.each_line do |row|
  from, phonemodels = row.split(";")
  from.gsub!(/\"|\.zip/,'')
  phonemodels.gsub!(/\"/,'')
  phonemodels = phonemodels.chomp.split(',')
  pmodel = phonemodels.first.gsub(/ +.+$/,'')
  phonemodels.map!{|pm|
    pm = "#{pmodel} #{pm}" if pm !~ /#{pmodel}/i
    pm.gsub(/\s+/,' ')
  }
  @phones << {:from => from, :models => phonemodels.compact}
end

puts ""
@phones.each do |phone|
  fromdir = phone[:from]
  if File.directory?("FILES_ORIG/#{fromdir}/") && fromdir.length > 0
    puts "Working with #{fromdir} -> #{phone[:from]}"
    phone[:models].each do |model|
      todir = "FILES/#{model}"
      puts todir
      Dir.mkdir(todir) unless File.directory?(todir)
      `cp 'FILES_ORIG/#{fromdir}/#{fromdir}.jad' '#{todir}/'`
      `cp 'FILES_ORIG/#{fromdir}/#{fromdir}.jar' '#{todir}/'`
      `ls FILES_ORIG/#{fromdir}`
    end
  end
end