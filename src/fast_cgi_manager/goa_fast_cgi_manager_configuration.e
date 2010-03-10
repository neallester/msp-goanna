indexing
	description: "Configuration of this instance of the fast_cgi_manager"
	author: "Neal Lester"
	date: "$Date$"
	revision: "$Revision$"

class

	GOA_FAST_CGI_MANAGER_CONFIGURATION

inherit

	KL_SHARED_OPERATING_SYSTEM

feature -- Configuration File

	default_configuration_file_name: STRING is "fast_cgi_manager.cfg"

	default_configuration_file_location: STRING is
		once
			if operating_system.is_unix then
				Result := "/etc/"
			else
				Result := "c:\"
			end
		end

	default_full_configuration_file_name: STRING is
			-- The full path to the configuration file
		once
			Result := default_configuration_file_location + default_configuration_file_name
		end




end
