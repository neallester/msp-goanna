indexing
	description: "An item in an XML_ELEMENT_SCHEMA"
	author: "Neal L Lester <neal@3dsafety.com>"
	date: "$Date: 2007-04-06 03:18:13 -0700 (Fri, 06 Apr 2007) $"
	revision: "$Revision: 559 $"
	copyright: "(c) Neal L Lester"

class
	GOA_XML_SCHEMA_ELEMENT

inherit
	GOA_XML_DEERRED_SCHEMA_ELEMENT

creation

	make_required,
	make_optional,
	make_zero_or_more,
	make_one_or_more


feature {GOA_XML_ELEMENT_SCHEMA, GOA_XML_DEERRED_SCHEMA_ELEMENT} -- Query

	is_valid_content_fragment (the_fragment: DS_ARRAYED_LIST [INTEGER]): BOOLEAN is
			-- Does this element represent a valid element at the given location in the parent element?
			-- The location is given by the internal cursor of the_fragment
			-- If the feature retuns false, the_fragment must be unchanged.
		do
			from
				Result := False
			until
				the_fragment.after or else
				(the_fragment.item_for_iteration /= element_code or (Result and not is_multiple_element))
			loop
				the_fragment.forth
				Result := True
			end

			if not is_required then
				Result := True
			end

			was_complete := Result
		end

feature {NONE} -- Implementation

	element_code: INTEGER
			-- The code of the element.

feature {NONE} -- Creation

	make_optional (new_element_code: INTEGER) is
			-- Make an 'optional' element
		do
			element_code := new_element_code
			is_required := False
			is_multiple_element := False
		ensure
			element_code_set: element_code = new_element_code
		end

	make_required (new_element_code: INTEGER) is
			-- Make a 'required' element
		do
			element_code := new_element_code
			is_required :=  True
			is_multiple_element := False
		ensure
			element_code_set: element_code = new_element_code
		end

	make_zero_or_more (new_element_code: INTEGER) is
			-- Make a 'zero or more' element
		do
			element_code := new_element_code
			is_required := False
			is_multiple_element := True
		ensure
			element_code_set: element_code = new_element_code
		end

	make_one_or_more (new_element_code: INTEGER) is
			-- Make a 'one or more' element
		do
			element_code := new_element_code
			is_required := True
			is_multiple_element := True
		ensure
			element_code_set: element_code = new_element_code
		end


end -- class GOA_XML_SCHEMA_ELEMENT
