indexing
	description: "Objects that represent a disjunction of GOA_XML_DEFERRED_SCHEMA_ELEMENT"
	author: "Neal L Lester <neal@3dsafety.com>"
	date: "$Date: 2007-01-13 05:41:12 +0000 (Sat, 13 Jan 2007) $"
	revision: "$Revision: 540 $"
	copyright: "(c) Neal L Lester"

class
	GOA_XML_SCHEMA_ELEMENT_DISJUNCTION

inherit
	GOA_XML_SCHEMA_ELEMENT_COLLECTION

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
		local
			recursion_result: BOOLEAN
		do
			from
				Result := False
				was_complete := False
				content.start
			until
				content.after or the_fragment.after or Result
			loop
				Result := content.item_for_iteration.is_valid_content_fragment (the_fragment)
				was_complete := content.item_for_iteration.was_complete
				content.forth
			end

			if Result and is_multiple_element and not the_fragment.after then
				recursion_result := is_valid_content_fragment (the_fragment)
			end

			if not is_required then
				Result := True
				was_complete:= True
			end
		end


end -- class GOA_XML_SCHEMA_ELEMENT_DISJUNCTION
