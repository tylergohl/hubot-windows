#
# Cookbook Name:: hubot-windows
# Recipe:: ps_modules
#
# Copyright (C) 2016 defi SOLUTIONS
#
# All rights reserved - Do Not Redistribute
#

powershell_script 'Install PoshHubot Module' do
	code <<-EOH
	Install-Module PoshHubot -Force
	EOH
	not_if <<-EOH
		(Get-Module -ListAvailable PoshHubot).Version -ge [version]'1.0.2' -eq $True
	EOH
end

powershell_script 'Import PoshHubot Module' do
	code <<-EOH
	Import-Module PoshHubot
	EOH
	not_if <<-EOH
		(Get-Module PoshHubot).Version -ge [version]'1.0.2' -eq $True
	EOH
end