indexing
	description: "Objects that represent an XML-RPC call and response scalar parameter value."
	project: "Project Goanna <http://sourceforge.net/projects/goanna>"
	library: "XML-RPC"
	date: "$Date: 2007-10-15 04:37:53 -0700 (Mon, 15 Oct 2007) $"
	revision: "$Revision: 594 $"
	author: "Glenn Maughan <glennmaughan@users.sourceforge.net>"
	copyright: "Copyright (c) 2001 Glenn Maughan and others"
	license: "Eiffel Forum License v2 (see forum.txt)."

class GOA_XRPC_SCALAR_VALUE

inherit

	GOA_XRPC_VALUE

create

	make, make_base64, unmarshall

feature -- Initialisation

	make (new_value: like value) is
			-- Create scalar type from 'new_value'. 'new_value' must be one of the following
			-- types: INTEGER_REF, BOOLEAN_REF, STRING, DOUBLE_REF or DT_DATE_TIME.
		require
			new_value_exists: new_value /= Void
			valid_type: valid_scalar_type (new_value)
		local
			int_ref: INTEGER_REF
			bool_ref: BOOLEAN_REF
			string: STRING
			double_ref: DOUBLE_REF
			date_time: DT_DATE_TIME
		do
			value := new_value
			-- check integer
			int_ref ?= new_value
			if int_ref /= Void then
				type := Int_type
				string_value := value.out
			else
				-- check double
				double_ref ?= new_value
				if double_ref /= Void then
					type := Double_type
					string_value := value.out
				else
					-- check boolean
					bool_ref ?= new_value
					if bool_ref /= Void then
						type := Bool_type
						bool_ref ?= value
						if bool_ref.item then
							string_value := "1"
						else
							string_value := "0"
						end
					else
						-- check string
						string ?= new_value
						if string /= Void then
							type := String_type
							string_value := value.out
						else
							-- check date/time
							date_time ?= new_value
							if date_time /= Void then
								type := Date_time_type
								date_time ?= value
								string_value := format_date_iso8601 (date_time)
							end
						end
					end
				end
			end
			unmarshall_ok := True
		end

	make_base64 (buffer: STRING) is
			-- Create scalar base64 type from 'buffer'. Encode value.
		require
			buffer_exists: buffer /= Void
		local
			encoder: GOA_BASE64_ENCODER
		do
			type := Base64_type
			value := buffer
			create encoder
			create string_value.make_from_string (encoder.encode (buffer))
		end

	unmarshall (node: XM_ELEMENT) is
			-- Unmarshall scalar value from XML node.
		local
			int_ref: INTEGER_REF
			double_ref: DOUBLE_REF
			bool_ref: BOOLEAN_REF
			text: STRING
			decoder: GOA_BASE64_ENCODER
		do
			unmarshall_ok := True
			-- check if we were passed the value node. If so this is an untyped scalar
			-- treat as a string.
			if node.name.is_equal (Value_element) then
				type := String_type
				if not node.is_empty then
					value := node.text.out
				else
					value := ""
				end
				string_value := value.out
			else
				-- check for text child node
				type := node.name
				text := node.text
				if text /= Void then
					string_value := text.out
					-- check for string
					if type.is_equal (String_type) then
						value := string_value.twin
					-- check for integer
					elseif type.is_equal (Int_type) or type.is_equal (Alt_int_type) then
						if string_value.is_integer then
							create int_ref
							int_ref.set_item (string_value.to_integer)
							value := int_ref
						else
							unmarshall_ok := False
							unmarshall_error_code := Invalid_integer_value
						end
					-- check for boolean
					elseif type.is_equal (Bool_type) then
						if string_value.is_equal ("0") then
							create bool_ref
							bool_ref.set_item (False)
							value := bool_ref
						elseif string_value.is_equal ("1") then
							create bool_ref
							bool_ref.set_item (True)
							value := bool_ref
						else
							unmarshall_ok := False
							unmarshall_error_code := Invalid_boolean_value
						end
					-- check for double
					elseif type.is_equal (Double_type) then
						if string_value.is_double then
							create double_ref
							double_ref.set_item (string_value.to_double)
							value := double_ref
						else
							unmarshall_ok := False
							unmarshall_error_code := Invalid_double_value
						end
					-- check for Base64
					elseif type.is_equal (Base64_type) then
						create decoder
						value := decoder.decode (string_value)
					-- check for date/time
					elseif type.is_equal (Date_time_type) then
						value := unmarshall_date_iso8601 (string_value)
						if value = Void then
							unmarshall_ok := False
							unmarshall_error_code := Invalid_date_time_value
						end
					else
						unmarshall_ok := False
						unmarshall_error_code := Invalid_value_type
					end
				else
					-- check for empty string or base64
					if type.is_equal (String_type) or type.is_equal (Base64_type) then
						value := ""
					else
						unmarshall_ok := False
						unmarshall_error_code := Value_text_element_missing
					end
				end
			end
		end

