note
	description: "Configuration Settings for the Application"
	author: "Neal L. Lester <neallester@users.sourceforge.net>"
	date: "$Date: 2007-10-19 07:43:06 -0700 (Fri, 19 Oct 2007) $"
	revision: "$Revision: 596 $"
	copyright: "(c) 2005 Neal L. Lester and others"
	License: "Eiffel Forum License Version 2 (see forum.txt)"

class
	APPLICATION_CONFIGURATION

inherit

	GOA_APPLICATION_CONFIGURATION
	GOA_NON_DATABASE_ACCESS_TRANSACTION_MANAGEMENT
	KL_SHARED_EXECUTION_ENVIRONMENT

feature -- Page Sequencing

	next_page (processing_result: REQUEST_PROCESSING_RESULT): GOA_DISPLAYABLE_SERVLET
		do
		end

	port: INTEGER = 7878

feature

	internal_document_root: STRING
		once
			Result := internal_data_directory
		end

	fast_cgi_directory: STRING = "/fastcgi/test/"

	internal_test_mode: BOOLEAN = True

	validate_email_domain: BOOLEAN = False

--	stylesheet: STRING is "goa_common.css"


	default_virtual_host_lookup_string: STRING = "localhost"

	internal_data_directory: STRING = "c:\examples\application\"

	bring_down_server_servlet_name: STRING = "uo98344noqpfjslak8392nowpg.htm"

end -- class APPLICATION_CONFIGURATION
