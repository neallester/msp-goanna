indexing
	description: "The results of processing a request from the user; REQUEST_PROCESSING_RESULT should inherit from this class"
	author: "Neal L Lester <neallester@users.sourceforge.net>"
	date: "$Date: 2009-12-23 16:16:29 -0800 (Wed, 23 Dec 2009) $"
	revision: "$Revision: 623 $"
	copyright: "(c) Neal L Lester"
	License: "Eiffel Forum License Version 2 (see forum.txt)"

deferred class
	GOA_REQUEST_PROCESSING_RESULT

inherit

	GOA_SHARED_APPLICATION_CONFIGURATION
	GOA_TEXT_PROCESSING_FACILITIES
	GOA_SHARED_REQUEST_PARAMETERS

feature -- Attributes

	request: GOA_HTTP_SERVLET_REQUEST
			-- The request that was processed

	response: GOA_HTTP_SERVLET_RESPONSE
			-- The response that Goanna provided with the request

	session_status: SESSION_STATUS
			-- Session status associated with the request

	message_catalog: MESSAGE_CATALOG is
			-- Message catalog for this user
		do
			Result := session_status.message_catalog
		end

	processing_servlet: GOA_APPLICATION_SERVLET
			-- The servlet that is processing the request that generated this result

	generating_servlet: GOA_DISPLAYABLE_SERVLET
			-- The servlet that is generating the next page that will be displayed to the user

	virtual_domain_host: VIRTUAL_DOMAIN_HOST is
		do
			Result := session_status.virtual_domain_host
		end


	all_input_was_valid: BOOLEAN is
			-- Was all input received during the request valid?
		require
			was_processed: was_processed
		do
			Result := all_parameters_are_valid and final_processing_was_valid
		end

	was_processed: BOOLEAN
			-- This request has been processed

	was_updated: BOOLEAN
			-- Did any of the parameters update the data model?

	final_processing_was_valid: BOOLEAN
			-- Post processing (performed by the servlet) indicates request is valid

	all_mandatory_parameters_are_valid: BOOLEAN
			-- Are all mandatory parameters valid?

	is_generating_response: BOOLEAN is
			-- Is this processing result currently being used to generate a response to the user
			-- False during initial processing of request from user
		do
			Result := generating_servlet /= Void
		end

	ok_to_retry_process_parameters: BOOLEAN is
			-- Is it ok to retry parameter processing; may be redefined by descendents if required
			-- In general it should be OK, but if for example a parameter triggers credit card processing
			-- We may not want to retry in event of a fault (for fear of processing a card twice)
		once
			Result := True
		end

	has_parameter_name (name: STRING): BOOLEAN is
			-- Does this result include a parameter with name?
		require
			valid_name: name /= Void and not name.is_empty
		do
			Result := parameter_names.has (name)
		end

	has_parameter_result (name: STRING; suffix: INTEGER): BOOLEAN is
			-- Does this processing result include a result for name:suffix
			-- Use 0 if no suffix
		require
			valid_name: name /= Void and not name.is_empty
		do
			Result := parameter_processing_results.has (full_parameter_name (name, suffix))
		end

	parameter_processing_result (name: STRING; suffix: INTEGER): PARAMETER_PROCESSING_RESULT is
			-- Processing result for parameter with name:suffix
			-- Use 0 if no suffix
		require
			valid_name: name /= Void and not name.is_empty
		do
			if has_parameter_result (name, suffix) then
				Result := parameter_processing_results.item (full_parameter_name (name, suffix))
			end
		end

	parameter_value (name: STRING; suffix: INTEGER): STRING is
			-- Value of parameter with name:suffix
			-- Returns empty string if no such parameter in the request
			-- Use 0 if no suffix
		require
			valid_name: name /= Void and not name.is_empty
		local
			the_processing_result: PARAMETER_PROCESSING_RESULT
		do
			the_processing_result := parameter_processing_results.item (full_parameter_name (name, suffix))
			if the_processing_result /= Void then
				Result := the_processing_result.value
			else
				Result := ""
			end
		ensure
			valid_result: Result /= Void
		end

	page_selected_servlet: GOA_DISPLAYABLE_SERVLET
			-- Servlet set by the GOA_PAGE_PARAMETER, if any

	all_parameters_are_valid: BOOLEAN
			-- Are the indicated parameters all valid?

