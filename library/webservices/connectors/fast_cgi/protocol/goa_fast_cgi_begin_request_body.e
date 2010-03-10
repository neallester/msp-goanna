indexing
	description: "Objects that represent a FastCGI begin request record body"
	project: "Project Goanna <http://sourceforge.net/projects/goanna>"
	library: "FastCGI protocol"
	date: "$Date: 2010-02-26 18:04:12 -0800 (Fri, 26 Feb 2010) $"
	revision: "$Revision: 626 $"
	author: "Glenn Maughan <glennmaughan@users.sourceforge.net>"
	copyright: "Copyright (c) 2001 Glenn Maughan and others"
	license: "Eiffel Forum License v2 (see forum.txt)."

class GOA_FAST_CGI_BEGIN_REQUEST_BODY

inherit

	GOA_FAST_CGI_RECORD_BODY

	KL_IMPORTED_INTEGER_ROUTINES

feature -- Access

	role, flags: INTEGER

	header_type_code: INTEGER is 1

feature -- Attribute Setting

	set_role (new_role: like role) is
		do
			role := new_role
		ensure
			role_updated: role = new_role
		end

	set_flags (new_flags: like flags) is
		do
			flags := new_flags
		ensure
			flags_updated: flags = new_flags
		end

	as_fast_cgi_string: STRING is
			-- Formatted as a STRING per FastCGI protocol
		do
			Result := as_16_bit_string (role)
			Result.extend (flags.to_character_8)
			Result.append (create_blank_buffer (5))
		end

feature {TS_TEST_CASE} -- Testing

	set_raw_content_data (new_raw_content_data: like raw_content_data) is
		do
			raw_content_data := new_raw_content_data
		ensure
			raw_content_data_updated: equal (raw_content_data, new_raw_content_data)
		end


feature {TS_TEST_CASE} -- Implementation

	process_body_fields is
			-- Extract body fields from raw content data.
		do
			role := INTEGER_.bit_shift_left (raw_content_data.item (1).code, 8)
				+ raw_content_data.item (2).code
			flags := raw_content_data.item (3).code
			-- 5 reserved bytes also read. Ignore them.
		end

end -- class GOA_FAST_CGI_BEGIN_REQUEST_BODY
