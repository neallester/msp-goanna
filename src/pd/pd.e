note
	description: "DOM tree printer"
	project: "Project Goanna <http://sourceforge.net/projects/goanna>"
	library: "examples"
	date: "$Date: 2006-04-16 23:42:40 -0700 (Sun, 16 Apr 2006) $"
	revision: "$Revision: 491 $"
	author: "Glenn Maughan <glennmaughan@optushome.com.au>"
	copyright: "Copyright (c) 2001 Glenn Maughan and others"
	license: "Eiffel Forum Freeware License v1 (see forum.txt)."

class
	PD

inherit

	KL_SHARED_ARGUMENTS
		export
			{NONE} all
		end

	KL_INPUT_STREAM_ROUTINES
		export
			{NONE} all
		end
      
create
	make

feature -- Initialization

	make
		local
			node_impl: DOM_NODE_IMPL
			writer: DOM_WRITER
			factory: expanded DOM_TREE_BUILDER_FACTORY
		do
			-- check arguments
			parse_arguments
			if arguments_ok then
				parser := factory.create_parser
				parser.parse_from_file_name (file_name)
				-- print the tree
				node_impl ?= parser.document
				create writer
				writer.output(node_impl)
			else
				show_usage
			end
		end
   
feature {NONE} -- Implementation

	parser: DOM_TREE_BUILDER

	arguments_ok: BOOLEAN
			-- Were the command line arguments parsed sucessfully?

	file_name: UC_STRING
			-- Name of file to parse.

	parse_arguments
			-- Parse and validate the command line arguments
		local
			str: STRING
			file: like INPUT_STREAM_TYPE
		do
			if arguments.argument_count = 1 then
				str := arguments.argument (1)
				file := make_file_open_read (str)
				if is_open_read (file) then
					close (file)
					arguments_ok := True
					create file_name.make_from_string (str)
				end
			end
		end

	show_usage
			-- Output usage message to user
		local
			str: STRING
		do
			create str.make_from_string ("Usage: pd <xmlfilename>")
			print (str)
		end 

end -- class PD