feature -- Mashalling

	marshall: STRING is
			-- Serialize this scalar param to XML format
		do
			create Result.make (100)
			Result.append ("<value>")
			-- don't bother wrapping string types in a type element
			if type /= String_type then
				Result.append ("<")
				Result.append (type.out)
				Result.append (">")
			end
			-- if it is a string, we have to escape it
			if type = String_type then
				Result.append (escape_xml (string_value))
			else
				Result.append (string_value)
			end
			if type /= String_type then
				Result.append ("</")
				Result.append (type.out)
				Result.append (">")
			end
			Result.append ("</value>")
		end

feature -- Status report

	value: ANY
			-- Value of this parameter

	string_value: STRING
			-- String representation of value

feature -- Conversion

	as_object: ANY is
			-- Return value as an object. ie, extract the actual
			-- object value from the XRPC_VALUE.
		do
			Result := value
		end

feature {NONE} -- Implementation

	escape_xml (str: STRING): STRING is
			-- Escape special xml characters in str.
		require
			str_exists: str /= Void
		do
			Result := str.twin
			Result.replace_substring_all ("&", "&amp;")
			Result.replace_substring_all ("%"", "&quot;")
			Result.replace_substring_all ("'", "&apos;")
			Result.replace_substring_all ("<", "&lt;")
			Result.replace_substring_all (">", "&gt;")
		ensure
			Result_not_void: Result /= Void
		end


	format_date_iso8601 (date: DT_DATE_TIME): STRING is
			-- Format a date time in ISO8601 format
			-- YYYYMMDD'T'HH:MM:SS
		require
			date_exists: date /= Void
		local
			int_format: INTEGER_FORMATTER
		do
			create int_format
			create Result.make (17)
			Result.append (date.year.out)
			Result.append (int_format.zero_fill (date.month, 2))
			Result.append (int_format.zero_fill (date.day, 2))
			Result.append_character ('T')
			Result.append (int_format.zero_fill (date.hour, 2))
			Result.append_character (':')
			Result.append (int_format.zero_fill (date.minute, 2))
			Result.append_character (':')
			Result.append (int_format.zero_fill (date.second, 2))
		ensure
			formatted_string_exists: Result /= Void
		end

	unmarshall_date_iso8601 (str: STRING): DT_DATE_TIME is
			-- Create a date time object from the ISO8601 'str'
			-- Return Void if 'str' does not conform to ISO8601 format.
		require
			str_exists: str /= Void
		local
			date, hour, minute, second: STRING
		do
			-- check valid length
			if str.count = 17 then
				-- check integer parts
				date := str.substring (1, 8)
				hour := str.substring (10, 11)
				minute := str.substring (13, 14)
				second := str.substring (16, 17)
				if date.is_integer and hour.is_integer and minute.is_integer and second.is_integer then
					create Result.make (date.substring (1, 4).to_integer,
						date.substring (5, 6).to_integer,
						date.substring (7, 8).to_integer,
						hour.to_integer,
						minute.to_integer,
						second.to_integer)
				end
			end
		end

invariant

	string_value_exists: unmarshall_ok implies string_value /= Void

end -- class GOA_XRPC_SCALAR_VALUE
