indexing

class GOA_HTTPD_LOGGER

inherit

	L4E_PRIORITY_CONSTANTS
		export
			{NONE} all
		end

	KL_SHARED_ARGUMENTS
		export
			{NONE} all
		end

feature -- Access

	log_hierarchy: L4E_HIERARCHY is
			-- Shared log hierarchy with predefined
			-- categories for HTTPD server logging
		local
			appender: L4E_APPENDER
			layout: L4E_LAYOUT
		once
			create Result.make (Debug_p)
			create {L4E_FILE_APPENDER} appender.make (Application_log, True)
			create {L4E_PATTERN_LAYOUT} layout.make ("@d [@-6p] @c - @m%N")
			appender.set_layout (layout)
			Result.root.add_appender (appender)
		end

	set_custom_log_file (log_file: STRING) is
			-- Sets a custom log file, where log_file must be the complete path + name.
			-- This must be set before the logger is used for the first time otherwise
			-- the default log file is used.
		require
			not_void: log_file /= Void
			not_empty: log_file.count > 0
		do
			custom_log_file := log_file
		end

feature {NONE} -- Implementation

	Internal_category: STRING is "httpd.internal"

	Access_category: STRING is "httpd.access"

	custom_log_file: STRING
			-- Complete custom log file path e.g. /home/apps/myapp/errors.log

	Application_log: STRING is
			-- Construct application log from system name and ".log" extension.
			-- Any leading path and extension will be removed. eg. The log file
			-- for 'd:\dev\httpd.exe' will be 'httpd.log' not 'd:\dev\httpd.exe.log'
		local
			app_name: STRING
--			p: INTEGER
		once
			if (custom_log_file /= Void) then
					-- custom log file name
				Result := custom_log_file
			else
					-- default log file name
				app_name := (Arguments.argument (0)).twin
	-- Commented out for SmallEiffel support			
	--			p := app_name.last_index_of ('.', app_name.count)
	--			if p > 0 then
	--				app_name := app_name.substring (1, p - 1)
	--			end
				create Result.make (app_name.count + 4)
				Result.append (app_name)
				Result.append (".log")
			end
		end

end -- class GOA_HTTPD_LOGGER