feature {GOA_APPLICATION_SERVLET, GOA_PARAMETER_PROCESSING_RESULT, GOA_REQUEST_PARAMETER} -- Processing

	process_parameters is
			-- Process the request
		require
			not_was_processed: not was_processed
		do
			was_processed := True
			sorter.sort (mandatory_processing_results)
			debug ("goa_request_processing_result")
				io.put_string ("Non Mandatory Parameters Before Sorting:%N")
				from
					non_mandatory_processing_results.start
				until
					non_mandatory_processing_results.after
				loop
					io.put_string (non_mandatory_processing_results.item_for_iteration.raw_parameter + "%N")
					non_mandatory_processing_results.forth
				end
			end
			sorter.sort (non_mandatory_processing_results)
			debug ("goa_request_processing_result")
				io.put_string ("Non Mandatory Parameters After Sorting:%N")
				from
					non_mandatory_processing_results.start
				until
					non_mandatory_processing_results.after
				loop
					io.put_string (non_mandatory_processing_results.item_for_iteration.raw_parameter + "%N")
					non_mandatory_processing_results.forth
				end
			end
			from
				mandatory_processing_results.start
				all_mandatory_parameters_are_valid := True
			until
				not all_mandatory_parameters_are_valid or mandatory_processing_results.after
			loop
				if not mandatory_processing_results.item_for_iteration.was_processed then
					-- Process if it hasn't already been processed, and if it is not a pass-through parameter
					mandatory_processing_results.item_for_iteration.process	(mandatory_processing_results.item_for_iteration)
				end
				all_mandatory_parameters_are_valid := all_mandatory_parameters_are_valid and mandatory_processing_results.item_for_iteration.is_value_valid
				mandatory_processing_results.forth
			end
			if all_mandatory_parameters_are_valid then
				-- Process the rest of the parameters in the form
				processing_servlet.perform_post_mandatory_parameter_processing (Current)
				from
					non_mandatory_processing_results.start
				until
					non_mandatory_processing_results.after
				loop
					if not non_mandatory_processing_results.item_for_iteration.was_processed then
						-- Process if it hasn't already been processed, and if it is not a pass-through parameter
						non_mandatory_processing_results.item_for_iteration.process (non_mandatory_processing_results.item_for_iteration)
					end
					non_mandatory_processing_results.forth
				end
			end
		ensure
			was_processed: was_processed
		end

	process_submit_parameter_if_present is
			-- Process the submit parameter, if one is present
		local
			submit_processing_result: PARAMETER_PROCESSING_RESULT
		do
			submit_processing_result := parameter_processing_result (standard_submit_parameter.name, 0)
			if submit_processing_result /= Void then
				submit_processing_result.process (submit_processing_result)
			end
			was_processed := True
		ensure
			was_processed: was_processed
		end

	set_final_processing_valid is
			-- Post processing (in the servlet) completed successfully; the request is fully validated
		do
			final_processing_was_valid := True
		end

	add_parameter_processing_result (processing_result: PARAMETER_PROCESSING_RESULT; is_mandatory: BOOLEAN) is
			-- Add processing_result to parameter_processing_results
		require
			valid_processing_result: processing_result/= Void
		local
			new_raw_parameter_name, new_name: STRING
			new_suffix: INTEGER
		do
			new_name := processing_result.parameter_name
			new_suffix := processing_result.parameter_suffix
			parameter_names.force_last (new_name)
			new_raw_parameter_name := full_parameter_name (new_name, new_suffix)
			parameter_processing_results.force (processing_result, new_raw_parameter_name)
			if is_mandatory then
				mandatory_processing_results.force_last (processing_result)
			else
				non_mandatory_processing_results.force_last (processing_result)
			end
		end

	set_page_selected_servlet (the_servlet: GOA_DISPLAYABLE_SERVLET) is
		do
			page_selected_servlet := the_servlet
		end

	set_was_updated is
		do
			was_updated := True
		ensure
			was_updated: was_updated
		end


