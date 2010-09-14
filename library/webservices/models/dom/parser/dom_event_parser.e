note
	description: "An eXML event parser for Goanna DOM structures"
	project: "Project Goanna <http://sourceforge.net/projects/goanna>"
	library: "XML Parser"
	date: "$Date: 2006-04-16 23:42:40 -0700 (Sun, 16 Apr 2006) $"
	revision: "$Revision: 491 $"
	author: "Glenn Maughan <glennmaughan@optushome.com.au>"
	copyright: "Copyright (c) 2001 Glenn Maughan and others"
	license: "Eiffel Forum Freeware License v1 (see forum.txt)."

class
	DOM_EVENT_PARSER

inherit
	
	XF_EVENT_PARSER
--		redefine
--			create_default_parser
--		end

feature

--	create_default_parser is
--			-- override to create other default parser
--		do
--			--item := exml_XML_ParserCreateNS (default_pointer, ':')
--			item := exml_XML_ParserCreate (default_pointer)
--			if item = default_pointer then
--				raise ("Failure to create parser with XML_ParserCreate.")
--			end
--			set_callback_object
--			-- register callback handlers
--			exml_register_XML_SetElementDeclHandler (item)
--			exml_register_XML_SetAttlistDeclHandler (item)
--			exml_register_XML_SetXmlDeclHandler (item)
--			exml_register_XML_SetEntityDeclHandler (item)
--			exml_register_XML_SetElementHandler (item)
--			exml_register_XML_SetCharacterDataHandler (item)
--			exml_register_XML_SetProcessingInstructionHandler (item)
--			exml_register_XML_SetCommentHandler (item)
--			exml_register_XML_SetCdataSectionHandler (item)
--			--exml_register_XML_SetDefaultHandler (item)
--			--exml_register_XML_SetDefaultHandlerExpand (item)
--			exml_register_XML_SetDoctypeDeclHandler (item)
--			exml_register_XML_SetNotationDeclHandler (item)
--			--exml_register_XML_SetNamespaceDeclHandler (item)
--			exml_register_XML_SetNotStandaloneHandler (item) 
--		end
		
end -- class DOM_EVENT_PARSER
