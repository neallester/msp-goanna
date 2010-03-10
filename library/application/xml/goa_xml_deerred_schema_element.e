indexing
	description: "Deferred item in a GOA_XML_ELEMENT_SCHEMA"
	author: "Neal L Lester <neal@3dsafety.com>"
	date: "$Date: 2007-01-13 05:41:12 +0000 (Sat, 13 Jan 2007) $"
	revision: "$Revision: 540 $"
	copyright: "(c) Neal L Lester"

deferred class
	GOA_XML_DEERRED_SCHEMA_ELEMENT


feature

	is_required: BOOLEAN
			-- Is this element required to be present for the parent element to be valid?

	is_multiple_element: BOOLEAN
			-- May this element be present multiple times in a valid parent element?


feature {GOA_XML_ELEMENT_SCHEMA, GOA_XML_DEERRED_SCHEMA_ELEMENT} -- Query implementation

	was_complete: BOOLEAN

	is_valid_content_fragment (the_fragment: DS_ARRAYED_LIST [INTEGER]): BOOLEAN is
			-- Does this element represent a valid element at the given location in the parent element?
			-- The location is given by the internal cursor of the_fragment
			-- If the feature retuns false, the_fragment must be unchanged.
		require
			the_fragment_not_void: the_fragment /= Void
		deferred
		ensure
			fragment_count_unchanged: the_fragment.count = old the_fragment.count
			false_implies_fragment_is_unchanged: not Result implies the_fragment.is_equal (old the_fragment)
			--true_and_required_implies_fragment_counter_moved: (Result and is_required) implies (the_fragment.index > old the_fragment.index)
		end


end -- of GOA_XML_DEERRED_SCHEMA_ELEMENT
