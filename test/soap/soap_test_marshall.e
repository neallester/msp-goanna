indexing

	description: "Test marshalling features of SOAP library"
	project: "Project Goanna <http://sourceforge.net/projects/goanna>"
	library: "test SOAP"
	date: "$Date: 2006-04-16 23:42:40 -0700 (Sun, 16 Apr 2006) $"
	revision: "$Revision: 491 $"
	author: "Glenn Maughan <glennmaughan@optushome.com.au>"
	copyright: "Copyright (c) 2001 Glenn Maughan and others"
	license: "Eiffel Forum Freeware License v1 (see forum.txt)."

	
deferred class SOAP_TEST_MARSHALL

inherit

	TS_TEST_CASE

	XM_EIFFEL_PARSER_FACTORY

feature -- Test

	test_empty is
			-- Test envelope with no header or body blocks
		local
			envelope: SOAP_ENVELOPE
			header: SOAP_HEADER
			body: SOAP_BODY
		do
			create body.make
			create header.make
			create envelope.make_with_header (header, body)
			io.put_string (envelope.marshall)
			io.new_line
		end

	test_with_blocks is
			-- Test envelope with header and body blocks
		local
			envelope: SOAP_ENVELOPE
			header: SOAP_HEADER
			body: SOAP_BODY
			block: SOAP_BLOCK
		do
			create block.make (parse_xml (Body_block))
			create body.make
			body.add_body_block (block)
			create block.make (parse_xml (Header_block))
			create header.make
			header.add_header_block (block)
			block.set_must_understand (true)
			create envelope.make_with_header (header, body)
			io.put_string (envelope.marshall)
			io.new_line
		end

	test_unmarshall is
			-- Test unmarshall
		local
			envelope: SOAP_ENVELOPE
		do
			create envelope.unmarshall (parse_xml (Envelope1))
			if not envelope.unmarshall_ok then
				io.put_string (envelope.unmarshall_fault.marshall)
				io.new_line
			end
			assert ("correct_marshall", envelope.unmarshall_ok)
		end
		
	parse_xml (xml: STRING): XM_ELEMENT is
			-- Parser xml string and return document element
		local
			a_tree_builder: GOA_TREE_CALLBACKS_PIPE
			a_parser: XM_PARSER
		do
			create a_tree_builder.make
			a_parser := new_eiffel_parser
			a_parser.set_callbacks (a_tree_builder.start)
			a_parser.parse_from_string (xml)
			if a_parser.is_correct then
				Result := a_tree_builder.document.root_element
-- commented out as routine no longer exists				Result.resolve_namespaces_start
--				Result.remove_namespace_declarations_from_attributes
			else
				io.put_string (a_parser.last_error_description)
				io.new_line
				io.put_string (a_parser.last_error_extended_description)
				io.new_line
			end	

		end
		
	Header_block: STRING is "<?xml version=%"1.0%" ?><header><child>This is a child of header</child></header>"
	Body_block: STRING is "<?xml version=%"1.0%" ?><body><child>This is a child of body</child></body>"
	
	Envelope1: STRING is 
		"<env:Envelope xmlns:env=%"http://www.w3.org/2003/05/soap-envelope%">%
		%	<env:Header>%
		%		<n:alertcontrol xmlns:n=%"http://example.org/alertcontrol%" env:mustUnderstand=%"1%">%
		%			<n:priority>1</n:priority>%
		%			<n:expires>2001-06-22T14:00:00-05:00</n:expires>%
		%		</n:alertcontrol>%
		%	</env:Header>%
		%	<env:Body>%
		%		<m:alert xmlns:m=%"http://example.org/alert%">%
		%			<m:msg>Pick up Mary at school at 2pm</m:msg>%
		%		</m:alert>%
		%	</env:Body>%
		%</env:Envelope>"
		
end -- class SOAP_TEST_MARSHALL
