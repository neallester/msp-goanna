note
	description: "Shared access to APPLICATION_CONFIGURATION"
	author: "Neal L Lester <neallester@users.sourceforge.net>"
	date: "$Date: 2007-03-29 07:17:01 -0800 (Thu, 29 Mar 2007) $"
	revision: "$Revision: 550 $"
	copyright: "(c) Neal L Lester"
	License: "Eiffel Forum License Version 2 (see forum.txt)"

class

	GOA_SHARED_APPLICATION_CONFIGURATION

feature

	configuration: APPLICATION_CONFIGURATION
			-- Application configuration
		once
			Result := active_configuration
		end

	active_configuration: APPLICATION_CONFIGURATION
			-- Configuration to use for this run

	touch_configuration
			-- Touch the configuration object to instantiate the once function
		require
			valid_active_configuration: active_configuration /= Void
		local
			a_string: STRING
		do
			a_string := configuration.log_directory
			a_string := configuration.temp_directory
			a_string := configuration.xslt_directory
		end

end -- class GOA_SHARED_APPLICATION_CONFIG
