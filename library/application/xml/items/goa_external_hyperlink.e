note
	description: "Links to external websites"
	author: "Neal L Lester <neallester@users.sourceforge.net>"
	date: "$Date: 2007-01-12 21:41:12 -0800 (Fri, 12 Jan 2007) $"
	revision: "$Revision: 540 $"
	copyright: "(c) Neal L Lester"
	License: "Eiffel Forum License Version 2 (see forum.txt)"

class
	GOA_EXTERNAL_HYPERLINK

inherit

	GOA_HYPERLINK
	KL_IMPORTED_STRING_ROUTINES

create

	make

feature {NONE} -- Creation

	make (new_host_and_path, new_text: STRING)
			-- Creation
		require
			valid_new_host_and_path: new_host_and_path /= Void
			valid_new_text: new_text /= Void
		do
			initialize
			host_and_path := STRING_.cloned_string (new_host_and_path)
			if equal (host_and_path.substring (1, 7).as_upper, "HTTP://") then
				host_and_path.keep_tail (host_and_path.count - 7)
			end
			text := STRING_.cloned_string (new_text)
		end


end -- class GOA_EXTERNAL_HYPERLINK
