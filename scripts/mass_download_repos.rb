#!/usr/bin/env ruby

require 'rubygems'
require 'mechanize'
require 'logger'
require 'nokogiri'
require 'open-uri'
require 'yaml'

def get_repos(group)
  group_page = @agent.get("https://code.locaweb.com.br/groups/#{group}")
  doc = Nokogiri::HTML(group_page.body)

  repos = []
  doc.xpath('//ul[@class="well-list"]/li[@class="project-row"]/a').each do |link|
    repos << link.attributes['href'].to_s.gsub(/^\//,'')
  end
  repos
end

def get_groups
  profile_page = @agent.get("https://code.locaweb.com.br/profile/groups")

  doc = Nokogiri::HTML(profile_page.body)

  groups = []
  doc.xpath('//ul[@class="well-list"]/li/a[@class="group-name"]').each do |link|
    groups << link.attributes['href'].to_s.gsub(/^\/groups\//,'')
  end
  groups
end


@agent = Mechanize.new # { |a| a.log = Logger.new(STDERR) }

config = YAML.load_file File.join(File.dirname(__FILE__), 'mass_download_repos_config.yml')

# login page
page = @agent.get("https://code.locaweb.com.br/users/sign_in")

# login
form = page.forms.first
form.username = config['auth']['username']
form.password = config['auth']['password']
page = form.submit form.buttons.first

groups_to_download = config['groups_from_gitlab'] ? get_groups : config['groups']

# loop through groups
groups_to_download.each do |group|
  puts "\e[30;43m Reading repos for group: " + group + " \e[0m"

  get_repos(group).each do |url|
    base_dir, repo = url.split('/')
    puts "\e[33m  " + repo + " \e[0m"

    # create the base dir if necessary
    # FileUtils.mkdir(base_dir) unless File.directory?(base_dir) || File.directory?(group)
    puts " - #{base_dir}" unless File.directory?(base_dir) || File.directory?(group)

    # clone the repo
    # `git clone git@code.locaweb.com.br:#{url}.git #{url}` unless File.directory?(url)
    puts "   - #{url}" unless File.directory?(url)
  end
  puts
end