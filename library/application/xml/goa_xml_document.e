
note

	description: "An XML Document used to generate HTML within a Web Application"
	author: "Neal L. Lester <neallester@users.sourceforge.net>"
	date: "$Date: 2009-12-23 16:16:29 -0800 (Wed, 23 Dec 2009) $"
	revision: "$Revision: 623 $"
	copyright: "(c) 2004 Neal L. Lester"
	License: "Eiffel Forum License Version 2 (see forum.txt)"

deferred class
	GOA_XML_DOCUMENT

inherit

	KL_SHARED_FILE_SYSTEM
	GOA_SHARED_APPLICATION_CONFIGURATION
	KL_IMPORTED_ARRAY_ROUTINES
	KL_IMPORTED_STRING_ROUTINES
	DT_SHARED_SYSTEM_CLOCK

feature -- Status

	root_element_added: BOOLEAN
			-- Has the root element already been added to the document

	is_complete: BOOLEAN
			-- Is the document complete?
		do
			Result := root_element_added and element_stack.is_empty
		end

	current_element_code: INTEGER
			-- Code representing the current element
		do
			if not element_stack.is_empty then
				Result := element_stack.item
			else
				Result := xml_null_code
			end
		end

	current_element_name: STRING
		do
			Result := element_tag_by_code.item (current_element_code).twin
		end


	current_element_contents: ARRAY [INTEGER]
			-- Codes representing the contents (elements and/or text) of the current element
		do
			if not contents_stack.is_empty then
				Result := contents_stack.item
			else
				Result := (<<>>)
			end
		end

	last_element_is_text: BOOLEAN
			-- Was the last element/text added to the current element text?
		do
			if current_element_contents.is_empty then
				Result := False
			else
				Result := current_element_contents @ current_element_contents.upper = xml_text_code
			end
		end

	xml_text_code: INTEGER
			-- Code representing text content of an XML element
		deferred
		end

	xml_null_code: INTEGER
			-- Code representing no element
		deferred
		end

	current_element_contents_as_string: STRING
		local
			local_index: INTEGER
		do
			Result := ""
			from
				local_index := current_element_contents.lower
			until
				local_index > current_element_contents.upper
			loop
				Result := Result + element_tag_for_code (current_element_contents.item (local_index))
				if not (local_index = current_element_contents.upper) then
					Result := Result + ", "
				end
				local_index := local_index + 1
			end
		end

feature -- Document Manipulation

	add_text (the_text: STRING)
			-- Add the_text to current_element of document
		require
			valid_the_text: the_text /= Void and then not the_text.is_empty
			ok_to_add_text: ok_to_add_element_or_text (xml_text_code)
		do
			writer.add_data (the_text)
			if not last_element_is_text then
				current_element_contents.force (xml_text_code, current_element_contents.upper + 1)
			end
		ensure
			last_element_is_text: last_element_is_text
			if_last_element_was_text_text_not_added: old last_element_is_text implies current_element_contents.count = old current_element_contents.count
			text_element_added_to_content: not old last_element_is_text implies current_element_contents.count = (old current_element_contents.count + 1)
		end

	end_current_element
			-- End the current open element in the document
		require
			open_current_element: current_element_code /= xml_null_code
			valid_current_content: is_valid_element_content (current_element_code, current_element_contents)
		do
			debug ("goa_xml_document")
				io.put_string ("End Current Element: " + element_tag_for_code (current_element_code) + "%N")
			end

			writer.stop_tag
			element_stack.remove
			contents_stack.remove
		end

	add_item (the_item: GOA_XML_ITEM)
			-- Add the_item to document
		require
			ok_to_add: the_item.ok_to_add (Current)
		do
			the_item.add_to_document (Current)
		end

