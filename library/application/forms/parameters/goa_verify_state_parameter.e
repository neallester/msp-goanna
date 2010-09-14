note
	description: "Verify a current state matches state when html form was generated"
	author: "Neal L Lester <neallester@users.sourceforge.net>"
	date: "$Date: 2006-07-27 22:10:14 -0700 (Thu, 27 Jul 2006) $"
	revision: "$Revision: 508 $"
	copyright: "(c) Neal L Lester"
	License: "Eiffel Forum License Version 2 (see forum.txt)"
	
-- Used to verify a server side state remains unchanged between between generation of form by server and
-- posting of form by client.  Describe state in current_value.  For example, a user logged in as
-- user1 could request an account maintenance form, log out, log in as user2, and then
-- use their back button to return to the user1 account maintenance form and submit it, posting user1
-- account information to the user2 account.  To prevent this, add a descendent of this class to the form
-- which includes the login id as current_value
-- Generally, this parameter should be added to the "mandatory_parameters" of a servlet

deferred class

	GOA_VERIFY_STATE_PARAMETER

inherit
	
	GOA_HIDDEN_PARAMETER

feature
	
	process (processing_result: PARAMETER_PROCESSING_RESULT)
			-- Process the paramter
		local
			value, message: STRING
			session_status: SESSION_STATUS
		do
			value := processing_result.value
			session_status := processing_result.session_status
			start_transaction (processing_result.request_processing_result)
				if not equal (expected_value (processing_result.request_processing_result, processing_result.parameter_suffix), value) then
					processing_result.error_message.add_message ("Bad " + name + " Value")
					message := bad_value_message (processing_result.request_processing_result)
					if session_status.has_served_a_page and then message /= Void and then not message.is_empty then
						session_status.user_message.add_message (bad_value_message (processing_result.request_processing_result))
						log_hierarchy.logger (configuration.application_security_log_category).info ("Bad " + name + " Value: " + processing_result.value + "; " + processing_result.processing_servlet.client_info (processing_result.request))
					end
				end
			commit (processing_result.request_processing_result)
		end		
		
	bad_value_message (processing_result: REQUEST_PROCESSING_RESULT): STRING
			-- The message to add to the SESSION_STATUS.user_message if current_value in request form doesn't
			-- match current_value on the server
		require
			valid_processing_result: processing_result /= Void
		deferred
		ensure
			valid_result: Result /= Void
		end
		
	expected_value (processing_result: REQUEST_PROCESSING_RESULT; suffix: INTEGER): STRING
			-- The value of this parameter that is expected in the response from the user
		do
			Result := current_value (processing_result, suffix)
		end
		
		
end -- class GOA_VERIFY_STATE_PARAMETER
