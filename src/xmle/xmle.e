note
	description: "XML to Eiffel Compiler"
	project: "Project Goanna <http://sourceforge.net/projects/goanna>"
	library: "XMLE Tool"
	date: "$Date: 2006-04-16 23:42:40 -0700 (Sun, 16 Apr 2006) $"
	revision: "$Revision: 491 $"
	author: "Glenn Maughan <glennmaughan@optushome.com.au>"
	copyright: "Copyright (c) 2001 Glenn Maughan and others"
	license: "Eiffel Forum Freeware License v1 (see forum.txt)."

class
	XMLE

inherit

	KL_SHARED_ARGUMENTS
		export
			{NONE} all
		end
      
create
	make

feature -- Initialization

	make
		local
			factory: DOM_TREE_BUILDER_FACTORY
		do
			-- check arguments
			parse_arguments
			if arguments_ok then
				parser := factory.create_parser
				print ("Parsing file: " + file_name.out + "...%R%N")
				parser.parse_from_file_name (file_name)
				if parser.last_error = parser.Xml_err_none then
					print ("Normalizing document...%R%N")
					parser.document.normalize
					print ("Generating Eiffel code...%R%N")
					generate_eiffel_code (parser.document)
					print ("XMLE compilation complete.%R%N")
					if display_xml then
						display_dom_tree (parser.document)
					end
				else
					display_parser_error
				end
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

	display_xml: BOOLEAN
			-- Should the resulting DOM be displayed?
			
	parse_arguments
			-- Parse and validate the command line arguments
		local
			str: STRING
			file: FILE
		do
			Arguments.set_option_sign ('-')
			if Arguments.argument_count >= 1 then
				str := Arguments.argument (1)
				create {PLAIN_TEXT_FILE} file.make (str)
				if file.exists and file.is_readable then
					arguments_ok := True
					create file_name.make_from_string (str)
				end
				if Arguments.separate_word_option_value ("display") /= Void then
					display_xml := True
				end
			end
		end

	show_usage
			-- Output usage message to user
		local
			str: STRING
		do
			create str.make_from_string ("Usage: xmle <xmlfilename> [-display]")
			print (str)
		end 

	display_parser_error
			-- Output parsing error
		do
			print ("XML parser error: " + parser.last_error_description
				+ " (" + parser.last_error_extended_description + ")")
			print ("At position: " + parser.position.out)
		end

	generate_eiffel_code (document: DOM_DOCUMENT)
			-- Generate an XMLE Eiffel class to build the parsed DOM structure
		require
			document_exists: document /= Void
		local
			code_generator: CODE_GENERATOR
		do
			create code_generator.make (document.document_element.node_name.out)
			code_generator.generate (document)
		end

	display_dom_tree (document: DOM_DOCUMENT)
			-- Display dom tree to standard out.
		require
			document_exists: document /= Void	
		local
			writer: DOM_SERIALIZER
		do
			writer := serializer_factory.serializer_for_document (document)
			writer.set_output (io.output)
			writer.serialize (document)		
		end
	
	serializer_factory: DOM_SERIALIZER_FACTORY
		once
			create Result
		end
	
feature {NONE} -- DOM object references

	dom_storage_refs: XMLE_DOM_STORAGE_REFS

end -- class XMLE
