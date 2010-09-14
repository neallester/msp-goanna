note
	description: "Objects that can stream a DOM as a string"
	project: "Project Goanna <http://sourceforge.net/projects/goanna>"
	library: "DOM Serialization"
	date: "$Date: 2006-04-16 23:42:40 -0700 (Sun, 16 Apr 2006) $"
	revision: "$Revision: 491 $"
	author: "Glenn Maughan <glennmaughan@optushome.com.au>"
	copyright: "Copyright (c) 2001 Glenn Maughan and others"
	license: "Eiffel Forum Freeware License v1 (see forum.txt)."

class
	DOM_WRITER
	
obsolete "Use SERIALIZER classes instead"

feature -- Transformation

	output (node: DOM_NODE)
			-- Recursively stream 'node' as a string.
		require
			node_exists: node /= Void
		do
			output_recurse (node, 0)
		end

feature {NONE} -- Implementation

	output_recurse (node: DOM_NODE; level: INTEGER)
			-- Recursive routine to stream a dom as a string
		require
			node_exists: node /= Void
			positive_level: level >= 0
		local 
			children: DOM_NODE_LIST
			i: INTEGER
		do
			node.output_indented (level)
			print ("%R%N")
			children := node.child_nodes
			if children /= Void then
				from
				variant
					children.length - i
				until
					i >= children.length
				loop
					output_recurse (children.item (i), level + 1)
					i := i + 1
				end
			end
		end
					
end -- class DOM_WRITER
