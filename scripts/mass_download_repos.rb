#!/usr/bin/env ruby

require 'rubygems'
require 'mechanize'
require 'logger'
require 'nokogiri'
require 'open-uri'
require 'yaml'

def get_repos(group)
  group_page = @agent.get("http://#{URL}/groups/#{group}")
  doc = Nokogiri::HTML(group_page.body)

  repos = []
  doc.xpath('//ul[@class="well-list"]/li[@class="project-row"]/a').each do |link|
    repos << link.attributes['href'].to_s.gsub(/^\//,'')
  end
  repos
end

def get_groups
  #profile_page = @agent.get("http://#{URL}/profile/groups")
  profile_page = @agent.get("http://#{URL}")

  doc = Nokogiri::HTML(profile_page.body)

  #puts doc.xpath('//ul[@class="well-list dash-list"]/li[@class="group-row"]/a').inspect

  groups = []
  #doc.xpath('//ul[@class="well-list"]/li/a[@class="group-name"]').each do |link|
  doc.xpath('//ul[@class="well-list dash-list"]/li[@class="group-row"]/a').each do |link|
    groups << link.attributes['href'].to_s.gsub(/^\/groups\//,'')
  end
  groups
end


@agent = Mechanize.new # { |a| a.log = Logger.new(STDERR) }

config = YAML.load_file File.join(File.dirname(__FILE__), 'mass_download_repos_config.yml')

URL = config['url']

# login page
page = @agent.get("http://#{URL}/users/sign_in")

# login
form = page.forms.first
form.username = config['auth']['username']
form.password = config['auth']['password']
page = form.submit form.buttons.first

groups_to_download = config['groups_from_gitlab'] ? get_groups : config['groups']

# loop through groups
all_repos = []
groups_to_download.each.with_index(1) do |group, g_index|
  puts "\e[30;43m #{"%03d" % g_index}/#{"%03d" % groups_to_download.size} - Reading repos from group: #{group} \e[0m"
  repos = get_repos(group)
  all_repos.concat repos
  puts "   found #{repos.size} repositories in this group."
end
puts "found #{all_repos.size} repositories to work with."

puts "\e[30;43m Reading repositories from a list of #{all_repos.size} \e[0m"
all_repos.each.with_index(1) do |url, r_index|
  base_dir, repo = url.split('/')
  puts "\e[33m  #{"%03d" % r_index}/#{"%03d" % all_repos.size} - #{repo} \e[0m"

  # create the base dir if necessary
  FileUtils.mkdir(base_dir) unless File.directory?(base_dir)

  # clone the repo
  if File.directory?(url)
    puts "skipping #{url}, directory exists."
  else
    `git clone git@#{URL}:#{url}.git #{url}`
  end
end
puts
