note
	description: "Facilities for goa_common.rnc schema"
	author: "Neal L Lester <neal@3dsafety.com>"
	date: "$Date: 2006-04-16 23:42:40 -0700 (Sun, 16 Apr 2006) $"
	revision: "$Revision: 491 $"
	copyright: "(c) Neal L Lester"

class

	GOA_SCHEMA_FACILITIES
	
feature

	yes_no_string_for_boolean (the_boolean: BOOLEAN): STRING
			-- Return a string representing the_boolean
		do
			if the_boolean then
				Result := "yes"
			else
				Result := "no"
			end
		end
		
	on: STRING = "on"
	
	off: STRING = "off"
	
end -- class GOA_SCHEMA_FACILITIES
