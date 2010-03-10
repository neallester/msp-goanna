indexing
	description: "Document type implementation"
	project: "Project Goanna <http://sourceforge.net/projects/goanna>"
	library: "Document Object Model (DOM) Core Implementation"
	date: "$Date: 2006-04-16 23:42:40 -0700 (Sun, 16 Apr 2006) $"
	revision: "$Revision: 491 $"
	author: "Glenn Maughan <glennmaughan@optushome.com.au>"
	copyright: "Copyright (c) 2001 Glenn Maughan and others"
	license: "Eiffel Forum Freeware License v1 (see forum.txt)."

class DOM_DOCUMENT_TYPE_IMPL

inherit

	DOM_DOCUMENT_TYPE

	DOM_CHILD_AND_PARENT_NODE
		rename
			make as parent_node_make
		export
			{NONE} parent_node_make
		end

creation

	make

feature {DOM_DOCUMENT} -- Factory creation

	make (doc: DOM_DOCUMENT_IMPL; new_qualified_name, 
		new_public_id, new_system_id: DOM_STRING) is
			-- Create new document type.
			-- 'doc' may be Void.
		do
			parent_node_make
			if doc /= Void then
				set_owner_document (doc)		
			end
			name := new_qualified_name
			public_id := new_public_id
			system_id := new_system_id	
		end

feature

	entities: DOM_NAMED_NODE_MAP 
			-- A named node map containing the general entities, both external and internal,
			-- declared in the DTD. Parameter entities are not contained. Duplicates are
			-- discarded. 
		
	internal_subset: DOM_STRING
			-- The internal subset as a string. Note: The actual content returned depends on
			-- how much information is available to the implementation. This may vary 
			-- depending on various parameters, including the XML processor used to build
			-- the document.
			-- DOM Level 2.
		
	name: DOM_STRING
			-- The name of DTD; ie, the name immediately following the DOCTYPE keyword.
		
	notations: DOM_NAMED_NODE_MAP
			-- A named node map containing the notations declared in the DTD. Duplicates
			-- are discarded. Every node in this map also implements the Nodation interface.
	
	public_id: DOM_STRING
			-- The public identifier of the external subset.
			-- DOM Level 2.
	
	system_id: DOM_STRING
			-- The system identifier of the external subset.
			-- DOM Level 2.	
	  
feature -- from DOM_NODE
	  
	node_type: INTEGER is
		once
			Result := Document_type_node
		end

	node_name: DOM_STRING is
		do
			Result := name
		end

end -- class DOM_DOCUMENT_TYPE_IMPL

