indexing
	description: "XMLE BDV DOM document retriever and displayer"
	project: "Project Goanna <http://sourceforge.net/projects/goanna>"
	library: "BDOM Viewer Tool"
	date: "$Date: 2006-04-16 23:42:40 -0700 (Sun, 16 Apr 2006) $"
	revision: "$Revision: 491 $"
	author: "Glenn Maughan <glennmaughan@optushome.com.au>"
	copyright: "Copyright (c) 2001 Glenn Maughan and others"
	license: "Eiffel Forum Freeware License v1 (see forum.txt)."

class
	BDV

inherit

	KL_SHARED_ARGUMENTS
		export
			{NONE} all
		end
      
creation
	make

feature -- Initialization

	make is
		local
			doc: XMLE_DOCUMENT_WRAPPER
			writer: DOM_SERIALIZER
		do
			-- check arguments
			parse_arguments
			if arguments_ok then
				-- retrieve the object
				file.open_read
				doc ?= file.retrieved
				-- serializer the document
				writer := serializer_factory.serializer_for_document (doc.document)
				writer.set_output (io.output)
				writer.serialize (doc.document)	
			else
				show_usage
			end
		end
   
feature {NONE} -- Implementation

	arguments_ok: BOOLEAN
			-- Were the command line arguments parsed sucessfully?

	name: STRING

	file_name: STRING
			-- Name of file to parse.

	file: FILE
			-- File to read document from.

	parse_arguments is
			-- Parse and validate the command line arguments
		do
			if arguments.argument_count = 1 then
				name := arguments.argument (1)
				create {RAW_FILE} file.make (name + ".bdom")
				if file.exists and file.is_readable then
					arguments_ok := True
					file_name := name + ".bdom"
				end
			end
		end

	show_usage is
			-- Output usage message to user
		local
			str: STRING
		do
			create str.make_from_string ("Usage: bdv <xmleclassname>")
			print (str)
		end 

	serializer_factory: DOM_SERIALIZER_FACTORY is
		once
			create Result
		end
	
feature {NONE} -- DOM storage references

	dom_storage_refs: XMLE_DOM_STORAGE_REFS

end -- class BDV
