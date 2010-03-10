indexing
	description: "Results from processing a single parameter; PARAMETER_PROCESSING_RESULT should inherit from this class"
	author: "Neal L Lester <neallester@users.sourceforge.net>"
	date: "$Date: 2007-06-14 13:46:53 -0700 (Thu, 14 Jun 2007) $"
	revision: "$Revision: 579 $"
	copyright: "(c) Neal L Lester"
	License: "Eiffel Forum License Version 2 (see forum.txt)"

deferred class
	GOA_PARAMETER_PROCESSING_RESULT

inherit

	GOA_SHARED_APPLICATION_CONFIGURATION
	GOA_TEXT_PROCESSING_FACILITIES
	L4E_SHARED_HIERARCHY
	GOA_SHARED_REQUEST_PARAMETERS
	GOA_TRANSACTION_MANAGEMENT
	KL_IMPORTED_STRING_ROUTINES

feature

feature -- Attributes

	raw_parameter: STRING
			-- The raw parameter as received from the user

	parameter_name: STRING
			-- The name portion of the parameter; using the convention
			-- parameter_name:parameter (parameter_name is the name portion; parameter is the parameter portion)

	parameter_suffix: INTEGER
			-- The suffix portion of the raw_parameter, Void if none

	request_parameter: GOA_DEFERRED_PARAMETER is
			-- parameter associated with this result
		do
			Result := request_parameters.item (parameter_name)
		end

	value: STRING
			-- The value of the parameter

	is_value_valid: BOOLEAN is
			-- Was the value valid.  False generally indicates that an error message should be displayed
			-- To the user and that the form should be displayed again.
		do
			Result := error_message.is_empty
		end

	error_message: GOA_USER_ERROR_MESSAGE
			-- Error message (if any) generated from processing this parameter

	request_processing_result: REQUEST_PROCESSING_RESULT
			-- The processing result with which this parameter processing result is associated

	was_processed: BOOLEAN
			-- Has this parameter been processed?

	was_dependency_updated: BOOLEAN
			-- Did the request update a value upon which subsequent pages in the wizard may depend?

	was_updated: BOOLEAN
			-- Was the database updated when this parameter was processed?

	session_status: SESSION_STATUS is
			-- SESSION_STATUS associated with this parameter
		do
			Result := request_processing_result.session_status
		end

	processing_servlet: GOA_APPLICATION_SERVLET is
			-- The servlet that is processing this request
		do
			Result := request_processing_result.processing_servlet
		end

	request: GOA_HTTP_SERVLET_REQUEST is
			-- The request that is being processed
		do
			Result := request_processing_result.request
		end

	message_catalog: MESSAGE_CATALOG is
			-- The message catalog associated with the current session
		do
			Result := request_processing_result.message_catalog
		end

feature {GOA_REQUEST_PARAMETER} -- Database updating

	set_was_updated is
			-- Set database_was_updated =  True
		do
			was_updated := True
			request_processing_result.set_was_updated
		end

feature {GOA_DEFERRED_PARAMETER} -- Dependency Updating

	set_was_dependency_updated is
			-- Set updated_dependency to True
		obsolete
			"Application specific hack"
		do
			was_dependency_updated := True
			request_processing_result.set_was_dependency_updated
			set_was_updated
		end

feature {GOA_REQUEST_PROCESSING_RESULT} -- Processing

	process (the_parameter: PARAMETER_PROCESSING_RESULT) is
			-- Process the parameter
			-- Passing in the_parameter (which is a reference to current) allows us to pass this
			-- Object to the request_parameters with a type of PARAMETER_PROCESSING_RESULT
			-- Which gives the parameters access to any application specific extensions added to this class
		require
			the_parameter_is_current: the_parameter /= Void and then the_parameter = Current
			not_was_processed: not was_processed
			registered: request_processing_result.has_parameter_result (parameter_name, parameter_suffix)
		local
			is_suffix_valid: BOOLEAN
		do
			debug ("goa_parameter_processing_result")
				io.put_string ("Processing parameter: " + the_parameter.raw_parameter + "%N")
			end
			was_processed := True
			if request.has_parameter (raw_parameter) then
				value := request.get_parameter (raw_parameter)
			else
				value := ""
			end

			start_version_access (request_processing_result)
				is_suffix_valid := request_parameter.is_suffix_valid (request_processing_result, parameter_suffix)
			end_version_access (request_processing_result)
			if not processing_servlet.pass_through_parameters.has (request_parameter.name) and is_suffix_valid then
				request_parameter.process (the_parameter)
				if was_updated and then request_parameter.is_a_dependency then
					set_was_dependency_updated
				end
			elseif not is_suffix_valid then
				log_hierarchy.logger (configuration.application_log_category).info ("Parameter: " + request_parameter.name + "; Invalid Suffix: " + parameter_suffix.out)
			end
		ensure
			was_processed: was_processed
		end



feature {NONE} -- Creation

	make (new_raw_parameter: STRING; new_processing_result: REQUEST_PROCESSING_RESULT) is
			-- Creation
		require
			valid_new_raw_parameter: new_raw_parameter /= Void and then not new_raw_parameter.is_empty and then request_parameters.has (name_from_raw_parameter (new_raw_parameter.as_lower))
			valid_new_processing_result: new_processing_result /= Void
		do
			raw_parameter := STRING_.cloned_string (new_raw_parameter)
			raw_parameter.to_lower
			if not raw_parameter.is_empty then
				parameter_name := name_from_raw_parameter (raw_parameter)
				parameter_suffix := suffix_from_raw_parameter (raw_parameter)
			else
				parameter_name := ""
			end
			value := ""
			create error_message.make_with_processing_result (new_processing_result)
			request_processing_result := new_processing_result
		ensure
			raw_parameter_name: not raw_parameter.is_empty implies equal (raw_parameter, new_raw_parameter.as_lower)
		end

invariant

	is_value_valid: value /= Void
	valid_error_message: error_message /= Void
	valid_request_processing_reuslt: request_processing_result /= Void
	valid_parameter_name: not parameter_name.is_empty implies equal (parameter_name, name_from_raw_parameter (raw_parameter))
	valid_parameter_suffix: equal (parameter_suffix, suffix_from_raw_parameter (raw_parameter))
	is_value_valid_implies_empty_error_message: is_value_valid implies error_message.is_empty
	not_is_value_valid_implies_not_empty_error_message: not is_value_valid implies not error_message.is_empty
	not_is_value_valid_implies_not_processing_result_all_parameter_valid: not is_value_valid implies not request_processing_result.all_parameters_are_valid
	was_updated_implies_request_updated: was_updated implies request_processing_result.was_updated

end -- class GOA_PARAMETER_PROCESSING_RESULT
