note
	description: "Node"
	project: "Project Goanna <http://sourceforge.net/projects/goanna>"
	library: "Document Object Model (DOM) Core"
	date: "$Date: 2006-04-16 23:42:40 -0700 (Sun, 16 Apr 2006) $"
	revision: "$Revision: 491 $"
	author: "Glenn Maughan <glennmaughan@optushome.com.au>"
	copyright: "Copyright (c) 2001 Glenn Maughan and others"
	license: "Eiffel Forum Freeware License v1 (see forum.txt)."

deferred class DOM_NODE

inherit

	DOM_NODE_TYPE

	DOM_DISPLAYABLE

feature

   node_name: DOM_STRING
         -- The name of this node, depending on its type.
      deferred
      end

   node_value: DOM_STRING
         -- The value of this node, depending on its type.
      deferred
      end

   set_node_value (v: DOM_STRING)
         -- see `nodeValue'
	  require
		  not_no_modification_allowed_err: not readonly
      deferred
	  ensure
	  	  node_value_set: node_value.is_equal (v)
      end

   node_type: INTEGER
         -- A code representing the type of the underlying object.
      deferred
      end

   parent_node: DOM_NODE
         -- The parent of this node. All nodes, except Document,
         -- DocumentFragment, and Attr may have a parent. However,
         -- if a node has just been created and not yet added to the tree,
         -- or if it has been removed from the tree, this is `Void'.
      deferred
      end

   child_nodes: DOM_NODE_LIST
         -- A NodeList that contains all children of this node.
         -- If there are no children, this is a NodeList containing no nodes.
         -- The content of the returned NodeList is "live" in the sense
         -- that, for instance, changes to the children of the node object
         -- that it was created from are immediately reflected in the nodes
         -- returned by the NodeList accessors; it is not a static snapshot
         -- of the content of the node.
      deferred
      end

   first_child: DOM_NODE
         -- The first child of this node.
         -- If there is no such node, this returns `Void'.
      deferred
      end

   last_child: DOM_NODE
         -- The last child of this node.
         -- If there is no such node, this returns `Void'.
      deferred
      end

   previous_sibling: DOM_NODE
         -- The node immediately preceding this node.
         -- If there is no such node, this returns `Void'.
      deferred
      end

   next_sibling: DOM_NODE
         -- The node immediately following this node.
         -- If there is no such node, this returns `Void'.
      deferred
      end

   attributes: DOM_NAMED_MAP [DOM_ATTR]
         -- A NamedMap containing the attributes of this node
         -- (if it is an Element) or `Void' otherwise.
      deferred
      end

   owner_document: DOM_DOCUMENT
         -- The Document object associated with this node. This is also
         -- the Document object used to create new nodes. When this node
         -- is a Document this is `Void'.
      deferred
      end

   insert_before (new_child: DOM_NODE; ref_child: DOM_NODE): DOM_NODE
         -- Inserts the node newChild before the existing child node
         -- `refChild'. If `refChild' is `Void', insert `newChild' at the end
         -- of the list of children. If `newChild' is a DocumentFragment
         -- object, all of its children are inserted, in the same order,
         -- before `refChild'. If the `newChild' is already in the tree,
         -- it is first removed.
         -- Parameters
         --    newChild   The node to insert.
         --    refChild   The reference node, i.e., the node before
         --               which the new node must be inserted.
         -- Return Value
         --    The node being inserted.
	  require
		  new_child_exists: new_child /= Void
		  ref_child_exists: ref_child /= Void
		  not_hierarchy_request_err: can_insert (new_child)
		  not_wrong_document_err: is_right_document (new_child)
		  not_no_modification_allowed_err: not readonly
		  not_not_found_err: has_node (ref_child)
      deferred
	  ensure
		 inserted_before: ref_child.previous_sibling = new_child
		 result_exists: Result /= Void
		 result_is_new_child: Result = new_child
      end

   replace_child (new_child: DOM_NODE; old_child: DOM_NODE): DOM_NODE
         -- Replaces the child node `oldChild' with `newChild' in the list
         -- of children, and returns the `oldChild' node. If the `newChild'
         -- is already in the tree, it is first removed.
         -- Parameters
         --    newChild   The new node to put in the child list.
         --    oldChild   The node being replaced in the list.
         -- Return Value
         --    The node replaced.
	  require
		 new_child_exists: new_child /= Void
		 old_child_exists: old_child /= Void
		 not_hierarchy_request_err: can_insert (new_child)
		 not_wrong_document_err: is_right_document (new_child)
		 not_no_modification_allowed_err: not readonly
		 not_not_found_err: has_node (old_child)
      deferred
	  ensure
		 result_exists: Result /= Void
		 result_is_old_child: Result = old_child
		 old_child_removed: not has_node (old_child)
 		 new_child_added: has_node (new_child)
      end

   remove_child (old_child: DOM_NODE): DOM_NODE
         -- Removes the child node indicated by oldChild from the list
         -- of children, and returns it.
         -- Parameters
         --    oldChild   The node being removed.
         -- Return Value
         --    The node removed.
	  require
		 old_child_exists: old_child /= Void
		 not_no_modification_allowed_err: not readonly
		 not_not_found_err: has_node (old_child)
      deferred
	  ensure
		 result_exists: Result /= Void
		 result_is_old_child: Result = old_child
