note
	description: "A representation of the elements an XML element may contain)"
	author: "Neal L Lester <neal@3dsafety.com>"
	date: "$Date: 2007-04-06 03:18:13 -0700 (Fri, 06 Apr 2007) $"
	revision: "$Revision: 559 $"
	copyright: "(c) Neal L Lester"

class
	GOA_XML_ELEMENT_SCHEMA


create

	make

feature -- Query

	is_valid_content (the_fragment: ARRAY [INTEGER]): BOOLEAN
			-- Does the_content represent a (valid) and complete content for this element?
		local
			al: DS_ARRAYED_LIST [INTEGER]
		do
			create al.make_from_array (the_fragment)
			al.start
			Result := content.is_valid_content_fragment (al) and (content.was_complete and al.after)
		end

	is_valid_content_fragment (the_fragment: ARRAY [INTEGER]): BOOLEAN
			-- Does the_fragment represent a (valid) portion of the schema?
		local
			al: DS_ARRAYED_LIST [INTEGER]
		do
			create al.make_from_array (the_fragment)
			al.start
			Result := content.is_valid_content_fragment (al)
		end


feature {NONE} -- Implementation

	content: GOA_XML_DEERRED_SCHEMA_ELEMENT


feature {NONE} -- Creation

	make (new_content: GOA_XML_DEERRED_SCHEMA_ELEMENT)
			-- creation
		require
			new_content_not_void: new_content /= Void
		do
			content := new_content
		end


invariant
	content_not_void: content /= Void

end -- class GOA_XML_ELEMENT_SCHEMA
