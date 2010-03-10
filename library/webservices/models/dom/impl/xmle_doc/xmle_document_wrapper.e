indexing
	description: "Objects that hold a DOM document and provide storable and access capabilities"
	project: "Project Goanna <http://sourceforge.net/projects/goanna>"
	library: "XMLE DOM Extensions"
	date: "$Date: 2006-04-16 23:42:40 -0700 (Sun, 16 Apr 2006) $"
	revision: "$Revision: 491 $"
	author: "Glenn Maughan <glennmaughan@optushome.com.au>"
	copyright: "Copyright (c) 2001 Glenn Maughan and others"
	license: "Eiffel Forum Freeware License v1 (see forum.txt)."

class
	XMLE_DOCUMENT_WRAPPER

inherit

	STORABLE
	
	DOM_NODE_FILTER_CONSTANTS
		export
			{NONE} all
		end

creation
	make

feature -- Initialization

	make (doc: DOM_DOCUMENT) is
			-- Create a wrapper on 'doc'
		require
			doc_exists: doc /= Void
		do
			document := doc
			create id_nodes.make (10)
			collect_id_nodes
		end

feature -- Access

	document: DOM_DOCUMENT
			-- The document held by this wrapper.

	id_nodes: DS_HASH_TABLE [DOM_NODE, STRING]
			-- Table of nodes indexed by 'id'. 

	get_node_by_id (id: STRING): DOM_NODE is
			-- Retrieve a reference to a node with the given 'id'.
		do
			Result := id_nodes.item (id)
		end

feature {NONE} -- Implementation
	
	collect_id_nodes is
			-- Collect all nodes in 'document' with an 'id' attribute and
			-- store a reference to the element in the 'id_elements' table.
		local
			iterator: DOM_NODE_ITERATOR
			filter: ID_NODE_FILTER
			current_node: DOM_NODE
		do
			create filter
			iterator := document.create_node_iterator (document, Show_all, filter, false)
			from
				current_node := iterator.next_node
			until
				current_node = Void
			loop
				debug ("xmle_id_nodes")
					print (generator + ".collect_id_nodes: node = " + current_node.node_name.out + "%R%N")
				end
				check
					id_attribute_exists: current_node.has_attributes and current_node.attributes.has_named_item (Id_attribute)
				end
				id_nodes.force (current_node, current_node.attributes.get_named_item (Id_attribute).node_value.out)
				current_node := iterator.next_node
			end
		end
	
	Id_attribute: DOM_STRING is
		once
			create Result.make_from_string ("id")
		end
		
invariant

	document_exists: document /= Void
	id_nodes_table_exists: id_nodes /= Void

end -- class XMLE_DOCUMENT_WRAPPER