feature {GOA_USER_ERROR_MESSAGE} -- Parameter Validity

	set_not_all_parameters_are_valid is
		do
			all_parameters_are_valid := False
		ensure
			not_all_parameters_are_valid: not all_parameters_are_valid
		end

feature {GOA_APPLICATION_SERVLET} -- Generating Servlet

	set_generating_servlet (new_generating_servlet: GOA_DISPLAYABLE_SERVLET) is
			-- Set generating_servlet to new_generating_servlet
		do
			generating_servlet := new_generating_servlet
		ensure
			generating_servlet_updated: generating_servlet = new_generating_servlet
		end


feature {NONE} -- Creation

	make (new_request: GOA_HTTP_SERVLET_REQUEST; new_response: GOA_HTTP_SERVLET_RESPONSE; new_session_status: SESSION_STATUS; new_processing_servlet: GOA_APPLICATION_SERVLET) is
			-- Creation
		require
			valid_new_request: new_request /= Void
			valid_new_response: new_response /= Void
			valid_new_session_status: new_session_status /= Void
			valid_new_processing_servlet: new_processing_servlet /= Void
			session_status_belongs_to_request: new_request.session.get_attribute (configuration.session_status_attribute_name) = new_session_status
		do
			all_parameters_are_valid := True
			request := new_request
			response := new_response
			session_status := new_session_status
			processing_servlet := new_processing_servlet
			create parameter_processing_results.make_equal (15)
			create mandatory_processing_results.make
			create non_mandatory_processing_results.make
			create parameter_names.make_equal
			create error_messages_displayed.make_equal
		ensure
			all_parameters_are_valid: all_parameters_are_valid
			request_updated: request = new_request
			response_updated: response = new_response
			session_status_updated: session_status = new_session_status
		end

feature {GOA_PARAMETER_PROCESSING_RESULT, GOA_APPLICATION_SERVLET} -- Implementation

feature {NONE} -- Implementation

	sorter: DS_QUICK_SORTER [GOA_PARAMETER_PROCESSING_RESULT] is
			-- Sorter that can sort parameter processing_result containers
		once
			create Result.make (comparator)
		end

	comparator: GOA_PARAMETER_PROCESSING_RESULT_COMPARATOR is
			-- Comparator used for sorting GOA_PARAMETER_PROCESSING_RESULTS
		once
			create Result
		end

	parameter_processing_results: DS_HASH_TABLE [PARAMETER_PROCESSING_RESULT, STRING]
			-- Parameter processing results for this request; indexed by raw processor

	mandatory_processing_results: DS_LINKED_LIST [PARAMETER_PROCESSING_RESULT]
	non_mandatory_processing_results: DS_LINKED_LIST [PARAMETER_PROCESSING_RESULT]
			-- Mandatory and non-mandatory processing results

	parameter_names: DS_LINKED_LIST [STRING]
			-- The names of all parameters registered in this result

	error_messages_displayed: DS_LINKED_LIST [STRING]
			-- List of parameters for which error messages have been displayed

feature -- Obsolete

	was_dependency_updated: BOOLEAN
			-- Did the request update a value upon which subsequent pages in the wizard may depend?

	set_was_dependency_updated is
			-- Set updated_dependency to True
		obsolete
			"Application specific hack"
		do
			was_dependency_updated := True
		end


invariant

	valid_request: request /= Void
	valid_response: response /= Void
	valid_session_status: session_status /= Void
	valid_servlet: processing_servlet /= Void
	valid_mandatory_processing_results: mandatory_processing_results /= Void
	valid_non_mandatory_processing_results: non_mandatory_processing_results /= Void
	valid_parameter_processing_results: parameter_processing_results /= Void
	valid_parameter_names: parameter_names /= Void
	valid_error_messages_displayed: error_messages_displayed /= Void

end -- class GOA_REQUEST_PROCESSING_RESULT
