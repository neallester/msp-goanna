note
	description: "A hidden input in an html form"
	author: "Neal L Lester <neallester@users.sourceforge.net>"
	date: "$Date: 2006-04-16 23:42:40 -0700 (Sun, 16 Apr 2006) $"
	revision: "$Revision: 491 $"
	copyright: "(c) Neal L Lester"
	License: "Eiffel Forum License Version 2 (see forum.txt)"
	
deferred class
	GOA_HIDDEN_PARAMETER
	
inherit
	
	GOA_REQUEST_PARAMETER
		redefine
			display_value
		end
	
feature
	
	display_value (processing_result: REQUEST_PROCESSING_RESULT; suffix: INTEGER): STRING
		do
			Result := current_value (processing_result, suffix)
		end
		
	add_to_document (xml: GOA_COMMON_XML_DOCUMENT_EXTENDED; processing_result: REQUEST_PROCESSING_RESULT; suffix: INTEGER)
		do
			xml.add_hidden_element (name, display_value (processing_result, suffix))
		end

	ok_to_add (xml: GOA_COMMON_XML_DOCUMENT_EXTENDED): BOOLEAN
		do
			Result := xml.ok_to_add_element_or_text (xml.hidden_element_code)
		end
		
end -- class GOA_HIDDEN_PARAMETER