feature -- Output

	as_xml: STRING
			-- The completed document as a string
		require
			input_finished: current_element_code = xml_null_code and root_element_added
		do
			Result := writer.as_string
		ensure
			is_valid_xml: configuration.validate_xml implies is_valid_xml (Result)
		end

	as_html: STRING
			-- Transform the_page to html
		local
			saxon_input_file, xml_file: KI_TEXT_OUTPUT_FILE
			saxon_output_file: KI_TEXT_INPUT_FILE
			shell_command: KL_SHELL_COMMAND
			command_text, temp_file_name, saxon_input_file_name, saxon_output_file_name: STRING
			count: INTEGER
			now: DT_DATE_TIME
			no_conflict_with_input_name, no_conflict_with_output_name: BOOLEAN
			retries, file_name_retries: INTEGER
		do
			if retries < 100 then
				if use_saxon then
					if saxon_input_file /= Void and then saxon_input_file.is_open_write then
						saxon_input_file.close
					end
					if saxon_output_file /= Void and then saxon_output_file.is_open_read then
						saxon_output_file.close
					end
					from
					until
						no_conflict_with_input_name and no_conflict_with_output_name and (file_name_retries < 100)
					loop
						temp_file_name := new_temp_file_name
						saxon_input_file_name := configuration.temp_directory + temp_file_name + "_input.xml"
						saxon_output_file_name := configuration.temp_directory + temp_file_name + "_output.xml"
						no_conflict_with_input_name := not file_system.file_exists (saxon_input_file_name)
						if no_conflict_with_input_name then
							saxon_input_file := file_system.new_output_file (saxon_input_file_name)
							saxon_input_file.open_write
						end
						no_conflict_with_output_name := not file_system.file_exists (saxon_output_file_name)
						file_name_retries := file_name_retries + 1
					end
					saxon_input_file.put_string (as_xml)
					saxon_input_file.close
					command_text := configuration.java_binary_location + " -jar " + configuration.saxon_jar_file_location + " -s " + saxon_input_file_name + " -s " + saxon_input_file_name + " -xsl " + transform_file_name + " > " + saxon_output_file_name
					io.put_string (command_text + "%N")
					create shell_command.make (command_text)
					shell_command.execute
					saxon_output_file := file_system.new_input_file (saxon_output_file_name)
					count := saxon_output_file.count
					saxon_output_file.open_read
					saxon_output_file.read_string (count)
					Result := saxon_output_file.last_string
				else
					if configuration.test_mode then
						xml_file := file_system.new_output_file (configuration.temp_directory + "last_page.htm")
						xml_file.open_write
						xml_file.put_string (writer.as_string)
						xml_file.close
					end
					debug ("xslt_performance")
						now := system_clock.date_time_now
						io.put_string ("Starting Transform: " + now.precise_time_out + "%N")
					end
					Result := transformer.transform_string_to_string (as_xml)
					debug ("xslt_performance")
						now := system_clock.date_time_now
						io.put_string ("Finished Transform: " + now.precise_time_out + "%N")
					end
	 			end
	 		end
 		rescue
 			retries := retries + 1
 			retry
		end

	new_temp_file_name: STRING
		local
			now: DT_DATE_TIME
		do
			now := system_clock.date_time_now
			Result := now.hash_code.out
		end


	put_xml_to_file (file_name: STRING)
			-- Put current document to file named file_name; will generate exception
			-- if unable to open and write to file_name
		require
			valid_file_name: file_name /= Void -- and then file_name represents a writable file on disk
			input_finished: current_element_code = xml_null_code and root_element_added
		local
			the_file: KI_TEXT_OUTPUT_FILE
		do
			the_file := file_system.new_output_file (file_name)
--			create the_file.create_write (file_name)
			the_file.open_write
			the_file.put_string (as_xml)
			the_file.close
		end

	put_html_to_file (file_name: STRING)
			-- Put html version of current document to file named file_name; will generate exception
			-- if unable to open and write to file_name
		require
			valid_file_name: file_name /= Void -- and then file_name represents a writable file on disk
			input_finished: current_element_code = xml_null_code and root_element_added
		local
			the_file: KI_TEXT_OUTPUT_FILE
		do
			the_file := file_system.new_output_file (file_name)
			the_file.open_write
			the_file.put_string (as_html)
			the_file.close
		end

