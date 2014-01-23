#!/usr/bin/env ruby

require 'rubygems'
require 'mechanize'
require 'logger'
require 'nokogiri'
require 'open-uri'
require 'yaml'


agent = Mechanize.new { |a| a.log = Logger.new(STDERR) }

page = agent.get("https://code.locaweb.com.br/users/sign_in")

form = page.forms.first

config = YAML.load_file File.join(File.dirname(__FILE__), 'mass_download_repos_config.yml')

form.username = config['auth']['username']
form.password = config['auth']['password']
page = form.submit form.buttons.first

['saas','paas'].each do |group|
  puts "\e[1;30;43m Reading repos for group: " + group + " \e[0m"
  group_page = agent.get("https://code.locaweb.com.br/groups/#{group}")

  doc = Nokogiri::HTML(group_page.body)

  doc.xpath('//ul[@class="well-list"]/li[@class="project-row"]/a').each do | link |
    url = link.attributes['href'].to_s
    puts "\e[33m  " + url.gsub!(/^\//,'') + " \e[0m"

    base_dir, repo = url.split('/')

    # create the base dir if necessary
    FileUtils.mkdir(base_dir) unless File.directory?(base_dir) || File.directory?(group)

    # clone the repo
    puts `git clone git@code.locaweb.com.br:#{url}.git #{url}` unless File.directory?(url)
  end
end