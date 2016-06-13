#
# Cookbook Name:: hubot-windows
# Recipe:: package_provider
#
# Copyright (C) 2016 defi SOLUTIONS
#
# All rights reserved - Do Not Redistribute
#

powershell_script 'Install Nuget provider' do
	code <<-EOH
  	Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force
    $date = Get-Date
  	add-content c:\output.txt "Ran Install Nuget Provider at $date"
	EOH
  not_if <<-EOH
    (Get-PackageProvider nuget -ErrorAction SilentlyContinue -WarningAction SilentlyContinue).Version -ge [version]'2.8.5.201'
	EOH
end

# The following is a hack. The moment you call into the package provider it sets a flag in the registry
# indicating there are 'PendingFileRenameOperations'. The file renames appear to happen for temp files
# used by the package provider. See: https://github.com/OneGet/oneget/issues/179
#
# The workaround is to check the PendingFileRenameOperations to see if they are all due
# to the package provider, if so delete the reg value.
hubot_windows_reboot_helper 'Attempt to clear pending file renames reg entry' do
	ignored_pending_file_renames node['hubot-windows']['ignored_pending_file_renames']
	action :clear_pending_file_renames
end
