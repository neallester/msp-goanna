indexing
	description: "XML namespace constants"
	project: "Project Goanna <http://sourceforge.net/projects/goanna>"
	library: "Document Object Model (DOM) Core Implementation"
	date: "$Date: 2006-04-16 23:42:40 -0700 (Sun, 16 Apr 2006) $"
	revision: "$Revision: 491 $"
	author: "Glenn Maughan <glennmaughan@optushome.com.au>"
	copyright: "Copyright (c) 2001 Glenn Maughan and others"
	license: "Eiffel Forum Freeware License v1 (see forum.txt)."

class
	DOM_XML_NAMESPACE_CONSTANTS

feature -- Constants

	Xml_prefix: DOM_STRING is
			-- String "xml"
		once
			create Result.make_from_string ("xml")
		end

	Xmlns_qname: DOM_STRING is
			-- String "xmlns"
		once
			create Result.make_from_string ("xmlns")		
		end
		
	Xml_namespace_uri: DOM_STRING is
			-- String "http://www.w3.org/XML/1998/namespace"
		once
			create Result.make_from_string ("http://www.w3.org/XML/1998/namespace")
		end
		
	Xmlns_default_uri: DOM_STRING is
			-- String "http://www.w3.org/2000/xmlns"
		once
			create Result.make_from_string ("http://www.w3.org/2000/xmlns")			
		end
	
	Qname_separator: UC_CHARACTER is
			-- Separator used between prefix and localname of qualified name.
			-- Character ':'.
		once
			Result.make_from_character (':')
		end
		
end -- class DOM_XML_NAMESPACE_CONSTANTS
