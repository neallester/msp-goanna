note
	description: "Integer parameter that may not be empty"
	author: "Neal L Lester <neallester@users.sourceforge.net>"
	date: "$Date: 2006-04-16 23:42:40 -0700 (Sun, 16 Apr 2006) $"
	revision: "$Revision: 491 $"
	copyright: "(c) Neal L Lester"
	License: "Eiffel Forum License Version 2 (see forum.txt)"

deferred class
	GOA_NON_EMPTY_INTEGER_PARAMETER
	
inherit
	
	GOA_NON_EMPTY_PARAMETER
		undefine
			process
		redefine
			validate
		end
	GOA_INTEGER_PARAMETER
		undefine
			label_class
		redefine
			validate
		end
		
feature
	
	validate (processing_result: PARAMETER_PROCESSING_RESULT)
		do
			Precursor {GOA_NON_EMPTY_PARAMETER} (processing_result)
			if processing_result.is_value_valid then
				Precursor {GOA_INTEGER_PARAMETER} (processing_result)
			end
		end

end -- class GOA_NON_EMPTY_INTEGER_PARAMETER
