note
	description: "Objects that test GOA_FAST_CGI_PROBE_FACILITIESGOA_FAST_CGI_RECORD_BODY and descendents"
	author: "Neal Lester"
	date: "$Date$"
	revision: "$Revision$"
	License: "Eiffel Forum License Version 2 (see forum.txt)"

deferred class
	TEST_GOA_FAST_CGI_PROBE_FACILITIES

inherit

	TS_TEST_CASE

feature -- Tests

	test_is_ip4_address
		do
			assert ("ip4 address 1", not facilities.is_ip4_address (<<4, 4, 4, 4, 4>>))
			assert ("ip4 address 2", not facilities.is_ip4_address (<<4, 4, 4>>))
			assert ("ip4 address 3", not facilities.is_ip4_address (<<4, 4, 4, 300>>))
			assert ("ip4 address 4", not facilities.is_ip4_address (<<4, 4, 4, -4>>))
			assert ("ip4 address 5", facilities.is_ip4_address (<<4, 4, 4, 4>>))
		end

	test_is_ip4_octet
		do
			assert ("ip4 octet 1", facilities.is_ip4_octet (0))
			assert ("ip4 octet 2", facilities.is_ip4_octet (255))
			assert ("ip4 octet 3", facilities.is_ip4_octet (200))
			assert ("ip4 octet 4", not facilities.is_ip4_octet (256))
			assert ("ip4 octet 5", not facilities.is_ip4_octet (-1))
		end

	test_is_legal_script_path
		do
			assert ("script path 1", facilities.is_legal_script_path ("/a/b/"))
			assert ("script path 2", facilities.is_legal_script_path ("/aa/bb/"))
			assert ("script path 3", not facilities.is_legal_script_path ("/aa/bb"))
			assert ("script path 4", not facilities.is_legal_script_path ("aa/bb/"))
			assert ("script path 5", not facilities.is_legal_script_path ("/aabb/"))
			assert ("script path 6", not facilities.is_legal_script_path ("/aa/b/b/"))
			assert ("script path 7", not facilities.is_legal_script_path ("/a/a/b/b/"))
			assert ("script path 8", not facilities.is_legal_script_path ("/aa/ba/bb/bb/"))
		end

feature {NONE} -- Implementation

	facilities: GOA_FAST_CGI_PROBE_FACILITIES
		once
			create Result
		end



end
