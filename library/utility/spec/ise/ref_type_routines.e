note
	description: "Mixin class that provides portable reference type routines."
	project: "Project Goanna <http://sourceforge.net/projects/goanna>"
	library: "Utility"
	date: "$Date: 2002-03-09 15:29:20 -0800 (Sat, 09 Mar 2002) $"
	revision: "$Revision: 330 $"
	author: "Glenn Maughan <glennmaughan@optushome.com.au>"
	copyright: "Copyright (c) 2001 Glenn Maughan and others"
	license: "Eiffel Forum Freeware License v1 (see forum.txt)."

class
	REF_TYPE_ROUTINES
	
obsolete "ISE and SmallEiffel now have the same BOOLEAN_REF creation interface."

feature
	
	make_boolean_ref (bool: BOOLEAN): BOOLEAN_REF
			-- Create a new boolean reference type from 'bool'.
		do

                        create Result
                        Result.set_item (bool)

		end
	
end -- class REF_TYPE_ROUTINES
