indexing
	description: "Objects that represent a collection of GOA_XML_DEFERED_SCHEMA_ELEMENT"
	author: "Neal L Lester <neal@3dsafety.com>"
	date: "$Date: 2007-01-13 05:41:12 +0000 (Sat, 13 Jan 2007) $"
	revision: "$Revision: 540 $"
	copyright: "(c) Neal L Lester"

deferred class
	GOA_XML_SCHEMA_ELEMENT_COLLECTION

inherit
	GOA_XML_DEERRED_SCHEMA_ELEMENT


feature {NONE} -- Implementation

	content: DS_ARRAYED_LIST [GOA_XML_DEERRED_SCHEMA_ELEMENT]
			-- A list of all elements in this collection.


feature {NONE} -- Creation

	make_optional (new_elements: ARRAY [GOA_XML_DEERRED_SCHEMA_ELEMENT]) is
			-- Make an 'optional' element
		require
			new_elements_not_void: new_elements /= Void
		do
			create content.make_from_array (new_elements)
			is_required := False
			is_multiple_element := False
		end

	make_required (new_elements: ARRAY [GOA_XML_DEERRED_SCHEMA_ELEMENT]) is
			-- Make a 'required' element
		require
			new_elements_not_void: new_elements /= Void
		do
			create content.make_from_array (new_elements)
			is_required :=  True
			is_multiple_element := False
		end

	make_zero_or_more (new_elements: ARRAY [GOA_XML_DEERRED_SCHEMA_ELEMENT]) is
			-- Make a 'zero or more' element
		require
			new_elements_not_void: new_elements /= Void
		do
			create content.make_from_array (new_elements)
			is_required := False
			is_multiple_element := True
		end

	make_one_or_more (new_elements: ARRAY [GOA_XML_DEERRED_SCHEMA_ELEMENT]) is
			-- Make a 'one or more' element
		require
			new_elements_not_void: new_elements /= Void
		do
			create content.make_from_array (new_elements)
			is_required := True
			is_multiple_element := True
		end


invariant
	content_not_void: content /= Void

end -- class GOA_XML_SCHEMA_ELEMENT_COLLECTION
