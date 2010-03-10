indexing
	description: "Objects that represent a SOAP envelope body."
	project: "Project Goanna <http://sourceforge.net/projects/goanna>"
	library: "SOAP"
	date: "$Date: 2006-04-16 23:42:40 -0700 (Sun, 16 Apr 2006) $"
	revision: "$Revision: 491 $"
	author: "Glenn Maughan <glennmaughan@optushome.com.au>"
	copyright: "Copyright (c) 2001 Glenn Maughan and others"
	license: "Eiffel Forum License v2 (see forum.txt)."

class GOA_SOAP_BODY

inherit
	
	GOA_SOAP_ELEMENT
		redefine
			validate
		end

create

	make_last
		
feature -- Access

	body_blocks: DS_LINKED_LIST [GOA_SOAP_ELEMENT]
			-- Body blocks (zero or more).

	is_fault_message: BOOLEAN is
			-- Is this a SOAP Fault message?
		require
			validated: validation_complete and then validated
		local
			a_fault: GOA_SOAP_FAULT
		do
			Result := body_blocks.count = 1
			if Result then
				a_fault ?= body_blocks.item (1)
				Result := a_fault /= Void
			end
		end

feature -- Status setting

		validate (an_identity: UT_URI) is
			-- Validate `Current'.
		local
			child_elements: DS_LIST [XM_ELEMENT]
			a_cursor: DS_LIST_CURSOR [XM_ELEMENT]
			a_block: GOA_SOAP_ELEMENT
			a_block_cursor: DS_LINKED_LIST_CURSOR [GOA_SOAP_ELEMENT]
		do
			scan_attributes (an_identity, True)
			if validated then check_encoding_style_attribute (an_identity) end
			if validated then
				if body_blocks = Void then create body_blocks.make_default end
				child_elements := elements
				from 
					a_cursor := child_elements.new_cursor; a_cursor.start
				until not validated or else a_cursor.after loop
					a_block ?= a_cursor.item
					if a_block = Void then
						set_validation_fault (Receiver_fault, "Receiver failed to process env:Body correctly", an_identity)
					elseif not body_blocks.has (a_block) then
						body_blocks.force_last (a_block)
					end
					a_cursor.forth
				end
			end
			if validated then
				from
					a_block_cursor := body_blocks.new_cursor; a_block_cursor.start
				until not validated or else a_block_cursor.after loop
					a_block := a_block_cursor.item
					a_block.validate (an_identity)
					if not a_block.validated then
						validated := False
						validation_fault := a_block.validation_fault
					end
					a_block_cursor.forth
				end
			end
			validation_complete := True
		end

	add_body_block (a_block: GOA_SOAP_ELEMENT) is
			-- Add `a_block' to the list of body blocks in this body.
		require
			new_block_exists: a_block /= Void
			block_not_in_list: not body_blocks.has (a_block)
		do
			body_blocks.force_last (a_block)
			force_last (a_block)
		ensure
			block_added: body_blocks.has (a_block)
			block_added_to_tree: has (a_block)
		end
		
invariant
	
	body_blocks_exist: validation_complete and then validated implies body_blocks /= Void
	correct_name: is_valid_element (Current, Body_element_name)

end -- class GOA_SOAP_BODY
