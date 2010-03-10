indexing
	description: "Items that may be added to a GOA_XML_DOCUMENT"
	author: "Neal L Lester <neallester@users.sourceforge.net>"
	date: "$Date: 2006-04-16 23:42:40 -0700 (Sun, 16 Apr 2006) $"
	revision: "$Revision: 491 $"
	copyright: "(c) Neal L Lester"
	License: "Eiffel Forum License Version 2 (see forum.txt)"

deferred class
	
	GOA_XML_ITEM
	
feature
	
	add_to_document (the_document: GOA_XML_DOCUMENT) is
			-- Add an xml representation of this item to the_documnet
		require
			valid_the_document: the_document /= Void
			ok_to_add: ok_to_add (the_document)
		deferred
		end

feature -- Queries

	ok_to_add (the_document: GOA_XML_DOCUMENT): BOOLEAN is
			-- Is it OK to add this item to the_document
		require
			valid_the_document: the_document /= Void
		deferred
		end

end -- class GOA_XML_ITEM
