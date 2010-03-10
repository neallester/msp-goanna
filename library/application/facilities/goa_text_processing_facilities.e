indexing
	description: "Facilities for manipulating text content"
	author: "Neal L Lester <neallester@users.sourceforge.net>"
	date: "$Date: 2006-04-16 23:42:40 -0700 (Sun, 16 Apr 2006) $"
	revision: "$Revision: 491 $"
	copyright: "(c) Neal L Lester"
	License: "Eiffel Forum License Version 2 (see forum.txt)"

class
	GOA_TEXT_PROCESSING_FACILITIES

inherit
	
	GOA_SHARED_APPLICATION_CONFIGURATION
	KL_IMPORTED_STRING_ROUTINES
	
feature -- Text Manipulation

	append_with_space_if_needed (target, text_to_add: STRING) is
			-- Append text to add to target; adding a space if target is not empty
		require
			valid_target: target /= Void
			valid_text_to_add: text_to_add /= Void
		do
			if target.is_empty then
				target.append (text_to_add)
			else
				target.append (" " + text_to_add)
			end
		end
		
	name_from_raw_parameter (new_raw_parameter: STRING): STRING is
			-- The parameter name portion of raw_parameter
		require
			valid_raw_parameter: new_raw_parameter /= Void and then not new_raw_parameter.is_empty
		local
			separator_index: INTEGER
		do
			if new_raw_parameter.has (configuration.parameter_separator) then
				separator_index := new_raw_parameter.index_of (configuration.parameter_separator, 1)
				Result := STRING_.cloned_string (new_raw_parameter)
				Result.keep_head (separator_index - 1)
			else
				Result := STRING_.cloned_string (new_raw_parameter)
			end
		ensure
			new_string_created: Result /= new_raw_parameter
		end
		
	suffix_from_raw_parameter (new_raw_parameter: STRING): INTEGER is
			-- The parameter's parameter portion of new_raw_parameter
		require
			valid_new_raw_parameter: new_raw_parameter /= Void and then not new_raw_parameter.is_empty
		local
			separator_index: INTEGER
			suffix_string: STRING
		do
			if new_raw_parameter.has (configuration.parameter_separator) then
				separator_index := new_raw_parameter.index_of (configuration.parameter_separator, 1)
				suffix_string := STRING_.cloned_string (new_raw_parameter)
				suffix_string.remove_head (separator_index)
				if suffix_string.is_integer then
					Result := suffix_string.to_integer
				end
			end
		ensure
			new_raw_parameter_has_separator_implies_result: new_raw_parameter.has (configuration.parameter_separator) implies Result > 0
			not_new_raw_parameter_has_separator_implies_result: not new_raw_parameter.has (configuration.parameter_separator) implies Result = 0
		end
		
	full_parameter_name (name: STRING; suffix: INTEGER): STRING is
			-- The full parameter name given name and suffix
			-- Use Void if no suffix
		require
			valid_name: name /= Void and not name.is_empty
		do
			if suffix > 0 then
				Result := STRING_.cloned_string (name + configuration.parameter_separator.out + suffix.out)
			else
				Result := STRING_.cloned_string (name)
			end
			
		end
		
	maxlength_string_for_integer (maxlength: INTEGER): STRING is
			-- Return a string representing maxlength
		do
			if maxlength = 0 then
				Result := Void
			else
				Result := maxlength.out
			end
		end
		
end -- class GOA_TEXT_PROCESSING_FACILITIES
