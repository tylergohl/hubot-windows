#
# Cookbook Name:: hubot-windows
# Recipe:: default
#
# Copyright (C) 2016 defi SOLUTIONS
#
# All rights reserved - Do Not Redistribute
#

include_recipe 'hubot-windows::chocolatey_packages'
include_recipe 'hubot-windows::package_provider'
include_recipe 'hubot-windows::ps_modules'