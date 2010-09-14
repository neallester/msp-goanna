note
	description: "XML-RPC constants."
	project: "Project Goanna <http://sourceforge.net/projects/goanna>"
	library: "XML-RPC"
	date: "$Date: 2007-04-08 02:43:35 -0700 (Sun, 08 Apr 2007) $"
	revision: "$Revision: 563 $"
	author: "Glenn Maughan <glennmaughan@users.sourceforge.net>"
	copyright: "Copyright (c) 2001 Glenn Maughan and others"
	license: "Eiffel Forum License v2 (see forum.txt)."

class GOA_XRPC_CONSTANTS

feature -- Types

	Int_type: STRING = "int"
			-- Four byte signed integer

	Alt_int_type: STRING = "i4"
			-- Alternate integer type. Same as "int"

	Bool_type: STRING = "boolean"
			-- 0 (false) or 1 (true)

	String_type: STRING = "string"
			-- ASCII string

	Double_type: STRING = "double"
			-- double-precision signed floaging point number

	Date_time_type: STRING = "dateTime.iso8601"
			-- date/time in ISO8601 format (YYYYMMDDTHH:MM:SS)

	Base64_type: STRING = "base64"
			-- Base64-encoded binary

	Array_type: STRING = "array"
			-- Array

	Struct_type: STRING = "struct"
			-- Structure

	valid_scalar_type (new_value: ANY): BOOLEAN
			-- Is `new_value' one of the supported XML-RPC scalar types?
		require
			new_value_exists: new_value /= Void
		local
			int_ref: INTEGER_REF
			bool_ref: BOOLEAN_REF
			string: STRING
			double_ref: DOUBLE_REF
			date_time: DT_DATE_TIME
		do
			Result := True
			int_ref ?= new_value
			if int_ref = Void then
				double_ref ?= new_value
				if double_ref = Void then
					bool_ref ?= new_value
					if bool_ref = Void then
						string ?= new_value
						if string = Void then
							date_time ?= new_value
							if date_time = Void then
								Result := False
							end
						end
					end
				end
			end
		end

	valid_array_type (new_value: ANY): BOOLEAN
			-- Is `new_value' a valid XML-RPC array type?
			-- A valid array type is an 'ARRAY [ANY]' or conforming
			-- object.
		require
			new_value_exists: new_value /= Void
		local
			array: ARRAY [ANY]
		do
			array ?= new_value
			Result := array /= Void
		end

	valid_struct_type (new_value: ANY): BOOLEAN
			-- Is `new_value' a valid XML-RPC struct type?
			-- A valid struct type is an 'DS_HASH_TABLE [ANY, STRING]' or conforming
			-- object.
		require
			new_value_exists: new_value /= Void
		local
			ht: DS_HASH_TABLE [ANY, STRING]
		do
			ht ?= new_value
			Result := ht /= Void
		end

feature -- Error codes

	Headerval_content_type: STRING = "text/xml"
			-- Content type for request and response

	Unsupported_method_fault_code: INTEGER = 1
			-- Attempt to call XMLRPC using unsupported method

	Bad_payload_fault_code: INTEGER = 2
			-- Request did not contain a valid XMLRPC payload

	Method_name_element_missing: INTEGER = 3
			-- Method name element is missing in method call

	Param_value_element_missing: INTEGER = 4
			-- The value element of a parameter is missing

	Param_value_type_element_missing: INTEGER = 5
			-- The type element of a value is missing.

	Invalid_integer_value: INTEGER = 6
			-- Invalid integer value

	Invalid_double_value: INTEGER = 7
			-- Invalid double value

	Invalid_boolean_value: INTEGER = 8
			-- Invalid boolean value

	Invalid_value_type: INTEGER = 9
			-- Unknown value type specified

	Value_text_element_missing: INTEGER = 10
			-- Value element does not contain an expected text element

	Array_data_element_missing: INTEGER = 11
			-- Array data element missing

	Array_contains_no_values: INTEGER = 12
			-- Array contains no values

	Array_contains_unexpected_element: INTEGER = 13
			-- Array contains unexpected element

	Unexpected_struct_element: INTEGER = 14
			-- Unexpected struct element

	Missing_name_element_for_struct_member: INTEGER = 15
			-- Missing name element for struct member

	Missing_value_element_for_struct_member: INTEGER = 16
			-- Missing value element for struct member

	Invalid_struct_member_name: INTEGER = 17
			-- Invalid strut member name

	Fault_value_element_missing: INTEGER = 18
			-- Fault value element missing

	Invalid_fault_value: INTEGER = 19
			-- Invalid fault value

	Fault_code_member_missing: INTEGER = 20
			-- Fault code missing

	Invalid_fault_code: INTEGER = 21
			-- Invalid fault code

	Invalid_fault_string: INTEGER = 22
			-- Invalid fault string

	Response_value_missing: INTEGER = 23
			-- Response value missing

	Invalid_action_return_type: INTEGER = 24
			-- Invalid action return type

	Unable_to_execute_service_action: INTEGER = 25
			-- Unable to execute service action

	Action_not_found_for_service: INTEGER = 26
			-- Action not found for service

	Service_not_found: INTEGER = 27
			-- Service not found

	Invalid_operands_for_service_action: INTEGER = 28
			-- Invalid operands for service action

	Socket_error: INTEGER = 29
			-- A socket error occurred

	Assertion_failure: INTEGER = 30
			-- An assertion failed

	Invalid_date_time_value: INTEGER = 31
			-- Invalid date time value

	Multi_call_recursion: INTEGER = 32
			-- Method 'system.multiCall' cannot be called within a multi call invocation.

	Invalid_multi_call_params: INTEGER = 33
			-- Invalid parameters for multi call

	Invalid_multi_call_method_name: INTEGER = 34
			-- Invalid method name for multi call

	User_fault: INTEGER = 35
			-- User defined fault.

	fault_code_string (code: INTEGER): STRING
			-- Return error message for fault 'code'.
		require
			valid_fault_code: code >= 0
		do
			if code >= Fault_strings.lower and code <= Fault_strings.upper then
				Result := Fault_strings.item (code)
			else
				Result := "Unknown fault code"
			end
		end

	Fault_strings: ARRAY [STRING]
			-- Fault error messages
		once
			Result := <<
				"Unsupported request method",								-- 1
				"Bad request/response payload",								-- 2
				"Method name element is missing in method call",			-- 3
				"The value element of a parameter is missing", 				-- 4
				"The type element of a value is missing",					-- 5
				"Invalid integer value",									-- 6
				"Invalid double value",										-- 7
				"Invalid boolean value",									-- 8
				"Unknown value type specified",								-- 9
				"Value element does not contain an expected text element",	-- 10
				"Array data element missing",								-- 11
				"Array contains no values",									-- 12
				"Array contains unexpected element",						-- 13
				"Struct contains unexpected element",						-- 14
				"Missing name element for struct member",					-- 15
				"Missing value element for struct member",					-- 16
				"Invalid strut member name",								-- 17
				"Fault value element missing",								-- 18
				"Invalid fault value",										-- 19
				"Fault code missing",										-- 20
				"Invalid fault code",										-- 21
				"Invalid fault string",										-- 22
				"Response value missing",									-- 23
				"Invalid action return type",								-- 24
				"Unable to execute service action",							-- 25
				"Action not found for service",								-- 26
				"Service not found",										-- 27
				"Invalid operands for service action",						-- 28
				"Socket error",												-- 29
				"Assertion violation",										-- 30
				"Invalid date time value",									-- 31
				"Method 'system.multiCall' cannot be called within a multi call invocation",	-- 32
				"Invalid parameters for multi call",						-- 33
				"Invalid method name for multi call",						-- 34
				""															-- 35
			>>
		end

feature -- DOM elements

	Method_name_element: STRING = "methodName"
			-- Tag <methodName>

	Params_element: STRING = "params"
			-- Tag <parms>

	Param_element: STRING = "param"
			-- Tag <param>

	Value_element: STRING = "value"
			-- Tag <value>

	Array_element: STRING = "array"
			-- Tag <array>

	Data_element: STRING = "data"
			-- Tag <data>

	Struct_element: STRING = "struct"
			-- Tag <struct>

	Member_element: STRING = "member"
			-- Tag <struct>

	Name_element: STRING = "name"
			-- Tag <struct>

	Fault_element: STRING = "fault"
			-- Tag <fault>

	Fault_code_member: STRING = "faultCode"

	Fault_string_member: STRING = "faultString"

	System_multicall_member: STRING = "system.multiCall"
			-- Method name "system.multiCall"

feature -- Factories

	Value_factory: GOA_XRPC_VALUE_FACTORY
			-- Shared value factory
		once
			create Result.make
		end

feature -- Logging

	Xmlrpc_category: STRING = "httpd.xmlrpc"
			-- Logging category name for XML-RPC services

end -- class GOA_XRPC_CONSTANTS