feature -- Validity

	ok_to_add_element_or_text (the_element_code: INTEGER): BOOLEAN
			-- Is code given by the_element a legal element at this position in the document?
			-- use xml_text_code to determine if text is legal at this position of the document
		local
			new_array: ARRAY [INTEGER]
		do
			if the_element_code = xml_text_code and then last_element_is_text then
				Result := True
			else
				new_array := INTEGER_ARRAY_.cloned_array (current_element_contents)
				new_array.force (the_element_code, new_array.upper + 1)
				Result := is_valid_element_content_fragment (current_element_code, new_array)
			end
		end

	are_all_attribute_values_valid (attribute_name_codes: ARRAY[INTEGER]; attribute_values: ARRAY [STRING]): BOOLEAN
			-- Are all entries in attribute_values valid for the corresponding attribute given by attribute_name_code?
		require
			valid_attribute_name_codes: attribute_name_codes /= void and then not attribute_name_codes.has (xml_null_code)
			valid_attribute_values: attribute_values /= Void
		local
			name_index, value_index: INTEGER
		do
			from
				name_index := attribute_name_codes.lower
				Result := True
			until
				name_index > attribute_name_codes.upper or not Result
			loop
				from
					value_index := attribute_values.lower
					Result := False
				until
					value_index > attribute_values.upper or Result
				loop
					Result := is_valid_attribute_value (attribute_name_codes.item (name_index), attribute_values.item (value_index))
					value_index := value_index + 1
				end
				name_index := name_index + 1
			end
		end

	are_all_input_names_valid (input_name_codes, valid_name_codes: ARRAY [INTEGER]): BOOLEAN
			-- Is every entry in input_name_codes contained in valid_name_codes?
		require
			valid_input_name_codes: input_name_codes /= Void
			valid_valid_name_codes: valid_name_codes /= Void
		local
			index: INTEGER
		do
			from
				index := input_name_codes.lower
				Result := True
			until
				index > input_name_codes.upper or not Result
			loop
				Result := valid_name_codes.has (input_name_codes.item (index))
				index := index + 1
			end
		end

	is_valid_element_tag (the_tag: STRING): BOOLEAN
			-- Is the_tag a valid element tag?
		local
			local_the_tag: STRING
		do
			Result := the_tag /= Void
			if Result then
				local_the_tag := STRING_.cloned_string (the_tag)
				local_the_tag.to_lower
				Result := element_code_by_tag.has (local_the_tag)
			end
		end

	is_valid_attribute_name (the_name: STRING): BOOLEAN
			-- Is the_name a valid attribute name?
		local
			local_the_name: STRING
		do
			Result := the_name /= Void
			if Result then
				local_the_name := STRING_.cloned_string (the_name)
				local_the_name.to_lower
				Result := attribute_code_by_name.has (local_the_name)
			end
		end

	is_valid_attribute_value (attribute_name_code: INTEGER; attribute_value: STRING): BOOLEAN
			-- is attribute_value valid for athe attribute given by attribute_name_code
		deferred
		end

	is_valid_element_tag_code (the_code: INTEGER): BOOLEAN
			-- Does the_code represent an element code used in this schema?
		do
			Result := element_tag_by_code.has (the_code)
		end

	is_valid_attribute_name_code (the_code: INTEGER): BOOLEAN
			-- Does the_code represent an attribute name code used in this schema?
		do
			Result := attribute_name_by_code.has (the_code)
		end

	is_valid_element_content (the_element_code: INTEGER; the_content: ARRAY [INTEGER]): BOOLEAN
		deferred
		end

	is_valid_element_content_fragment (the_element_code: INTEGER; the_content: ARRAY [INTEGER]): BOOLEAN
		deferred
		end

feature -- Code and Tag/Name Cross Reference

	element_tag_for_code (the_code: INTEGER): STRING
			-- The element tag corresponding with the_code
		require
			valid_the_code: is_valid_element_tag_code (the_code)
		do
			Result := element_tag_by_code.item (the_code)
		end

	element_code_for_tag (the_tag: STRING): INTEGER
			-- The element code corresponding to the_tag
		require
			is_valid_element_tag: is_valid_element_tag (the_tag)
		local
			local_the_tag: STRING
		do
			local_the_tag := STRING_.cloned_string (the_tag)
			local_the_tag.to_lower
			Result := element_code_by_tag.item (local_the_tag)
		end

	attribute_code_for_name (the_name: STRING): INTEGER
			-- The attribute code corresponding to the_name
		require
			is_valid_attribute_name: is_valid_attribute_name (the_name)
		local
			local_the_name: STRING
		do
			local_the_name := STRING_.cloned_string (the_name)
			local_the_name.to_lower
			Result := attribute_code_by_name.item (local_the_name)
		end

	attribute_name_for_code (the_code: INTEGER): STRING
			-- The attribute name corresponding with the_code
		require
			valid_the_code: is_valid_attribute_name_code (the_code)
		do
			Result := attribute_name_by_code.item (the_code)
		end

