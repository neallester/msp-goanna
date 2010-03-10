indexing
	description: "Objects that represent a SOAP envelope header."
	project: "Project Goanna <http://sourceforge.net/projects/goanna>"
	library: "SOAP"
	date: "$Date: 2006-04-16 23:42:40 -0700 (Sun, 16 Apr 2006) $"
	revision: "$Revision: 491 $"
	author: "Glenn Maughan <glennmaughan@optushome.com.au>"
	copyright: "Copyright (c) 2001 Glenn Maughan and others"
	license: "Eiffel Forum License v2 (see forum.txt)."

class GOA_SOAP_HEADER

inherit
	
	GOA_SOAP_ELEMENT
		redefine
			validate
		end

create

	make_last
	
feature -- Access

	header_blocks: DS_LINKED_LIST [GOA_SOAP_HEADER_BLOCK]
			-- Header blocks (zero or more).
	
feature -- Status setting

	add_header_block (a_block: GOA_SOAP_HEADER_BLOCK) is
			-- Add 'a_block' to the list of header blocks in `Current'.
		require
			new_block_ok: a_block /= Void and then a_block.validated
		do
			header_blocks.force_last (a_block)
			force_last (a_block)
		ensure
			block_added: header_blocks.has (a_block)
			block_added_to_tree: has (a_block)
		end
		
	validate (an_identity: UT_URI) is
			-- Validate `Current'.
		local
			child_elements: DS_LIST [XM_ELEMENT]
			a_cursor: DS_LIST_CURSOR [XM_ELEMENT]
			a_block: GOA_SOAP_HEADER_BLOCK
			a_block_cursor: DS_LINKED_LIST_CURSOR [GOA_SOAP_HEADER_BLOCK]
		do
			scan_attributes (an_identity, True)
			if validated then check_encoding_style_attribute (an_identity) end
			if validated then
				if header_blocks = Void then create header_blocks.make_default end
				child_elements := elements
				from 
					a_cursor := elements.new_cursor; a_cursor.start
				until not validated or else a_cursor.after loop
					a_block ?= a_cursor.item
					if a_block = Void then
						set_validation_fault (Receiver_fault, "Receiver failed to process env:Header correctly", an_identity)
					elseif not a_block.has_namespace then
						set_validation_fault (Sender_fault, "Header block lacks namespace", an_identity)
					elseif not header_blocks.has (a_block) then
						header_blocks.force_last (a_block)
					end
					a_cursor.forth
				end
			end
			if validated then
				from
					a_block_cursor := header_blocks.new_cursor; a_block_cursor.start
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

feature -- Removal

	remove_block (a_block: GOA_SOAP_HEADER_BLOCK) is
			-- Add 'a_block' to the list of header blocks in `Current'.
		require
			new_block_ok: a_block /= Void and then a_block.validated
			has_block: header_blocks.has (a_block)
		do
			header_blocks.delete (a_block)
			delete (a_block)
		ensure
			block_removeded: not header_blocks.has (a_block)
			block_removed_from_tree: not has (a_block)
		end

invariant
	
	header_blocks_exist: validation_complete and then validated implies header_blocks /= Void
	correct_name: is_valid_element (Current, Header_element_name)

end -- class SOAP_GOA_HEADER
