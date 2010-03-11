indexing
	description: "Facilities for GOA_FAST_CGI_PROBE"
	author: "Neal Lester"
	date: "$Date$"
	revision: "$Revision$"
	License: "Eiffel Forum License Version 2 (see forum.txt)"

class

	GOA_FAST_CGI_PROBE_FACILITIES

feature -- Facilities

	is_ip4_address (a_ip_address: ARRAY [INTEGER]): BOOLEAN is
			-- Does a_ip_address represent a valid ip4 address?
		require
			valid_a_ip_address: a_ip_address /= Void
		do
			Result := a_ip_address.count = 4 and then a_ip_address.for_all (agent is_ip4_octet (?))
		end

	is_ip4_octet (a_integer: INTEGER): BOOLEAN is
			-- Is a_integer a valid ip4 octet value?
		do
			Result := a_integer >= 0 and a_integer <= 255
		end

	is_legal_script_path (a_script_path: STRING): BOOLEAN is
			-- Is a_script_path a legal fast_cgi script path?
		require
			valid_a_script_path: a_script_path /= Void
		local
			middle_slash_index, end_slash_index: INTEGER
		do
			Result := 	a_script_path.count >= 5 and then
						a_script_path.item (1) = '/' and then
						a_script_path.item (a_script_path.count) = '/'
			if Result then
				middle_slash_index := a_script_path.index_of ('/', 2)
				Result := middle_slash_index > 2 and then middle_slash_index < (a_script_path.count - 1)
				if Result then
					end_slash_index := a_script_path.index_of ('/', middle_slash_index + 1)
					Result := end_slash_index = a_script_path.count
				end
			end

		end

end