--		 removed: not has_node (old_child)
      end

   append_child (new_child: DOM_NODE): DOM_NODE
         -- Adds the node `newChild' to the end of the list of children
         -- of this node. If the `newChild' is already in the tree,
         -- it is first removed.
         -- Parameters
         --    newChild   The node to add. If it is a DocumentFragment
         --               object, the entire contents of the document
         --               fragment are moved into the child list
         --               of this node
         -- Return Value
         --    The node added.
	  require
		 new_child_exists: new_child /= Void
		 not_hierarchy_request_err: can_insert (new_child)
		 not_wrong_document_err: is_right_document (new_child)
		 not_no_modification_allowed_err: not readonly
      deferred
	  ensure
		 result_exists: Result /= Void
		 result_is_new_child: Result = new_child
		 new_child_appended: last_child = new_child
      end

   has_child_nodes: BOOLEAN
         -- This is a convenience method to allow easy determination
         -- of whether a node has any children.
         -- Return Value
         --    True    if the node has any children,
         --    False   if the node has no children.
      deferred
	  ensure
		 valid_result: Result implies not child_nodes.empty
      end

   clone_node (deep: BOOLEAN): DOM_NODE
         -- Returns a duplicate of this node, i.e., serves as a generic copy
         -- constructor for nodes. The duplicate node has no parent
         -- (parentNode returns `Void'). Cloning an Element copies all
         -- attributes and their values, including those generated by the XML
         -- processor to represent defaulted attributes, but this method
         -- does not copy any text it contains unless it is a deep clone,
         -- since the text is contained in a child Text node. Cloning any
         -- other type of node simply returns a copy of this node.
         -- Parameters
         --    deep   If `True', recursively clone the subtree
         --           under the specified node; if `False', clone only
         --           the node itself (and its attributes, if it is
         --           an Element).
         -- Return Value
         --    The duplicate node.
      deferred
	  ensure
		  no_parent: Result.parent_node = Void
      end

	normalize
			-- Puts all Text modes in the full depth of the sub-tree underneath
			-- this Node, including attribute nodes, into a "normal" form
			-- where only stucture (eg, elements, comments, processing
			-- instructions, CDATA sections and entity references) separates
			-- Text nodes, ie, there are neither adjacent Text nodes nor empty
			-- Text nodes.
		deferred
		end

	is_supported (feature_name, version: DOM_STRING): BOOLEAN
			-- Tests whether the DOM implementation implements a specific
			-- feature and that feature is supported by this node.
		require
			feature_name_exists: feature_name /= Void
		deferred
		end

	namespace_uri: DOM_STRING
			-- The namespace URI of this node, or Void if it is unspecified.
			-- This is not a computed value that is the result of a namespace
			-- lookup based on an examination of the namespace declarations
			-- in scope. It is merely the namespace URI given at creation time.
			-- For nodes of any type other than Element_node and Attribute_node
			-- and nodes created with a DOM Level 1 method, such as 
			-- create_element from the DOM_DOCUMENT interface, this is always
			-- Void.
			-- DOM Level 2.
		deferred
		end

	ns_prefix: DOM_STRING
			-- The namespace prefix of this node, or Void if it is unspecified.
			-- DOM Level 2.
		deferred
		end

	set_prefix (new_prefix: DOM_STRING)
			-- Set the namespace prefix of this node.
			-- DOM Level 2.
		require
			prefix_exists: new_prefix /= Void
			not_invalid_character_err: valid_prefix_chars (new_prefix)
			not_no_modification_allowed_err: not readonly
			not_namespace_err: well_formed_prefix (new_prefix)
		deferred
		ensure
			prefix_set: ns_prefix.is_equal (new_prefix)
		end

	local_name: DOM_STRING
			-- Returns the local part of the qualified name of this node.
			-- DOM Level 2.
		deferred
		end

	has_attributes: BOOLEAN
			-- Returns whether this node (if it is an element) has any
			-- attributes.
			-- DOM Level 2.
		deferred
		ensure
			has_attributes_if_element: Result = (node_type = Element_node and
				attributes /= Void and not attributes.empty) 
		end

feature -- DOM Status Setting

	set_owner_document (doc: like owner_document)
			-- Set the owner document of this node
		require
			doc_exists: doc /= Void
		deferred
		ensure
			owner_document_set: owner_document = doc
		end

	set_parent_node (new_parent: like parent_node)
			-- Set the parent node of this node
		deferred
		ensure
			parent_node_set: parent_node = new_parent
		end

	set_previous_sibling (new_sibling: like previous_sibling)
			-- Set the previous sibling of this node
		deferred
		ensure
			previous_sibling_set: previous_sibling = new_sibling
		end

	set_next_sibling (new_sibling: like next_sibling)
			-- Set the next sibling of this node
		deferred
		ensure
			next_sibling_set: next_sibling = new_sibling
		end

feature -- Validation Utility

	is_right_document (new_child: DOM_NODE): BOOLEAN
			-- Is 'new_child' from the same document?
		require
			new_child_exists: new_child /= Void
		deferred
		end

	can_insert (new_child: DOM_NODE): BOOLEAN
			-- Can 'new_child' be inserted in this node?
		require
			new_child_exists: new_child /= Void
		deferred
		end

	has_node (old_child: DOM_NODE): BOOLEAN
			-- Does 'old_child' exist in this node?
		require
			old_child_exists: old_child /= Void
		deferred
		end

	readonly: BOOLEAN
			-- Can this node be modified?
		deferred
		end

	valid_prefix_chars (new_prefix: DOM_STRING): BOOLEAN
			-- Does 'new_prefix' consist of valid namespace prefix characters?
		require
			new_prefix_exists: new_prefix /= Void
		deferred
		end

	well_formed_prefix (new_prefix: DOM_STRING): BOOLEAN
			-- Is 'new_prefix' a well formed namespace prefix?
		require
			new_prefix_exists: new_prefix /= Void
		deferred
		end

invariant

	name_exists: node_name /= Void
	has_owner: (node_type /= Document_node and node_type /= Document_type_node) implies owner_document /= Void
	has_attributes: node_type = Element_node implies attributes /= Void

end -- class DOM_NODE
