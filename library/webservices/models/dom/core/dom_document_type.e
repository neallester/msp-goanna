indexing
	description: "Document type"
	project: "Project Goanna <http://sourceforge.net/projects/goanna>"
	library: "Document Object Model (DOM) Core"
	date: "$Date: 2006-04-16 23:42:40 -0700 (Sun, 16 Apr 2006) $"
	revision: "$Revision: 491 $"
	author: "Glenn Maughan <glennmaughan@optushome.com.au>"
	copyright: "Copyright (c) 2001 Glenn Maughan and others"
	license: "Eiffel Forum Freeware License v1 (see forum.txt)."

deferred class DOM_DOCUMENT_TYPE

inherit

	DOM_NODE

feature

	entities: DOM_NAMED_NODE_MAP is
			-- A named node map containing the general entities, both external and internal,
			-- declared in the DTD. Parameter entities are not contained. Duplicates are
			-- discarded. 
		deferred
		end

	internal_subset: DOM_STRING is
			-- The internal subset as a string. Note: The actual content returned depends on
			-- how much information is available to the implementation. This may vary 
			-- depending on various parameters, including the XML processor used to build
			-- the document.
			-- DOM Level 2.
		deferred
		end

	name: DOM_STRING is
			-- The name of DTD; ie, the name immediately following the DOCTYPE keyword.
		deferred
		end

	notations: DOM_NAMED_NODE_MAP is
			-- A named node map containing the notations declared in the DTD. Duplicates
			-- are discarded. Every node in this map also implements the Nodation interface.
		deferred
		end

	public_id: DOM_STRING is
			-- The public identifier of the external subset.
			-- DOM Level 2.
		deferred
		end

	system_id: DOM_STRING is
			-- The system identifier of the external subset.
			-- DOM Level 2.
		deferred
		end			

end -- class DOM_DOCUMENT_TYPE
