#
# Cookbook Name:: hubot-windows
# Recipe:: default
#
# Copyright (C) 2016 T.J. Gohl
#
# All rights reserved - Do Not Redistribute
#

include_recipe 'chocolatey'

reboot 'Restart Computer' do
  action :nothing
end

chocolatey_package 'powershell' do
	notifies :reboot_now, 'reboot[Restart Computer]', :immediately
	version '5.0.10586.20151218'
end

chocolatey_package 'git.install' do
	options '--params="\'/NoAutoCrlf\'"'
end
