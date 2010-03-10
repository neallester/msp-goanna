indexing
	description: "A html hyperlink"
	author: "Neal L Lester <neallester@users.sourceforge.net>"
	date: "$Date: 2007-01-12 21:41:12 -0800 (Fri, 12 Jan 2007) $"
	revision: "$Revision: 540 $"
	copyright: "(c) Neal L Lester"
	License: "Eiffel Forum License Version 2 (see forum.txt)"

deferred class
	GOA_HYPERLINK

inherit

	GOA_XML_ITEM
	GOA_HTTP_UTILITY_FUNCTIONS
		export
			{NONE} all
		end
	GOA_SHARED_APPLICATION_CONFIGURATION

feature

feature {GOA_COMMON_XML_DOCUMENT_EXTENDED} -- Services

	add_to_document (the_document: GOA_COMMON_XML_DOCUMENT_EXTENDED) is
			-- Add an xml representation of this hyperlink to the_documnet
		do
			the_document.start_hyperlink_element (css_class, url)
				if tool_tip /= Void then
					the_document.add_tool_tip_element (tool_tip_class, tool_tip)
				end
				the_document.add_text (text)
			the_document.end_current_element
		end

feature -- Queries

	ok_to_add (the_document: GOA_COMMON_XML_DOCUMENT_EXTENDED): BOOLEAN is
			-- Is it OK to add this hyperlink to the_document
		do
			Result := the_document.ok_to_add_element_or_text (the_document.hyperlink_element_code)
		end

	url: STRING is
			-- The URL for this hyperlink

		do

			Result := "http"
			if is_secure then
				Result.extend ('s')
			end
			Result.append ("://")
			Result.append (host_and_path)
			Result.append (query_string)
			if anchor /= Void then
				Result.append ("#" + anchor)
			end
		end

feature -- Status Setting

	add_parameter (name, value: STRING) is
			-- Add a parameter to the hyperlink
			-- n.b. Does not do any escaping on name or value
		require
			valid_name: name /= Void and then not name.is_empty
			valid_value: value /= Void and then not value.is_empty
		do
			parameter_names.force_last (name)
			parameter_values.force_last (value)
		end

	set_anchor (new_anchor: STRING) IS
			-- Add an anchor to the hyperlink
		require
			valid_new_anchor_implies_not_is_empty: new_anchor /= Void implies not new_anchor.is_empty
		do
			anchor := new_anchor
		end

	set_secure is
			-- Use https (default is no)
		do
			is_secure := True
		ensure
			is_secure: is_secure
		end

	set_css_class (new_class: STRING) is
			-- Set css_class to new_class
		do
			css_class := new_class
		ensure
			equal (css_class, new_class)
		end

	set_tool_tip (new_tool_tip_class, new_tool_tip: STRING) is
			-- Add a tool_tip to this hyperlink
		require
			valid_tool_tip_class_implies_valid_new_tool_tip: new_tool_tip_class /= Void implies new_tool_tip /= Void
			void_tool_tip_class_implies_void_new_tool_tip: new_tool_tip_class = Void implies new_tool_tip = Void
			non_empty_new_tool_tip_class: new_tool_tip_class /= Void implies not new_tool_tip_class.is_empty
			non_empty_new_tool_tip: new_tool_tip /= Void implies not new_tool_tip.is_empty
		do
			tool_tip_class := new_tool_tip_class
			tool_tip := new_tool_tip
		ensure
			tool_tip_class_updated: equal (new_tool_tip_class, tool_tip_class)
			tool_tip_updated: equal (tool_tip, new_tool_tip)
		end

feature {NONE} -- Implementation

	anchor: STRING
			-- Anchor for the hyperlink

	host_and_path: STRING
			-- Host name and path to document

	text: STRING
			-- Text associated with the hyperlink

	css_class: STRING
			-- CSS class associated with the hyperlink

	tool_tip_class: STRING
			-- Class of the tool tip associated with this URL

	tool_tip: STRING
			-- Text of the tool tip associated with this URL

	is_secure: BOOLEAN
			-- Use https?

	parameter_names, parameter_values: DS_LINKED_LIST [STRING]
			-- Names and values for all parameters for the hyperlink

	initialize is
			-- Intiialize the object
		do
			create parameter_names.make_equal
			create parameter_values.make_equal
		end

	query_string: STRING is
			-- The query string portion of the hyperlink
		do
			if parameter_names.is_empty then
				Result := ""
			else
				Result := "?"
				from
					parameter_names.start
					parameter_values.start
				until
					parameter_names.after
				loop
					Result.append (encode(parameter_names.item_for_iteration))
					Result.append ("=")
					Result.append (encode(parameter_values.item_for_iteration))
					parameter_names.forth
					parameter_values.forth
					if not parameter_names.after then
						Result.append ("&")
					end
				end
			end
		end

invariant

	valid_text: text /= Void
	valid_host_and_path: host_and_path /= Void and then not host_and_path.is_empty
	valid_parameter_names: parameter_names /= Void
	valid_parameter_values: parameter_values /= Void
	names_match_parameters: equal (parameter_names.count, parameter_values.count)

end -- class GOA_HYPERLINK