feature {NONE} -- Implementation

	attribute_code_by_name: DS_HASH_TABLE [INTEGER, STRING]
			-- Attribute codes, keyed by attribute name
		deferred
		end

	element_code_by_tag: DS_HASH_TABLE [INTEGER, STRING]
			-- Element codes, keyed by element tag
		deferred
		end

	element_tag_by_code: DS_HASH_TABLE [STRING, INTEGER]
			-- Element tags, keyed by element code
		deferred
		end

	attribute_name_by_code: DS_HASH_TABLE [STRING, INTEGER]
			-- Attribute names, keyed by attribute code
		deferred
		end

feature -- Options

	reset_to_iso_8859_1_encoded
			-- Reset (clear document); start new as a ISO 8859-1 encoded document
		do
			make_iso_8859_1_encoded
		end

	reset_to__utf8_encoded
			-- Reset (clear document); start new as a UTF8 encoded document
		do
			make_utf8_encoded
		end

feature -- {NONE} -- Implementation

	element_stack: DS_LINKED_STACK [INTEGER]
			-- Stack containing codes representing the currently open elements in the document

	contents_stack: DS_LINKED_STACK [ARRAY [INTEGER]]
			-- Stack containing codes representing the contents of all currently open elements in the document

	writer: GOA_XML_WRITER
			-- Implements creatino of the XML document

feature {NONE} -- Transformation

	use_saxon: BOOLEAN
			-- Should we use Saxon to render the xml using xslt?
		do
			Result := configuration.use_saxon
		end

	transform_file_name: STRING
			-- Name of file containing XSLT transform to generate html version of this document
		deferred
		end

	schema_file_name: STRING
			-- Name of file containing Relax NG schema for this document
		deferred
		end

	xslt_transformer_factory: GOA_XSLT_TRANSFORMER_FACTORY
			-- Where new XSLT Transformers come from
		do
			create Result.make_without_configuration
			-- If this is a once function, GEXSLT retains references and bloats memory usage
		end

	transformer: GOA_XSLT_STRING_TRANSFORMER
			-- Transformer used to generate HTML from this pages XML
		do
			if transformers.has (transform_file_name) then
				Result := transformers.item (transform_file_name)
			else
				Result := xslt_transformer_factory.new_string_transformer_from_file_name (transform_file_name)
				-- If we reuse transformers, GEXSLT retains references and bloats memory usage
				transformers.force (Result, transform_file_name)
			end
		end

	transformers: DS_HASH_TABLE [GOA_XSLT_STRING_TRANSFORMER, STRING]
			-- Transformers indexed by transform_file_name
		once
			create Result.make_equal (5)
		end

	is_valid_xml (xml: STRING): BOOLEAN
			-- Does xml conform to the relaxng schema at schema_file_name?
		require
			valid_xml: xml /= Void
		local
			file: PLAIN_TEXT_FILE
			xml_file_name, jing_execution_string: STRING
			shell_command: KL_SHELL_COMMAND
		do
			xml_file_name := configuration.temp_directory + "temp.xml"
			create file.make_open_write (xml_file_name)
			file.put_string (xml + "%N")
			file.close
			jing_execution_string := configuration.jing_invocation + " " + schema_file_name + " temp.xml >> /dev/null"
			create shell_command.make (jing_execution_string)
			shell_command.execute
			Result := shell_command.exit_code = 0
		end

feature {NONE} -- Creation

	make_iso_8859_1_encoded
			-- Creation; as a ISO 8859-1 encoded document
		do
			initialize
			writer.add_header_iso_8859_1_encoding
		end

	make_utf8_encoded
			-- Creation; as a UTF8 encoded document
		do
			initialize
			writer.add_header_utf_8_encoding
		end

	initialize
			-- Establish Invariant
		do
			create element_stack.make_equal
			create contents_stack.make_equal
			contents_stack.put (<<>>)
			create writer.make
			root_element_added := False
		end

invariant

	valid_element_stack: element_stack /= Void
	valid_contents_stack: contents_stack /= Void

end -- class GOA_SCHEMA_CODES



