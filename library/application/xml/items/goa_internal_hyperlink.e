note
	description: "A hyperlink to a servlet on this website"
	author: "Neal L Lester <neallester@users.sourceforge.net>"
	date: "$Date: 2006-04-16 23:42:40 -0700 (Sun, 16 Apr 2006) $"
	revision: "$Revision: 491 $"
	copyright: "(c) Neal L Lester"
	License: "Eiffel Forum License Version 2 (see forum.txt)"

class
	GOA_INTERNAL_HYPERLINK

inherit
	GOA_HYPERLINK
	GOA_SHARED_APPLICATION_CONFIGURATION
	SHARED_SERVLETS
	SHARED_REQUEST_PARAMETERS
	KL_IMPORTED_STRING_ROUTINES
	
create
	
	make
	
feature {NONE} -- Creation

	make (processing_result: REQUEST_PROCESSING_RESULT; servlet: GOA_APPLICATION_SERVLET; new_text: STRING)
		require
			valid_processing_result: processing_result /= Void
			valid_servlet: servlet /= Void
			valid_new_text: new_text /= Void
		do
			initialize
			text := STRING_.cloned_string (new_text)
			host_and_path := STRING_.cloned_string (processing_result.session_status.virtual_domain_host.host_name)
			host_and_path.append (configuration.fast_cgi_directory)
			host_and_path.append (STRING_.cloned_string (go_to_servlet.name))
			add_parameter (page_parameter.name, servlet.name_without_extension)
			if processing_result.session_status.virtual_domain_host.use_ssl and servlet.receive_secure then
				set_secure
			end
		end

end -- class GOA_INTERNAL_HYPERLINK
