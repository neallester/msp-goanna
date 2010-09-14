note
	description: "Root class for goa_fast_cgi_manager; Manage Multiple fast_cgi applications"
	author: "Neal L Lester [neal@3dsafety.com]"
	date: "$Date:  $"
	revision: "$Revision: "
	copyright: "Copyright (c) Neal L. Lester"
	License: "Eiffel Forum License Version 2 (see forum.txt)"

class
	GOA_FAST_CGI_MANAGER

create

	make

feature {NONE} -- Creation

	make
		local
		
		do
			--create ip_address.make_from_components (192, 168, 1, 35)
			-- create service.make_from_port (3783, "tcp")
		end

	prune_line (a_line: STRING)
			-- a_line cleaned of hidden characters
		require
			valid_a_line: a_line /= Void
		do
			a_line.prune_all ((0).to_character_8)
			a_line.prune_all ((1).to_character_8)
			a_line.prune_all ((2).to_character_8)
			a_line.prune_all ((6).to_character_8)
			a_line.prune_all ((24).to_character_8)
			a_line.prune_all ((25).to_character_8)
		ensure
			not_has_0: not a_line.has ((0).to_character_8)
			not_has_1: not a_line.has ((1).to_character_8)
			not_has_2: not a_line.has ((2).to_character_8)
			not_has_6: not a_line.has ((6).to_character_8)
			not_has_24: not a_line.has ((24).to_character_8)
			not_has_25: not a_line.has ((25).to_character_8)
		end


feature {NONE} -- Implementation


end -- class GOA_FAST_CGI_MANAGER
