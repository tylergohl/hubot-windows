#
# Cookbook Name:: hubot-windows
# Resource:: reboot_helper
#
# Copyright (C) 2016 defi SOLUTIONS
#
# All rights reserved - Do Not Redistribute
#

property :ignored_pending_file_renames, Array, default: ['']

action :clear_pending_file_renames do
	Chef::Log.info("Attempting to clear the pending file rename registry entry for: #{ignored_pending_file_renames}")

  session_mgr_regkey_name = 'HKLM\SYSTEM\CurrentControlSet\Control\Session Manager'
  session_mgr_regvalue_name = 'PendingFileRenameOperations'

  registry_key session_mgr_regkey_name do
    values [{
      :name => session_mgr_regvalue_name,
      :type => :multi_string,
      :data => ['']
      }]
    action :delete
    only_if do
      registry_value_exists?(session_mgr_regkey_name, { :name => session_mgr_regvalue_name })
    end
    only_if do
      # get all the reg key values:
      session_mgr_regkey = registry_get_values(session_mgr_regkey_name)

      # get the PendingFileRenameOperations reg value
      pending_file_renames_regvalue = session_mgr_regkey.select { |value| value[:name] ==  session_mgr_regvalue_name}[0]

      # get the pending file rename values (if exists)
      pending_file_renames = pending_file_renames_regvalue ? pending_file_renames_regvalue[:data] : ['']
      pending_file_renames = pending_file_renames.reject { |item| item.empty? } # remove all the empty elements

      # get the pending file rename values
      ignored_file_renames = pending_file_renames.select {
  			|file_path| ignored_pending_file_renames.any? { |file_name_part| file_path.downcase.include? file_name_part }
  		}

      if pending_file_renames.count > 0 && ignored_file_renames.count == pending_file_renames.count
        Chef::Log.info('Performing clean-up on PendingFileRenameOperations registry value')
        true
      else
        Chef::Log.info("PendingFileRenameOperations value could not be retrieved or unexpected values existed: #{pending_file_renames_regvalue}")
        false
      end
    end
  end
end
