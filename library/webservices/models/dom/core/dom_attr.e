indexing
	description: "Attribute node"
	project: "Project Goanna <http://sourceforge.net/projects/goanna>"
	library: "Document Object Model (DOM) Core"
	date: "$Date: 2006-04-16 23:42:40 -0700 (Sun, 16 Apr 2006) $"
	revision: "$Revision: 491 $"
	author: "Glenn Maughan <glennmaughan@optushome.com.au>"
	copyright: "Copyright (c) 2001 Glenn Maughan and others"
	license: "Eiffel Forum Freeware License v1 (see forum.txt)."

deferred class DOM_ATTR

inherit

	DOM_NODE

feature

   name: DOM_STRING is
         -- The name of this attribute.
      deferred
      end

   specified: BOOLEAN is
         -- If this attribute was explicitly given a value in the original
         -- document, this is `True'; otherwise, it is `False'. Note that
         -- the implementation is in charge of this attribute, not the
         -- user. If the user changes the value of the attribute (even if
         -- it ends up having the same value as the default value) then
         -- the `specified' flag is automatically flipped to `True'. To
         -- re-specify the attribute as the default value from the DTD,
         -- the user must delete the attribute. The implementation will
         -- then make a new attribute available with `specified' set to `False'
         -- and the default value (if one exists).
         -- In summary:
         --    If the attribute has an assigned value in the document
         --    then specified is `True', and the value is the assigned value.
         --    If the attribute has no assigned value in the document and
         --    has a default value in the DTD, then `specified' is `False',
         --    and the value is the default value in the DTD.
         --    If the attribute has no assigned value in the document and
         --    has a value of #IMPLIED in the DTD, then the attribute does
         --    not appear in the structure model of the document.
		 -- DOM Level 2.
      deferred
      end

   value: DOM_STRING is
         -- The value of the attribute is returned as a string. Character
         -- and general entity references are replaced with their values.
      deferred
      end

   set_value (v: DOM_STRING) is
         -- This creates a Text node with the unparsed contents of the string.
	  require
		  not_no_modification_allowed_err: not readonly
      deferred
	  ensure
		  value_set: value.is_equal (v)
      end

	owner_element: DOM_ELEMENT is
			-- The element node this attribute is attached to or Void if this 
			-- attribute is not in use.
			-- DOM Level 2.
		deferred
		end

end -- class DOM_ATTR
