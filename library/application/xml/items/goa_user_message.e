indexing
	description: "A message that may be displayed to the user"
	author: "Neal L Lester <neallester@users.sourceforge.net>"
	date: "$Date: 2006-04-16 23:42:40 -0700 (Sun, 16 Apr 2006) $"
	revision: "$Revision: 491 $"
	copyright: "(c) Neal L Lester"
	License: "Eiffel Forum License Version 2 (see forum.txt)"

class
	GOA_USER_MESSAGE
	
inherit
	
	GOA_XML_ITEM
	
creation
	
	make, make_from_string
	
feature {GOA_XML_DOCUMENT, GOA_DEFERRED_PARAMETER} -- Services

	add_to_document (the_document: GOA_COMMON_XML_DOCUMENT_EXTENDED) is
			-- Add the message for this parameter to the_document
		do
			from
				messages.start
			until
				messages.after
			loop
				the_document.add_item (messages.item_for_iteration)
				if not messages.after then
					the_document.add_a_space
				end
				messages.forth					
			end
		end
		
feature -- Queries
		
	ok_to_add (the_document: GOA_COMMON_XML_DOCUMENT_EXTENDED): BOOLEAN is
			-- Is it OK to add this message to the_document
		do
			if is_empty then
				Result := True
			else
				Result := messages.first.ok_to_add (the_document)
			end
		end
		
	is_empty: BOOLEAN is
			-- Is the message empty?
		do
			Result := messages.is_empty
		end						

	wipe_out is
			-- Clear the message
			-- There is no way to undo not RESULT_PROCESSING_RESULT.all_parameter_values_are_valid
		do
			messages.wipe_out
		ensure
			messages_is_empty: messages.is_empty
		end
		
feature -- Status Setting		
			
	add_message (new_message: STRING) is
			-- Add new_message to error message, appending a space if needed
		require
			valid_new_message: new_message /= Void
		local
			new_message_element: GOA_XML_TEXT_ITEM
		do
			create new_message_element.make (new_message)
			add_message_item (new_message_element)
		end
		
	add_formatted_message (new_message, new_css_class: STRING) is
			-- Add new_message to error message, appending a space if needed
		require
			valid_new_message: new_message /= Void
		local
			new_message_element: GOA_XML_TEXT_ITEM
		do
			create new_message_element.make_with_css_class (new_message, new_css_class)
			add_message_item (new_message_element)
		end
		
	add_message_item (new_item: GOA_XML_ITEM) is
			-- Add new item to error message
		require
			valid_new_item: new_item /= Void
		do
			messages.force_last (new_item)
		ensure
			messages_has_new_item: messages.last = new_item
		end
	
feature {NONE} -- Implementation

	messages: DS_LINKED_LIST [GOA_XML_ITEM]
			-- Message items that make up this message
	
feature {NONE} -- Creation

	make is
			-- Creation
		do
			create messages.make
		end
		
	make_from_string (the_string: STRING) is
			-- Creation
		require
			valid_the_string: the_string /= Void
		do
			make
			add_message (the_string)
		end
		
		
invariant
	
	valid_messages: messages /= Void

end -- class GOA_USER_MESSAGE
