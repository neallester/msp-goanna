indexing
	description: "Objects that create appropriate DOM serializer objects for documents"
	project: "Project Goanna <http://sourceforge.net/projects/goanna>"
	library: "DOM Serialization"
	date: "$Date: 2006-04-16 23:42:40 -0700 (Sun, 16 Apr 2006) $"
	revision: "$Revision: 491 $"
	author: "Glenn Maughan <glennmaughan@optushome.com.au>"
	copyright: "Copyright (c) 2001 Glenn Maughan and others"
	license: "Eiffel Forum Freeware License v1 (see forum.txt)."

class
	DOM_SERIALIZER_FACTORY

feature -- Access

	serializer_for_document (doc: DOM_DOCUMENT): DOM_SERIALIZER is
			-- Create a serializer for 'doc'
		require
			document_exists: doc /= Void			
		do
			if is_document_xml (doc) then
				create {DOM_XML_SERIALIZER} Result.make
			else
				-- TODO: handle other document types
			end
		ensure
			result_exists: Result /= Void
		end
	
feature {NONE} -- Implementation

	is_document_xml (doc: DOM_DOCUMENT): BOOLEAN is
			-- Is 'doc' an XML document?
		require
			document_exists: doc /= Void			
		do
			-- TODO: handle other document types
			Result := True
		end
	
end -- class DOM_SERIALIZER_FACTORY
