#!/usr/bin/env ruby

require 'rubygems'
require 'mechanize'
require 'logger'
require 'nokogiri'
require 'open-uri'
require 'yaml'


agent = Mechanize.new

page = agent.get("https://code.locaweb.com.br/users/sign_in")

form = page.forms.first

config = YAML.load_file File.join(File.dirname(__FILE__), 'mass_download_repos_config.yml')

form.username = config['auth']['username']
form.password = config['auth']['password']
page = form.submit form.buttons.first

config['groups'].each do |group|
  puts "\e[30;43m Reading repos for group: " + group + " \e[0m"
  group_page = agent.get("https://code.locaweb.com.br/groups/#{group}")

  doc = Nokogiri::HTML(group_page.body)

  doc.xpath('//ul[@class="well-list"]/li[@class="project-row"]/a').each do | link |
    url = link.attributes['href'].to_s.gsub(/^\//,'')
    base_dir, repo = url.split('/')
    puts "\e[33m  " + repo + " \e[0m"

    # create the base dir if necessary
    FileUtils.mkdir(base_dir) unless File.directory?(base_dir) || File.directory?(group)

    # clone the repo
    `git clone git@code.locaweb.com.br:#{url}.git #{url}` unless File.directory?(url)
  end
  puts
end