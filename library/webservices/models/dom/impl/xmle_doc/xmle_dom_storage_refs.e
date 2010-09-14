note
	description: "Collection of DOM class references to ensure a close-set of classes %
		% to ensure correct storable functionality. %
		% When retrieving XMLE_DOCUMENT_WRAPPER objects ensure that %
		% your application includes a reference to this class."
	project: "Project Goanna <http://sourceforge.net/projects/goanna>"
	library: "XMLE DOM Extensions"
	date: "$Date: 2006-04-16 23:42:40 -0700 (Sun, 16 Apr 2006) $"
	revision: "$Revision: 491 $"
	author: "Glenn Maughan <glennmaughan@optushome.com.au>"
	copyright: "Copyright (c) 2001 Glenn Maughan and others"
	license: "Eiffel Forum Freeware License v1 (see forum.txt)."

class
	XMLE_DOM_STORAGE_REFS

feature {NONE} -- References

	d1: DOM_ATTR_IMPL
	d2: DOM_CDATA_SECTION_IMPL
	d3: DOM_CHARACTER_DATA_IMPL
	d4: DOM_COMMENT_IMPL
	d5: DOM_DOCUMENT_FRAGMENT_IMPL
	d6: DOM_DOCUMENT_IMPL
	d7: DOM_DOCUMENT_TYPE_IMPL
	d8: DOM_ELEMENT_IMPL
	d9: DOM_ENTITY_IMPL
	d10: DOM_ENTITY_REFERENCE_IMPL
	d11: DOM_EXCEPTION_IMPL
	d12: DOM_IMPLEMENTATION_IMPL
	d13: DOM_NAMED_MAP_IMPL [DOM_NODE]
	d14: DOM_NAMED_NODE_MAP_IMPL
	d15: DOM_NODE_IMPL
	d16: DOM_NODE_LIST_IMPL
	d17: DOM_NOTATION_IMPL
	d18: DOM_PARENT_NODE
	d19: DOM_PROCESSING_INSTRUCTION_IMPL
	d20: DOM_TEXT_IMPL
	d21: DOM_EXCEPTION -- probably not needed as it isn't used.

end -- class XMLE_DOM_STORAGE_REFS
