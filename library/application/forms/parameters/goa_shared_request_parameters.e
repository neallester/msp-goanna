note
	description: "Shared access to request parameters; SHARED_REQUEST_PARAMETERS should inherit from this class"
	author: "Neal L Lester <neallester@users.sourceforge.net>"
	date: "$Date: 2006-04-16 23:42:40 -0700 (Sun, 16 Apr 2006) $"
	revision: "$Revision: 491 $"
	copyright: "(c) Neal L Lester"
	License: "Eiffel Forum License Version 2 (see forum.txt)"

deferred class

	GOA_SHARED_REQUEST_PARAMETERS
	
feature -- Parameters

	standard_submit_parameter: GOA_STANDARD_SUBMIT_PARAMETER
			-- Submit parameter that may be used in all html forms
		once
			create Result.make
		end
		
	page_parameter: GOA_PAGE_PARAMETER
			-- Parameter used to provide direct hyperlinks to a servlet
		once
			create Result.make
		end
		
	request_parameter_for_name (the_name: STRING): GOA_DEFERRED_PARAMETER
			-- The request parameter with the_name
		require
			valid_name: the_name /= Void and then not the_name.is_empty
			name_exists: parameter_name_is_registered (the_name)
		do
			Result := request_parameters.item (the_name)
		end
		
	parameter_name_is_registered (the_name: STRING): BOOLEAN
			-- Does the_name belong to a registered request parameter?
		require
			valid_name: the_name /= Void and then not the_name.is_empty
		do
			Result := request_parameters.has (the_name)
		end
		

feature {NONE} -- Implementation
	
	request_parameters: DS_HASH_TABLE [GOA_DEFERRED_PARAMETER, STRING]
			-- form parameters, indexed by parameter_name
		once
			create Result.make_equal (50)
		end

invariant
	
	valid_request_parameters: request_parameters /= Void

end -- class GOA_SHARED_REQUEST_PARAMETERS
