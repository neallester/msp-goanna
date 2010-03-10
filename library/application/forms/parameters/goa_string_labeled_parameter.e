indexing
	description: "Parameter that is labeled with a single string (with a single CSS class)"
	author: "Neal L Lester <neallester@users.sourceforge.net>"
	date: "$Date: 2006-04-16 23:42:40 -0700 (Sun, 16 Apr 2006) $"
	revision: "$Revision: 491 $"
	copyright: "(c) Neal L Lester"
	License: "Eiffel Forum License Version 2 (see forum.txt)"

deferred class
	GOA_STRING_LABELED_PARAMETER
	
inherit
	
	GOA_LABELED_PARAMETER
	
feature
	
	label (processing_result: REQUEST_PROCESSING_RESULT; suffix: INTEGER): GOA_USER_MESSAGE is
		do
			create Result.make
			Result.add_formatted_message (label_string (processing_result, suffix), label_class (processing_result, suffix))
		end
		
--	label_class (processing_result: REQUEST_PROCESSING_RESULT; suffix: INTEGER): STRING is
--		deferred
--		end
		
	label_string (processing_result: REQUEST_PROCESSING_RESULT; suffix: INTEGER): STRING is
		require
			valid_processing_result: processing_result /= Void
			is_suffix_valid: is_suffix_valid (processing_result, suffix)
		deferred
		end

end -- class GOA_STRING_LABELED_PARAMETER
