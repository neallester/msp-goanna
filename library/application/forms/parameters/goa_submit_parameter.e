note
	description: "A submit input in a html form"
	author: "Neal L Lester <neallester@users.sourceforge.net>"
	date: "$Date: 2007-03-29 07:18:13 -0800 (Thu, 29 Mar 2007) $"
	revision: "$Revision: 551 $"
	copyright: "(c) Neal L Lester"
	License: "Eiffel Forum License Version 2 (see forum.txt)"

deferred class
	GOA_SUBMIT_PARAMETER

inherit

	GOA_REQUEST_PARAMETER
	GOA_STRING_LABELED_PARAMETER

feature

	add_to_document (xml: GOA_COMMON_XML_DOCUMENT_EXTENDED; processing_result: REQUEST_PROCESSING_RESULT; suffix: INTEGER)
		do
			if include_suffix_in_xml then
				xml.add_submit_element (css_class (processing_result, suffix), full_parameter_name (name, suffix), current_value (processing_result, suffix), on_click_script(processing_result, suffix))
			else
				xml.add_submit_element (css_class (processing_result, suffix), name, current_value (processing_result, suffix), on_click_script(processing_result, suffix))
			end
		end

	ok_to_add (xml: GOA_COMMON_XML_DOCUMENT_EXTENDED): BOOLEAN
		do
			Result := xml.ok_to_add_element_or_text (xml.submit_element_code)
		end

	css_class (processing_result: REQUEST_PROCESSING_RESULT; suffix: INTEGER): STRING
			-- CSS class associated witht his parameter
			-- Default none (Void)
		do
			Result := Void
		end

	on_click_script (processing_result: REQUEST_PROCESSING_RESULT; suffix: INTEGER): STRING
			-- Script that should execute when this parameter is clicked on
			-- Default none (Void)
		do
			Result := Void
		end

	current_value (processing_result: REQUEST_PROCESSING_RESULT; suffix: INTEGER): STRING
		do
			result := label_string (processing_result, suffix)
		end

	include_suffix_in_xml: BOOLEAN
			-- Should the name include the suffix when added to the xml document
		once
			Result := False
		end



end -- class GOA_SUBMIT_PARAMETER
