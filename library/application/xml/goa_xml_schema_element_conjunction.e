indexing
	description: "Objects that represent a conjunction of GOA_XML_DEFERRED_ELEMENT"
	author: "Neal L Lester <neal@3dsafety.com>"
	date: "$Date: 2007-01-13 05:41:12 +0000 (Sat, 13 Jan 2007) $"
	revision: "$Revision: 540 $"
	copyright: "(c) Neal L Lester"

class
	GOA_XML_SCHEMA_ELEMENT_CONJUNCTION

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
			old_pos: INTEGER
			recursion_result: BOOLEAN
		do
			-- remeber the pos of the cursor in fragment if we have to undo stuff
			old_pos := the_fragment.index

			from
				Result := True
				was_complete := True
				content.start
			until
				content.after or the_fragment.after or not Result
			loop
				Result := content.item_for_iteration.is_valid_content_fragment (the_fragment)
				was_complete := was_complete and content.item_for_iteration.was_complete
				content.forth
			end

			if Result then
				if not the_fragment.after and is_multiple_element then
					recursion_result := is_valid_content_fragment (the_fragment)
				end
			else
				-- restore the_fragment since we couldn't match the conjunction
				the_fragment.go_i_th (old_pos)
				if not is_required then
					Result := True
					was_complete := True
				end
			end
			if not Result then
				was_complete := False
			else
				-- Check to see if we have any more required items in the conjunction
				from
					old_pos := content.index
				until
					content.after or not was_complete
				loop
					was_complete := not content.item_for_iteration.is_required
					content.forth
				end
				content.go_i_th (old_pos)
			end
		end

end -- class GOA_XML_SCHEMA_ELEMENT_CONJUNCTION
