indexing
	description: "A GOA_XML_ITEM that consist only of text"
	author: "Neal L Lester <neallester@users.sourceforge.net>"
	date: "$Date: 2006-04-16 23:42:40 -0700 (Sun, 16 Apr 2006) $"
	revision: "$Revision: 491 $"
	copyright: "(c) Neal L Lester"
	License: "Eiffel Forum License Version 2 (see forum.txt)"

class
	GOA_XML_TEXT_ITEM
	
inherit
	
	GOA_XML_ITEM
	
creation
	
	make, make_with_css_class
	
feature {GOA_COMMON_XML_DOCUMENT_EXTENDED}

	
	add_to_document (xml: GOA_COMMON_XML_DOCUMENT_EXTENDED) is
			-- Add an xml representation of this hyperlink to the_documnet
		do
			if not text.is_empty then
				if css_class = Void then
					xml.add_text_item_element (xml.xml_null_code, Void, text)
				else
					xml.add_text_item_element (xml.span_attribute_code, css_class, text)
				end
			end
		end

feature -- Queries
		
	ok_to_add (xml: GOA_COMMON_XML_DOCUMENT_EXTENDED): BOOLEAN is
			-- Is it OK to add this hyperlink to xml
		do
			Result := xml.ok_to_add_element_or_text (xml.text_item_element_code)
		end
		
	text: STRING
			-- Text of the error message
	
	css_class: STRING
			-- CSS class to format the text with
			
feature {NONE} -- Creation

	make (new_text: STRING) is
			-- Creation
		require
			valid_new_text: new_text /= Void
		do
			text := new_text
		ensure
			text_updated: equal (text, new_text)
		end
		
	make_with_css_class (new_text, new_css_class: STRING) is
			-- Creation
		require
			valid_new_text: new_text /= Void
		do
			make (new_text)
			css_class := new_css_class
		ensure
			text_updated: equal (text, new_text)
			css_class_updated: equal (css_class, new_css_class)
		end

end -- class GOA_XML_TEXT_ITEM
