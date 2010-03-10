indexing
	description: "SOAP fault constants and utility routines"
	project: "Project Goanna <http://sourceforge.net/projects/goanna>"
	library: "SOAP"
	date: "$Date: 2006-04-16 23:42:40 -0700 (Sun, 16 Apr 2006) $"
	revision: "$Revision: 491 $"
	author: "Glenn Maughan <glennmaughan@optushome.com.au>"
	copyright: "Copyright (c) 2001 Glenn Maughan and others"
	license: "Eiffel Forum License v2 (see forum.txt)."

class	GOA_SOAP_FAULTS

inherit

	GOA_SOAP_MESSAGE_FACTORY

	KL_IMPORTED_STRING_ROUTINES

feature -- Fault constants

	Version_mismatch_fault: INTEGER is 0
	Must_understand_fault: INTEGER is 1
	Data_encoding_unknown_fault: INTEGER is 2
	Sender_fault: INTEGER is 3
	Receiver_fault: INTEGER is 4

feature -- Status report

	is_valid_fault_code (a_fault_code: INTEGER): BOOLEAN is
			-- is `a_fault_code' valid?
		do
			Result := a_fault_code >= Version_mismatch_fault and then a_fault_code <= Receiver_fault
		end

	is_valid_fault_name (a_fault_name: STRING): BOOLEAN is
			-- is `a_fault_name' valid?
		require
			fault_name_not_void: a_fault_name /= Void
		do
			Result := STRING_.same_string (a_fault_name, "VersionMismatch")
				or else STRING_.same_string (a_fault_name, "MustUnderstand")
				or else STRING_.same_string (a_fault_name, "DataEncodingUnknown")
				or else STRING_.same_string (a_fault_name, "Sender")
				or else STRING_.same_string (a_fault_name, "Receiver")
		end

feature -- Conversions

	fault_code_to_string (a_fault_code: INTEGER): STRING is
			-- Serialized representation of `a_fault_code'
		require
			valid_fault_code: is_valid_fault_code (a_fault_code)
		do
			inspect
				a_fault_code
			when Version_mismatch_fault then
				Result := "env:VersionMismatch"
			when Must_understand_fault then
				Result := "env:MustUnderstand"
			when Data_encoding_unknown_fault then
				Result := "env:DataEncodingUnknown"
			when Sender_fault then
				Result := "env:Sender"
			when Receiver_fault then
				Result := "env:Receiver"
			end
		ensure
			non_empty_result: Result /= Void and then Result.count > 4
		end

	
	value_to_fault_code (a_fault_name: STRING): INTEGER is
			-- code for `a_fault_name'?
		require
			fault_name_not_void: a_fault_name /= Void
			valid_name: is_valid_fault_name (a_fault_name)
		do
			if STRING_.same_string (a_fault_name, "VersionMismatch") then
				Result := Version_mismatch_fault
			elseif STRING_.same_string (a_fault_name, "MustUnderstand") then
				Result := Must_understand_fault
			elseif STRING_.same_string (a_fault_name, "DataEncodingUnknown") then
				Result := Data_encoding_unknown_fault
			elseif STRING_.same_string (a_fault_name, "Sender") then
				Result := Sender_fault
			else
				Result := Receiver_fault
			end
		ensure
			valid_fault_code: is_valid_fault_code (Result)
		end

feature -- Faults

	new_validation_fault (a_code: INTEGER; a_text: STRING; a_node_uri: UT_URI): GOA_SOAP_FAULT_INTENT is
			-- Validation fault
		require
			text_not_empty: a_text /= Void and then not a_text.is_empty
			valid_code: is_valid_fault_code (a_code)
			node_uri_not_void: a_node_uri /= Void
		do
			create Result.make (a_code, a_text, "en", a_node_uri, Void)
		ensure
			fault_created: Result /= Void
		end

	new_fault_message (an_intent: GOA_SOAP_FAULT_INTENT): GOA_SOAP_ENVELOPE is
			-- New SOAP fault message
		require
			intent_not_void: an_intent /= Void
		local
			a_body: GOA_SOAP_BODY
			a_fault: GOA_SOAP_FAULT
		do
			a_fault := an_intent.new_fault
			a_body ?= a_fault.parent
			Result ?= a_body.parent
		ensure
			fault_exists: Result /= Void and then Result.is_fault_message
		end
		
end -- class GOA_SOAP_FAULTS
