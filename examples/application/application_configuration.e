indexing
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

	next_page (processing_result: REQUEST_PROCESSING_RESULT): GOA_DISPLAYABLE_SERVLET is
		do
			if processing_result.page_selected_servlet /= Void and then processing_result.page_selected_servlet.ok_to_display (processing_result) then
				Result := processing_result.page_selected_servlet
			elseif not processing_result.all_parameters_are_valid then
				Result ?= processing_result.processing_servlet
			end
			if Result /= Void then
				-- Do Nothing; we've already found the next page
			elseif answer_servlet.ok_to_display (processing_result) then
				Result := answer_servlet
			else
				Result := question_servlet
			end
		end

	port: INTEGER is 7878

feature

	internal_document_root: STRING is
		once
			Result := internal_data_directory
		end

	fast_cgi_directory: STRING is "/fastcgi/demo/"

	internal_test_mode: BOOLEAN is True

	validate_email_domain: BOOLEAN is False

	stylesheet: STRING is "goa_common.css"


	default_virtual_host_lookup_string: STRING is "localhost"

	internal_data_directory: STRING is "c:\examples\application\"

	bring_down_server_servlet_name: STRING is "uo98344noqpfjslak8392nowpg.htm"

end -- class APPLICATION_CONFIGURATION
