note
	description: "Example for testing servlet API"
	project: "Project Goanna <http://sourceforge.net/projects/goanna>"
	library: "examples"
	date: "$Date: 2006-04-16 23:42:40 -0700 (Sun, 16 Apr 2006) $"
	revision: "$Revision: 491 $"
	author: "Glenn Maughan <glennmaughan@optushome.com.au>"
	copyright: "Copyright (c) 2001 Glenn Maughan and others"
	license: "Eiffel Forum Freeware License v1 (see forum.txt)."

class
	DOM_TEST_SERVLET

inherit

	HTTP_SERVLET
		redefine
			do_get, do_post
		end

	UT_STRING_FORMATTER
		export
			{NONE} all
		end
		
create

	init
	
feature -- Basic operations

	do_get (req: HTTP_SERVLET_REQUEST; resp: HTTP_SERVLET_RESPONSE)
			-- Process GET request
		do
			send_dom_html (req, resp)
		end
	
	do_post (req: HTTP_SERVLET_REQUEST; resp: HTTP_SERVLET_RESPONSE)
			-- Process GET request
		do
			do_get (req, resp)
		end
		
feature {NONE} -- Implementation

	send_dom_html (req: HTTP_SERVLET_REQUEST; resp: HTTP_SERVLET_RESPONSE)
		local
			serializer: DOM_SERIALIZER
			stream: IO_STRING
			dom_impl: DOM_IMPLEMENTATION_IMPL
			root: DOM_ELEMENT
			discard: DOM_NODE
			str: DOM_STRING
			format_param: STRING
		do
			-- create a DOM document and send it.
			resp.set_content_type ("text/xml")
			create {DOM_IMPLEMENTATION_IMPL} dom_impl
			document := dom_impl.create_empty_document
			create str.make_from_string ("Request")
			root := document.create_element (str)
			document.set_document_element (root)
			discard := document.append_child (root)
			add_parameter_elements (req, root, document)
			add_header_elements (req, root, document)
			debug ("dom_output")
				document.document_element.output
			end	
			serializer := serializer_factory.serializer_for_document (document)
			create stream.make (4096)
			serializer.set_output (stream)
			if req.has_parameter ("compact") then
				format_param := req.get_parameter ("compact")
				if format_param.is_boolean and format_param.to_boolean then
					serializer.set_compact_format	
				end
			end
			serializer.serialize (document)
			resp.send (stream.to_string)
		end

	add_parameter_elements (req: HTTP_SERVLET_REQUEST; parent: DOM_ELEMENT; doc: DOM_DOCUMENT)
			-- Add an element for each request parameter
		require
			req_exists: req /= Void
			parent_exists: parent /= Void
			doc_exists: doc /= Void
		local
			parameter_names: DS_LINEAR [STRING]
			element: DOM_ELEMENT
			str, name, value: DOM_STRING
			discard: DOM_NODE
		do
			from
				parameter_names := req.get_parameter_names
				parameter_names.start
			until
				parameter_names.off
			loop
				create str.make_from_string ("Parameter")
				element := doc.create_element (str)
				create name.make_from_string ("name")
				create value.make_from_string (parameter_names.item_for_iteration)
				element.set_attribute (name, value)				
				create name.make_from_string ("value")
				create value.make_from_string (req.get_parameter (parameter_names.item_for_iteration))
				element.set_attribute (name, value)
				discard := parent.append_child (element)
				parameter_names.forth
			end
		end
	
	add_header_elements (req: HTTP_SERVLET_REQUEST; parent: DOM_ELEMENT; doc: DOM_DOCUMENT)
			-- Add an element for each request header
		require
			req_exists: req /= Void
			parent_exists: parent /= Void
			doc_exists: doc /= Void
		local
			header_names: DS_LINEAR [STRING]
			element: DOM_ELEMENT
			text: DOM_TEXT
			discard: DOM_NODE
			str, name, value: DOM_STRING
		do
			from
				header_names := req.get_header_names
				header_names.start
			until
				header_names.off
			loop
				create str.make_from_string ("Header")
				element := doc.create_element (str)
				create name.make_from_string ("name")
				create value.make_from_string (header_names.item_for_iteration)	
				element.set_attribute (name, value)
				create str.make_from_string (req.get_header (header_names.item_for_iteration))
				text := document.create_text_node (str)
				discard := element.append_child (text)
				discard := parent.append_child (element)
				header_names.forth
			end
		end
		
	serializer_factory: DOM_SERIALIZER_FACTORY
			-- Factory for creating serializer objects
		once
			create Result
		end
		
	document: DOM_DOCUMENT
	
end -- class DOM_TEST_SERVLET
