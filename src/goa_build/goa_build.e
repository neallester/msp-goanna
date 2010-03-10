indexing
	description: "Root class for goa_build; create XML authoring classes for Goana web applications"
	author: "Neal L Lester [neal@3dsafety.com]"
	date: "$Date: 2007-06-14 13:52:06 -0700 (Thu, 14 Jun 2007) $"
	revision: "$Revision: "
	copyright: "Copyright (c) Neal L. Lester"
	License: "Eiffel Forum License Version 2 (see forum.txt)"

class
	GOA_BUILD

inherit

	KL_SHARED_ARGUMENTS
	KL_SHARED_EXCEPTIONS
	KL_SHARED_FILE_SYSTEM
	KL_SHARED_OPERATING_SYSTEM
	KL_SHARED_EXECUTION_ENVIRONMENT
	XM_SHARED_CATALOG_MANAGER
	KL_IMPORTED_STRING_ROUTINES

create

	make

feature -- Initialization

-- OVERVIEW

-- This class builds Eiffel Classes that are used to author XML for Goanna Applications
-- from an RNC schema. Features for creating each element of the schema are created.
-- Schema validity rules are written as preconditions for these features.
-- The eiffel classes generated are:
-- NAMESPACE_PREFIX_XML_DOCUMENT
--   This is the primary class representing the schema.  For included schemas, this
--   is a deferred class including deferred features for the schema codes and
--   attribute and element tags used in the schema.
-- NAMESPACE_PREFIX_SCHEMA_CODES
--   Generated only for document schemas.  Contains integer codes representing
--   elements and attributes in the schema and string constants for the
--   element and attribute names
-- NAMESPACE_ATTRIBUTE_VALUES
--   Contains string constants for all attribute values declared as a choice of constants
--   e.g. att1 = attribute att1 = { "value1" | "value2" }
--   The "class" attribute is a special case.  These value constants are generated
--   by inspecting the css stylesheet associated with the schema (through a stylesheet
--   declaration included in a comment) and generating a string constant for
--   each class found in the css stylesheet.
--   e.g. class_error_message: STRING is "error_message"


-- The steps are:

-- validate command line options from user
-- Unless user specified the --norefresh option
--   copy XSL transforms used by goa_build to current directory
--   copy goa provided rnc schemas, xsl transforms, and css files to current directory
--   copy goa provided xsl transforms to data directory
--   copy goa provided xml_documents_extended to eiffel directory
-- For each document schema file specifed in the parameter list
--   expand CLASS_ATTRIBUTE_PLACEHOLDER with class attribute value declaration (if needed)
--   use trang to convert rnc file to rng
--   combine included schemas into a single file using flatten_1.xsl
--   add any included files to a list (for future processing)
--   merge any elements/attributes duplicated because they are
--   Identify included files; add them to master list and write
--   them to namespace_prefix.imp which is used by subsequent
--   transforms to avoid generating features for features
--   inherited from included schemas
--   Merge duplicated elements combined from two schemas
--   (rnc |= operator) using flatten_2.xsl
--   Remove included file declarations using flatten_3.xsl
--   and write results to data directory as namespace_prefix.frng
--   generate NAMESPACE_PREFIX_XML_DOCUMENT using validating_xml_writer.xsl
--   generate NAMESPACE_PREFIX_SCHEMA_CODES using schema_codes.xsl
--   generate NAMESPACE_PREFIX_ATTRIBUTE_VALUES using attribute_values.xsl
--   attempt to compile the XSL file namespace_prefix.xsl and inform
--   user of any problems with the transform
-- For each included schema file
--   build list of included stylesheet declarations to exlude
--   those included class names from the class name declaration
--   and write to file
--   append class value declaration to rnc file
--   generate NAMSAPCE_PREFIX_XML_DOCUMENT using deferred_xml_writer.xsl
--   generate NAMESPACE_PREFIX_ATTRIBUTE_VALUES using attribute_values.xsl
-- Copy all document and included schema xsl files to the data directory
-- Clean up

	make is
		local
			exception_occurred, current_directory_has_goa_common_xsl: BOOLEAN
			error_message, trang_invocation, class_attribute_declaration: STRING
			file_name, expanded_file_name, namespace_prefix, rnc_file_contents, rnc_file_contents_upper: STRING
			local_unreadable_files, file_names, included_files, included_xsl_files, local_included_rng_files: DS_LIST [STRING]
			rnc_input_file, rng_input_file, xsl_input_file, included_rng_file: KI_TEXT_INPUT_FILE
			temp_output_file: KI_TEXT_OUTPUT_FILE
			rnc_file_length, rng_file_length, xsl_file_length, included_rng_file_length: INTEGER
			class_names, all_included_rng_files, xsl_files, prefixes, included_rng_files: DS_LINKED_LIST [STRING]
			final_file_name, rng_file_name, expanded_stylesheet_file_name, target_eiffel_directory_name, target_data_directory_name: STRING
			trang_command: KL_SHELL_COMMAND
			rng_file_contents, flat1, flat2, flat3, included, imported, imported_file_name, frng_file_name, xsl_file_name: STRING
			xml_document_contents, schema_codes_contents, attribute_values_contents, xsl_file_contents, included_xsl_files_string, included_rng_file_contents: STRING
			xml_document_file_name, schema_codes_file_name, attribute_values_file_name, data_directory, rnc_input_file_name: STRING
			temporary_transformer: GOA_XSLT_STRING_TRANSFORMER
		do
			if not exception_occurred then
				command_line_parser.parse_arguments
				if command_line_parser.error_handler.has_error then
					io.put_string (help_usage)
				elseif command_line_includes_goa_switch and command_line_includes_parameters then
					io.put_string ("You may not specify file name(s) with the -g (--goa) option%N")
					io.put_string (help_usage)
				elseif  not command_line_includes_goa_switch and not command_line_includes_parameters then
					io.put_string ("You must specify one or more file names (unless using the -g (--goa) option)%N")
					io.put_string (help_usage)
				elseif command_line_includes_parameters and then not unreadable_files (command_line_parser.parameters).is_empty then
					-- Some of the files specified in the parameter list
					io.put_string ("The file(s) ")
					local_unreadable_files := unreadable_files (command_line_parser.parameters)
					from
						local_unreadable_files.start
					until
						local_unreadable_files.after
					loop
						io.put_string (local_unreadable_files.item_for_iteration)
						if not local_unreadable_files.is_last then
							io.put_string (", ")
						else
							io.put_string (" ")
						end
						local_unreadable_files.forth
					end
					io.put_string ("cannot be read%N" + help_usage)
				elseif command_line_includes_eiffeldirectory_switch and then not exactly_one_eiffeldirectory_argument then
					io.put_string ("-e (--eiffeldirectory) may contain only one argument.  Enclosing a path containing spaces may work%N" + help_usage)
				elseif command_line_includes_eiffeldirectory_switch and then not file_system.directory_exists (execution_environment.interpreted_string(eiffeldirectory_argument)) then
					io.put_string ("directory " + eiffeldirectory_argument + " specified in -e (--eiffeldirectory) argument does not exist%N" + help_usage)
				elseif command_line_includes_datadirectory_switch and then not exactly_one_datadirectory_argument then
					io.put_string ("-d (--datadirectory) may contain only one argument.  Enclosing a path containing spaces may work%N" + help_usage)
				elseif command_line_includes_datadirectory_switch and then not file_system.directory_exists (execution_environment.interpreted_string(datadirectory_argument)) then
					io.put_string ("directory " + datadirectory_argument + " specified in -d (--datadirectory) argument does not exist%N" + help_usage)
				elseif command_line_includes_author_switch and then not exactly_one_author_argument then
					io.put_string ("Please enclose the -a (--author) argument in quotes%N" + help_usage)
				elseif command_line_includes_copyright_switch and then not exactly_one_copyright_argument then
					io.put_string ("Please enclose the -c (--copyright) argument in quotes%N" + help_usage)
				elseif command_line_includes_license_switch and then not exactly_one_license_argument then
					io.put_string ("Please enclose the -l (--license) argument in quotes%N" + help_usage)
				else
					-- It appears we are OK to process; we only haven't verified that the output directories are
					-- Writable (I can't find a library routine to do this)
						-- TODO Copy list should be read from an XML file.  This would allow us to
						-- Change the copy list without recompiling this application
					if command_line_includes_eiffeldirectory_switch then
						target_eiffel_directory_name := eiffeldirectory_argument
					else
						target_eiffel_directory_name := file_system.current_working_directory
					end
					if command_line_includes_datadirectory_switch then
						target_data_directory_name := datadirectory_argument
					else
						target_data_directory_name := file_system.current_working_directory
					end
					if command_line_includes_parameters or command_line_includes_goa_switch then
						file_system.copy_file (execution_environment.interpreted_string ("$GOANNA/src/goa_build/transform/common.xsl"), "common.xsl")
						file_system.copy_file (execution_environment.interpreted_string ("$GOANNA/src/goa_build/transform/attribute_values.xsl"), "attribute_values.xsl")
						file_system.copy_file (execution_environment.interpreted_string ("$GOANNA/src/goa_build/transform/schema_codes.xsl"), "schema_codes.xsl")
						file_system.copy_file (execution_environment.interpreted_string ("$GOANNA/src/goa_build/transform/validating_xml_writer.xsl"), "validating_xml_writer.xsl")
						file_system.copy_file (execution_environment.interpreted_string ("$GOANNA/src/goa_build/transform/deferred_xml_writer.xsl"), "deferred_xml_writer.xsl")
						file_system.copy_file (execution_environment.interpreted_string ("$GOANNA/src/goa_build/transform/flatten_1.xsl"), "flatten_1.xsl")
						file_system.copy_file (execution_environment.interpreted_string ("$GOANNA/src/goa_build/transform/flatten_2.xsl"), "flatten_2.xsl")
						file_system.copy_file (execution_environment.interpreted_string ("$GOANNA/src/goa_build/transform/flatten_3.xsl"), "flatten_3.xsl")
						file_system.copy_file (execution_environment.interpreted_string ("$GOANNA/src/goa_build/transform/include_list.xsl"), "include_list.xsl")
						file_system.copy_file (execution_environment.interpreted_string ("$GOANNA/src/goa_build/transform/xsl_include_list.xsl"), "xsl_include_list.xsl")
						file_system.copy_file (execution_environment.interpreted_string ("$GOANNA/src/goa_build/transform/imported.xsl"), "imported.xsl")
						file_system.copy_file (execution_environment.interpreted_string ("$GOANNA/library/application/xml/goa_common/goa_common.rnc"), "goa_common.rnc")
						current_directory_has_goa_common_xsl := file_system.file_exists ("goa_common.xsl")
						file_system.copy_file (execution_environment.interpreted_string ("$GOANNA/library/application/xml/goa_common/goa_common.xsl"), "goa_common.xsl")
						file_system.copy_file (execution_environment.interpreted_string ("$GOANNA/library/application/xml/goa_common/goa_common.css"), "goa_common.css")
					end
					if not command_line_includes_norefresh_switch then
						if command_line_includes_verbose_switch then
							io.put_string ("Refreshing Goanna Files%N")
						end
						file_system.copy_file (execution_environment.interpreted_string ("$GOANNA/library/application/xml/goa_common/goa_common.xsl"), file_system.pathname (target_data_directory_name, "goa_common.xsl"))
						file_system.copy_file (execution_environment.interpreted_string ("$GOANNA/library/application/xml/goa_redirect/goa_redirect.xsl"), file_system.pathname (target_data_directory_name, "goa_redirect.xsl"))
						file_system.copy_file (execution_environment.interpreted_string ("$GOANNA/library/application/xml/goa_page/goa_page.xsl"), file_system.pathname (target_data_directory_name, "goa_page.xsl"))
						file_system.copy_file (execution_environment.interpreted_string ("$GOANNA/library/application/xml/goa_redirect/goa_redirect.frng"), file_system.pathname (target_data_directory_name, "goa_redirect.frng"))
						file_system.copy_file (execution_environment.interpreted_string ("$GOANNA/library/application/xml/goa_page/goa_page.frng"), file_system.pathname (target_data_directory_name, "goa_page.frng"))
					end
					if command_line_includes_parameters or command_line_includes_goa_switch then
						-- Read value of environment variable TRANG_INVOCATION
						trang_invocation := execution_environment.variable_value ("TRANG_INVOCATION")
						if trang_invocation = Void then
							trang_invocation := "trang"
						end
						if command_line_includes_verbose_switch then
							io.put_string ("Initializing XSLT transformers%N")
						end
						-- Set prefixes for XSLT Transformers that generate eiffel classes
						if command_line_includes_author_switch then
							validating_xml_writer_transformer.set_string_parameter (author_argument, "author")
							deferred_xml_writer_transformer.set_string_parameter (author_argument, "author")
							schema_codes_transformer.set_string_parameter (author_argument, "author")
							attribute_values_transformer.set_string_parameter (author_argument, "author")
						end
						if command_line_includes_copyright_switch then
							validating_xml_writer_transformer.set_string_parameter (copyright_argument, "copyright")
							deferred_xml_writer_transformer.set_string_parameter (copyright_argument, "copyright")
							schema_codes_transformer.set_string_parameter (copyright_argument, "copyright")
							attribute_values_transformer.set_string_parameter (copyright_argument, "copyright")
						end
						if command_line_includes_license_switch then
							validating_xml_writer_transformer.set_string_parameter (license_argument, "license")
							deferred_xml_writer_transformer.set_string_parameter (license_argument, "license")
							schema_codes_transformer.set_string_parameter (license_argument, "license")
							attribute_values_transformer.set_string_parameter (license_argument, "license")
						end
						-- Initialize file name lists
						if command_line_includes_parameters then
							file_names := command_line_parser.parameters
						else
							file_names := create {DS_LINKED_LIST [STRING]}.make_equal
						end
						create all_included_rng_files.make_equal
						create prefixes.make_equal
						create xsl_files.make_equal
						from
							file_names.start
						until
							file_names.after
						loop
							file_name := file_names.item_for_iteration
							expanded_file_name := execution_environment.interpreted_string (file_name)
							if command_line_includes_verbose_switch then
								io.put_string ("Processing file " + expanded_file_name + "%N")
							end
							if file_name.has ('.') then
								namespace_prefix := file_name.substring (1, file_name.index_of ('.', 1) -1)
							else
								namespace_prefix := file_name
							end
							prefixes.force_last (namespace_prefix)
							-- Set prefix parameter for each stylesheet
							validating_xml_writer_transformer.set_string_parameter (namespace_prefix, "prefix")
							schema_codes_transformer.set_string_parameter (namespace_prefix, "prefix")
							attribute_values_transformer.set_string_parameter (namespace_prefix, "prefix")
							-- Read contents of file
							rnc_input_file := file_system.new_input_file (execution_environment.interpreted_string(file_name))
							rnc_file_length := rnc_input_file.count
							rnc_input_file.open_read
							rnc_input_file.read_string (rnc_file_length)
							rnc_file_contents := rnc_input_file.last_string
							rnc_file_contents_upper := rnc_file_contents.as_upper
							expanded_stylesheet_file_name := stylesheet_file_name (rnc_file_contents)
							if rnc_file_contents_upper.has_substring ("INCLUDE")
								and then not rnc_file_contents_upper.has_substring ("NONNEGATIVEINTEGER") then
								-- For reasons I don't understand (bug in trang or xmllint?), a grammar that includes another
								-- grammar that uses xsd:nonNegativeInteger must contain at least one such attribute in the
								-- top level grammar or xmllint will not properly validate the file given the
								-- Relax NG files created by trang.  Simply adding the datatypeLibrary namespace declaration
								-- to the top level grammar (which I think should work) isn't enough.
								-- Of course this test is unncessarily restrictive; it is really required only if the
								-- Included grammar (recursively) uses xsd:nonNegativeInteger but it's too much bother to figure
								-- that out at this point in the processing just to avoid an occasional spurious dummy attribute
								-- in the top level gramamr.  Most of the time folks will be including the goa_common.rnc grammar
								-- and it does use NONNEGATIVEINTEGER.
								io.put_string (	"Unable to process file " + file_name + "; please add %"dummy = attribute dummy %
												%{ xsd:nonNegativeInteger }%" ")
								if not rnc_file_contents_upper.has_substring ("XMLSCHEMA-DATATYPES") then
									io.put_string ("and%Nnamespace datatypeLibrary=%"http://www.w3.org/2001/XMLSchema-datatypes%N%"")
								end
								io.put_string ("to the (top level) grammar.%N")
							elseif stylesheet_declaration_matcher.has_matched and then not rnc_file_contents_upper.has_substring (class_attribute_placeholder) then
								-- Stylesheet declaration does have not have a matching CLASS_ATTRIBUTE_PLACEHOLDER
								io.put_string ("Please add %"" + class_attribute_placeholder + "%" to the " + file_name + " grammar or remove it%'s css stylesheet declaration.")
							elseif rnc_file_contents_upper.has_substring (class_attribute_placeholder) and then not stylesheet_declaration_matcher.has_matched then
								-- CLASS_ATTRIBUTE_PLACEHOLDER does not have a matching stylesheet declaration
								io.put_string ("Please add a css stylesheet declaration to " + file_name + " or remove it%'s " + class_attribute_placeholder + ".%N")
							elseif 	rnc_file_contents_upper.has_substring (class_attribute_placeholder) and then
									rnc_file_contents_upper.substring (rnc_file_contents.substring_index (class_attribute_placeholder, 1) + class_attribute_placeholder.count, rnc_file_contents_upper.count).has_substring (class_attribute_placeholder) then
								-- There are two CLASS_ATTRIBUTE_PLACEHOLDERs
								io.put_string ("Please include only one CLASS_ATTRIBUTE_PLACEHOLDER in the file " + file_name + "%N")
							elseif expanded_stylesheet_file_name /= Void and then expanded_stylesheet_file_name.has ('%"') then
								-- I believe (after only passing analysis) that should only occur if there are multiple stylesheet declaration
								io.put_string ("Please include only one css stylesheet declaration in file " + file_name + ".%N")
							elseif expanded_stylesheet_file_name /= Void and then not file_system.is_file_readable (expanded_stylesheet_file_name) then
								-- Is declared stylesheet readable?
								io.put_string ("The css stylesheet (" + expanded_stylesheet_file_name + ") declared in file " + file_name + " is not readable.%N")
							else
								if expanded_stylesheet_file_name /= Void then
									-- Read the stylesheet and build the corresponding class attribute value declaration
									-- Replace CLASS_ATTRIBUTE_PLACEHOLDER with this attribute value declaration
									if command_line_includes_verbose_switch then
										io.put_string ("  Inserting class attribute value declaration for	css stylesheet " + expanded_stylesheet_file_name + " in file " + expanded_file_name + "%N")
									end
									class_names := stylesheet_class_names (expanded_stylesheet_file_name)
									class_attribute_declaration := ""
									from
										class_names.start
									until
										class_names.after
									loop
										if class_attribute_declaration.is_empty then
											class_attribute_declaration.append_string ("class = attribute class { ")
										else
											class_attribute_declaration.append_string (" | ")
										end
										class_attribute_declaration.append_string ("%"" + class_names.item_for_iteration + "%"")
										class_names.forth
									end
									if not class_attribute_declaration.is_empty then
										class_attribute_declaration.extend ('}')
										rnc_file_contents.replace_substring_all (class_attribute_placeholder, class_attribute_declaration)
										final_file_name := "temp.rnc"
										error_message := "Unable to write file " + final_file_name
										put_string_to_current_directory (final_file_name, rnc_file_contents)
										error_message := Void
									else
										final_file_name := file_name
									end
								else
									final_file_name := file_name
								end

								if command_line_includes_verbose_switch then
									io.put_string ("  Converting " + expanded_file_name + " to Relax NG with trang%N")
								end
								rng_file_name := namespace_prefix + ".rng"
								create trang_command.make (trang_invocation + " -I rnc -O rng " + final_file_name + " " + rng_file_name )
								trang_command.execute
								if trang_command.is_system_code or trang_command.exit_code /= 0 then
									io.putstring ("Trang failed; unable to process file " + expanded_file_name + "%N")
								else
									-- XSLT Transformations
									error_message := "Unable to open file " + final_file_name + " for reading."
									rng_input_file := file_system.new_input_file (rng_file_name)
									rng_file_length := rng_input_file.count
									rng_input_file.open_read
									rng_input_file.read_string (rng_file_length)
									rng_file_contents := rng_input_file.last_string
									error_message := Void
									if command_line_includes_verbose_switch then
										io.put_string ("  Flatten Stage 1%N")
									end
									flat1 := flatten_stage_1_transformer.transform_string_to_string (rng_file_contents)
									if command_line_includes_verbose_switch then
										io.put_string ("  Included file names%N")
									end
									-- Identify included files; add them to all_included_rng_file list
									included := include_list_transformer.transform_string_to_string (flat1)
									if included /= Void and then not included.is_empty then
										included_files := pipe_separated_splitter.split (included)
										from
											included_files.start
										until
											included_files.after
										loop
											if not all_included_rng_files.has (included_files.item_for_iteration) then
												all_included_rng_files.force_last (included_files.item_for_iteration)
											end
											included_files.forth
										end
									end
									if command_line_includes_verbose_switch then
										io.put_string ("  Flatten Stage 2%N")
									end
									flat2 := flatten_stage_2_transformer.transform_string_to_string (flat1)
									put_string_to_current_directory (namespace_prefix + ".fl2", flat2)
									if command_line_includes_verbose_switch then
										io.put_string ("  Imported%N")
									end
									-- Write imported information to imp file; to be used by subsequent transformations
									imported := imported_transformer.transform_string_to_string (flat2)
									imported_file_name := namespace_prefix + ".imp"
									error_message := "Unable to write file " + imported_file_name
									put_string_to_current_directory (imported_file_name, imported)
									error_message := Void
									if command_line_includes_verbose_switch then
										io.put_string ("  Flatten stage 3%N")
									end
									flat3 := flatten_stage_3_transformer.transform_string_to_string (flat2)
									frng_file_name := namespace_prefix + ".frng"
									if command_line_includes_verbose_switch then
										io.put_string ("  Writing " + frng_file_name + "%N")
									end
									error_message := "Unable to write file " + frng_file_name
									if command_line_includes_datadirectory_switch then
										error_message.append (" in " + datadirectory_argument)
									end
									put_string_to_data_directory (frng_file_name, flat3)
									error_message := Void
									-- Write included class values declarations to file
									-- for use by subsequent transformations
									write_included_class_values (included_files)
									-- Generate Eiffel xml_document, schema_codes Files, and attribute_values
									xml_document_file_name := namespace_prefix + "_xml_document.e"
									if command_line_includes_verbose_switch then
										io.put_string ("  Creating " + xml_document_file_name + "%N")
									end
									error_message := "Unable to write " + xml_document_file_name
									xml_document_contents := validating_xml_writer_transformer.transform_string_to_string (flat2)
									error_message := "Unable to write " + xml_document_file_name
									put_string_to_eiffel_directory (xml_document_file_name, xml_document_contents)
									error_message := Void
									schema_codes_file_name := namespace_prefix + "_schema_codes.e"
									if command_line_includes_verbose_switch then
										io.put_string ("  Creating " + schema_codes_file_name + "%N")
									end
									schema_codes_contents := schema_codes_transformer.transform_string_to_string (flat2)
									error_message := "Unable to write " + schema_codes_file_name
									put_string_to_eiffel_directory (schema_codes_file_name, schema_codes_contents)
									error_message := Void
									attribute_values_file_name := namespace_prefix + "_attribute_values.e"
									if command_line_includes_verbose_switch then
										io.put_string ("  Creating " + attribute_values_file_name + "%N")
									end
									attribute_values_contents := attribute_values_transformer.transform_string_to_string (rng_file_contents)
									error_message := "Unable to write " + attribute_values_file_name
									put_string_to_eiffel_directory (attribute_values_file_name, attribute_values_contents)
									error_message := Void
								end
								-- Test associated XSLT file to verify it compiles correctly
								xsl_file_name := namespace_prefix + ".xsl"
								if not file_system.file_exists (xsl_file_name) then
									io.put_string ("Warning, no xsl file corresponding to " + file_name + "%N")
								else
									if command_line_includes_verbose_switch then
										io.put_string ("  Compiling " + xsl_file_name + "%N")
									end
									temporary_transformer := transformer_factory.new_string_transformer_from_file_name (xsl_file_name)
									-- Add XSLT file name to xsl_files to copy to data directory later
									xsl_files.force_last (xsl_file_name)
								end
							end
							if not command_line_includes_trash_switch then
								file_name := namespace_prefix + ".imp"
								if file_system.file_exists (file_name) then
									file_system.delete_file (file_name)
								end
								file_name := namespace_prefix + ".fl2"
								if file_system.file_exists (file_name) then
									file_system.delete_file (file_name)
								end
								if file_system.file_exists (imported_class_values_file_name) then
									file_system.delete_file (imported_class_values_file_name)
								end
							end
							file_names.forth
						end
						-- create deferred xml_document.e and attribute_values.e for each included rng file
						if command_line_includes_verbose_switch and not all_included_rng_files.is_empty then
							io.put_string ("Generating deferred classes and attribute_values for included rnc files%N")
						end
						if command_line_includes_goa_switch then
							all_included_rng_files.force_last ("goa_common.rng")
						end
						from
							all_included_rng_files.start
						until
							all_included_rng_files.after
						loop
							rng_file_name := all_included_rng_files.item_for_iteration
							namespace_prefix := rng_file_name.substring (1, rng_file_name.index_of ('.', 1) -1)
							prefixes.force_last (namespace_prefix)
							if command_line_includes_goa_switch or not equal (namespace_prefix, "goa_common") then
								-- First check associated rnc file for a stylesheet declaration.
								-- If it is present, build an xml file containing the attribute values declaration
								-- for each class in the stylesheet.  Write this to the document imported_class_values_file_name
								rnc_input_file_name := namespace_prefix + ".rnc"
								rnc_input_file := file_system.new_input_file (rnc_input_file_name)
								error_message := "Unable to open file " + rnc_input_file_name + "%N"
								rnc_file_length := rnc_input_file.count
								rnc_input_file.open_read
								rnc_input_file.read_string (rnc_file_length)
								rnc_file_contents := rnc_input_file.last_string
								error_message := Void
								expanded_stylesheet_file_name := stylesheet_file_name (rnc_file_contents)
								if expanded_stylesheet_file_name = Void then
									final_file_name := namespace_prefix + ".rng"
								elseif expanded_stylesheet_file_name /= Void and then not (file_system.file_exists (expanded_stylesheet_file_name) and then file_system.is_file_readable (expanded_stylesheet_file_name)) then
									io.put_string ("The stylesheet " + expanded_stylesheet_file_name + " declared in " + rnc_input_file_name + " is not readable%N")
								else
									class_names := stylesheet_class_names (expanded_stylesheet_file_name)
									if class_names.is_empty then
										io.put_string ("Warning: stylesheet " + expanded_stylesheet_file_name + " contains no CSS classes%N")
										final_file_name := namespace_prefix + ".rng"
									else
										temp_output_file := file_system.new_output_file ("temp.rnc")
										temp_output_file.open_write
										temp_output_file.put_string (rnc_file_contents)
										temp_output_file.put_new_line
										temp_output_file.put_string ("class = attribute class { ")
										from
											class_names.start
										until
											class_names.after
										loop
											temp_output_file.put_string ("%"" + class_names.item_for_iteration + "%"")
											if not class_names.is_last then
												temp_output_file.put_string (" | ")
											end
											class_names.forth
										end
										temp_output_file.put_string (" }")
										temp_output_file.put_new_line
										temp_output_file.close
										create trang_command.make (trang_invocation + " -I rnc -O rng " + " temp.rnc " + "temp.rng" )
										trang_command.execute
										if trang_command.is_system_code or trang_command.exit_code /= 0 then
											io.putstring ("Trang failed; unable to process included file file " + namespace_prefix + ".rnc%N")
											final_file_name := Void
										else
											final_file_name := "temp.rng"
										end
									end
								end
								if final_file_name /= Void then
									error_message := "Unable to open file " + rng_file_name + " for reading."
									rng_input_file := file_system.new_input_file (final_file_name)
									rng_file_length := rng_input_file.count
									rng_input_file.open_read
									rng_input_file.read_string (rng_file_length)
									rng_file_contents := rng_input_file.last_string
									error_message := Void
									-- Find (recursively) all included files; write included class values
									-- declarations to file
									create included_rng_files.make_equal
									included := include_list_transformer.transform_string_to_string (rng_file_contents)
									if included /= Void and then not included.is_empty then
										included_rng_files.append_last (pipe_separated_splitter.split (included))
										from
											included_rng_files.start
											until
											included_rng_files.after
										loop
											included_rng_file := file_system.new_input_file (included_rng_files.item_for_iteration)
											included_rng_file_length := included_rng_file.count
											included_rng_file.open_read
											included_rng_file.read_string (included_rng_file_length)
											included_rng_file_contents := included_rng_file.last_string
											included := include_list_transformer.transform_string_to_string (included_rng_file_contents)
											if included /= Void and not included.is_empty then
												local_included_rng_files := pipe_separated_splitter.split (included)
												from
													local_included_rng_files.start
												until
													local_included_rng_files.after
												loop
													if not included_rng_files.has (local_included_rng_files.item_for_iteration)	then
														included_rng_files.force_last (local_included_rng_files.item_for_iteration)
													end
													local_included_rng_files.forth
												end
											end
											included_rng_files.forth
										end
										write_included_class_values (included_rng_files)
									end

									-- XSLT transformations
									write_included_class_values (included_rng_files)
									deferred_xml_writer_transformer.set_string_parameter (namespace_prefix, "prefix")
									attribute_values_transformer.set_string_parameter (namespace_prefix, "prefix")
									xml_document_file_name := namespace_prefix + "_xml_document.e"
									if command_line_includes_verbose_switch then
										io.put_string ("  Creating " + xml_document_file_name + "%N")
									end
									xml_document_contents := deferred_xml_writer_transformer.transform_string_to_string (rng_file_contents)
									error_message := "Unable to write " + xml_document_file_name
									put_string_to_eiffel_directory (xml_document_file_name, xml_document_contents)
									error_message := Void
									attribute_values_file_name := namespace_prefix + "_attribute_values.e"
									if command_line_includes_verbose_switch then
										io.put_string ("  Creating " + attribute_values_file_name + "%N")
									end
									attribute_values_contents := attribute_values_transformer.transform_string_to_string (rng_file_contents)
									error_message := "Unable to write " + attribute_values_file_name
									put_string_to_eiffel_directory (attribute_values_file_name, attribute_values_contents)
									error_message := Void
								end
								if not command_line_includes_trash_switch then
									if file_system.file_exists ("temp.rng") then
										file_system.delete_file ("temp.rng")
									end
									if file_system.file_exists (imported_class_values_file_name) then
										file_system.delete_file (imported_class_values_file_name)
									end
								end
							end
							all_included_rng_files.forth
						end
						if command_line_includes_datadirectory_switch then
							-- Recrusively examine XSLT files to find all included transforms
							if command_line_includes_verbose_switch then
								io.put_string ("Recursively examining XSLT transformations for included transforms%N")
							end
							from
								xsl_files.start
							until
								xsl_files.after
							loop
								xsl_file_name := xsl_files.item_for_iteration
								if command_line_includes_verbose_switch then
									io.put_string ("  " + xsl_file_name + "%N")
								end
								error_message := "Unable to open file " + xsl_file_name + " for reading."
								xsl_input_file := file_system.new_input_file (xsl_file_name)
								xsl_file_length := xsl_input_file.count
								xsl_input_file.open_read
								xsl_input_file.read_string (xsl_file_length)
								xsl_file_contents := xsl_input_file.last_string
								error_message := Void
								included_xsl_files_string := xsl_included_files_transformer.transform_string_to_string (xsl_file_contents)
								included_xsl_files := pipe_separated_splitter.split (included_xsl_files_string)
								from
									included_xsl_files.start
								until
									included_xsl_files.after
								loop
									if not xsl_files.has (included_xsl_files.item_for_iteration) then
										xsl_files.force_last (included_xsl_files.item_for_iteration)
									end
									included_xsl_files.forth
								end
								xsl_files.forth
							end
							-- Copy all xsl files to the data directory
							if command_line_includes_verbose_switch then
								io.put_string ("Copying XSLT transformation files to data directory%N")
							end
							data_directory := datadirectory_argument
							from
								xsl_files.start
							until
								xsl_files.after
							loop
								xsl_file_name := xsl_files.item_for_iteration
								if command_line_includes_verbose_switch then
									io.put_string ("  " + xsl_file_name + "%N")
								end
								error_message := "Unable to copy " + xsl_file_name + " to data directory"
								file_system.copy_file (xsl_file_name, file_system.pathname (data_directory, xsl_file_name))
								error_message := Void
								xsl_files.forth
							end
						end
						-- Delete all temporary files we just created
						if not command_line_includes_trash_switch then
							if command_line_includes_verbose_switch then
								io.put_string ("Cleaning Up%N")
							end
							from
								prefixes.start
							until
								prefixes.after
							loop
								file_name := prefixes.item_for_iteration + ".rng"
								if file_system.file_exists (file_name) then
									file_system.delete_file (file_name)
								end
								prefixes.forth
							end
							if file_system.file_exists ("temp.rnc") then
								file_system.delete_file ("temp.rnc")
							end
							if file_system.file_exists (imported_class_values_file_name) then
								file_system.delete_file (imported_class_values_file_name)
							end
						end
					end
					if not command_line_includes_trash_switch and (command_line_includes_parameters or command_line_includes_goa_switch) then
						file_system.delete_file ("common.xsl")
						file_system.delete_file ("attribute_values.xsl")
						file_system.delete_file ("schema_codes.xsl")
						file_system.delete_file ("validating_xml_writer.xsl")
						file_system.delete_file ("deferred_xml_writer.xsl")
						file_system.delete_file ("flatten_1.xsl")
						file_system.delete_file ("flatten_2.xsl")
						file_system.delete_file ("flatten_3.xsl")
						file_system.delete_file ("include_list.xsl")
						file_system.delete_file ("xsl_include_list.xsl")
						file_system.delete_file ("imported.xsl")
						if not command_line_includes_goa_switch then
							file_system.delete_file ("goa_common.rnc")
						end
						if not (xsl_files.has ("goa_common.xsl") or command_line_includes_goa_switch) then
							file_system.delete_file ("goa_common.css")
							file_system.delete_file ("goa_common.xsl")
						end
					end
					if command_line_includes_verbose_switch then
						io.put_string ("Finished.%N")
					end
				end
			end
		rescue
			if error_message /= Void and not exception_occurred then
				exception_occurred := True
				io.put_string (error_message + "%N" + help_usage)
				retry
			end
		end

feature {NONE} -- Implementation

	write_included_class_values (included_file_names: DS_LIST [STRING]) is
			-- Examine all included_file_names for stylesheet declarations
			-- When found, write the imported value declarations for the
			-- "class" attribute to the file imported_class_values.xml
		local
			writer: EPX_XML_WRITER
			included_file: KI_TEXT_INPUT_FILE
			file_length: INTEGER
			file_contents, values: STRING
			values_list: DS_LIST [STRING]
			rnc_file_name, the_stylesheet_file_name: STRING
			base_name_length: INTEGER
		do
			create writer.make
			writer.add_header_iso_8859_1_encoding
			writer.start_ns_tag ("", "grammar")
			writer.set_a_name_space ("rng", "http://relaxng.org/ns/structure/1.0")
			writer.start_ns_tag ("", "define")
			writer.set_attribute ("name", "class")
			writer.start_ns_tag ("", "choice")
			if included_file_names /= Void then
				from
					included_file_names.start
				until
					included_file_names.after
				loop
					rnc_file_name := STRING_.cloned_string (included_file_names.item_for_iteration)
					base_name_length := rnc_file_name.index_of ('.', 1) - 1
					rnc_file_name.keep_head (base_name_length)
					rnc_file_name.append (".rnc")
					included_file := file_system.new_input_file (rnc_file_name)
					file_length := included_file.count
					included_file.open_read
					included_file.read_string (file_length)
					file_contents := included_file.last_string
					the_stylesheet_file_name := stylesheet_file_name (file_contents)
					if the_stylesheet_file_name /= Void then
						values_list := stylesheet_class_names (the_stylesheet_file_name)
						from
							values_list.start
						until
							values_list.after
						loop
							writer.add_ns_tag ("", "value", values_list.item_for_iteration)
							values_list.forth
						end
					end
					included_file_names.forth
				end

			end
			writer.stop_tag
			writer.stop_tag
			writer.stop_tag
			put_string_to_current_directory (imported_class_values_file_name, writer.as_string)
		end

	imported_class_values_file_name: STRING is "imported_class_values.xml"
			-- File name to which imported class values are written			

	pipe_separated_splitter: ST_SPLITTER is
			-- Used to Separate strings separated by pipe character
		once
			create Result.make
			Result.set_separators ("|")
		end

	stylesheet_class_names (the_stylesheet_file_name: STRING): DS_LINKED_LIST [STRING] is
			-- CSS Class names in file given by the_stylesheet_file_name
		require
			valid_the_stylesheet_file_name: the_stylesheet_file_name /= Void
			stylesheet_file_is_readable: file_system.file_exists (the_stylesheet_file_name) and then file_system.is_file_readable (the_stylesheet_file_name)
		local
			stylesheet_input_file: KI_TEXT_INPUT_FILE
			class_name, class_name_upper: STRING
			class_names_upper: DS_LINKED_LIST [STRING]
		do
			create Result.make_equal
			stylesheet_input_file := file_system.new_input_file (the_stylesheet_file_name)
			create class_names_upper.make_equal
			from
				stylesheet_input_file.open_read
			until
				stylesheet_input_file.end_of_file
			loop
				stylesheet_input_file.read_line
				class_name_matcher.match (stylesheet_input_file.last_string)
				if class_name_matcher.has_matched then
					class_name := STRING_.cloned_string( (class_name_matcher.captured_substring (0)))
					class_name.keep_tail (class_name.count -1)
					class_name_upper := class_name.as_upper
					if not class_names_upper.has ( class_name_upper) then
						Result.force_last (class_name)
						class_names_upper.force_last (class_name_upper)
					end
				end
			end
		ensure
			valid_result: Result /= Void
		end

	stylesheet_file_name (rnc_file_contents: STRING): STRING is
			-- Name of stylesheet declared in rnc_file_contents
			-- Void if none
		require
			valid_rnc_file_contents: rnc_file_contents /= Void
		do
			stylesheet_declaration_matcher.match (rnc_file_contents)
			if stylesheet_declaration_matcher.has_matched then
				Result := STRING_.cloned_string(stylesheet_declaration_matcher.captured_substring (0))
				Result.keep_tail (Result.count - Result.index_of ('%"', 1))
				Result.keep_head (Result.count - 1)
				Result := execution_environment.interpreted_string (Result)
			end
		end

	stylesheet_declaration_matcher: RX_PCRE_MATCHER is
			-- Pattern matcher used to find stylesheet declarations in rnc files
		once
			create Result.make
			Result.compile ("#\s*stylesheet\s*=\s*%"[a-zA-Z0-9./\_-]+%"")
		end

	class_name_matcher: RX_PCRE_MATCHER is
			-- Pattern matcher used to find class names in a CSS stylesheet
		once
			create Result.make
			Result.compile ("\.[a-zA-Z0-9_-]+")
		end

	unreadable_files (file_names: DS_LIST [STRING]): DS_LINKED_LIST [STRING] is
			-- Which files given by file names are not readable
			-- Will return empty list if all are readable
		require
			valid_file_names: file_names /= Void
		local
			file_name: STRING
		do
			create Result.make
			from
				file_names.start
			until
				file_names.after
			loop
				file_name := file_names.item_for_iteration
				if not file_system.is_file_readable (execution_environment.interpreted_string(file_name)) then
					Result.force_last (file_name)
				end
				file_names.forth
			end
		end

feature {NONE} -- Placeholder

	class_attribute_placeholder: STRING is "CLASS_ATTRIBUTE_PLACEHOLDER"

feature {NONE} -- Command Line Parsing

	command_line_parser: AP_PARSER is
		-- The command line parser
		once
			create Result.make
			Result.set_application_description ("Generate Eiffel classes which write XML conforming to Relax NG Compact Syntax Grammar(s)")
			Result.set_parameters_description ("file1 file2 ... (Name(s) of file(s) containing Relax NG Compact Syntax grammar(s) %
				%used to generate the XML authoring classes. No file names are allowed with the --goa switch.)")
			create verbose_flag.make ('v', "verbose")
			verbose_flag.set_description ("Verbose mode (provides context for certain error messages)")
			Result.options.force_last (verbose_flag)
			create norefresh_flag.make ('n', "norefresh")
			norefresh_flag.set_description ("Do not refresh files from Goanna directories")
			Result.options.force_last (norefresh_flag)
			create goa_flag.make ('g', "goa")
			goa_flag.set_description
				("Rebuild goa_common and other supplied files. %
				%Prebuilt versions are mounted automatically. %
				%Do not include file names when using this option.")
			Result.options.force_last (goa_flag)
			create trash_flag.make ('t', "trash")
			trash_flag.set_description ("Leave trash files in directory (for debugging goa_build)")
			Result.options.force_last (trash_flag)
			create eiffeldirectory_option.make ('e', "eiffeldirectory")
			eiffeldirectory_option.set_description ("Directory in which to place generated eiffel classes")
			Result.options.force_last (eiffeldirectory_option)
			create datadirectory_option.make ('d', "datadirectory")
			datadirectory_option.set_description ("The location of the web applications configuration.data_directory.")
			Result.options.force_last (datadirectory_option)
			create author_option.make ('a', "author")
			author_option.set_description ("Name of the application's author (for indexing clauses)")
			Result.options.force_last (author_option)
			create copyright_option.make ('c', "copyright")
			copyright_option.set_description ("Copyright declaration (for indexing clauses)")
			Result.options.force_last (copyright_option)
			create license_option.make ('l', "license")
			license_option.set_description ("License declaration (for indexing clauses)")
			Result.options.force_last (license_option)
		end

-- Flags and options for the command_line_parser

	verbose_flag: AP_FLAG
	norefresh_flag: AP_FLAG
	goa_flag: AP_FLAG
	trash_flag: AP_FLAG
--	file_option: AP_STRING_OPTION
	eiffeldirectory_option: AP_STRING_OPTION
	datadirectory_option: AP_STRING_OPTION
	author_option: AP_STRING_OPTION
	copyright_option: AP_STRING_OPTION
	license_option: AP_STRING_OPTION

	help_usage: STRING is "Use goa_build -h for help%N"

feature {NONE} -- Command Line Arguments

	command_line_includes_parameters: BOOLEAN is
			-- Did user include the file_switch on the command line?
		require
--			valid_command_line_valid_options: command_line_parser /= Void and then command_line_parser.valid_options /= Void
		once
			Result := not command_line_parser.parameters.is_empty
		end


	command_line_includes_help_switch: BOOLEAN is
			-- Did user include the help_switch on the command line?
		require
--			valid_command_line_valid_options: command_line_parser /= Void and then command_line_parser.valid_options /= Void
		once
			Result := command_line_parser.help_option.was_found
		end

	command_line_includes_eiffeldirectory_switch: BOOLEAN is
			-- Did user include --eiffeldirectory argument on the command line?
		require
--			valid_command_line_valid_options: command_line_parser /= Void and then command_line_parser.valid_options /= Void
		once
			Result := eiffeldirectory_option.was_found
		end

	exactly_one_eiffeldirectory_argument: BOOLEAN is
			-- Does the list of arguments given by user for the -e argument contain exactly one item?
		require
--			valid_command_line_valid_options: command_line_parser /= Void and then command_line_parser.valid_options /= Void
			command_line_includes_database_argument: command_line_includes_eiffeldirectory_switch
		once
			Result := eiffeldirectory_option.parameters.count = 1
		end

	eiffeldirectory_argument: STRING is
			-- The --eiffeldirectory argument given by the user
		require
			valid_command_line_valid_options: command_line_parser /= Void and then command_line_parser.valid_options /= Void
			command_line_includes_database_argument: command_line_includes_eiffeldirectory_switch
			exactly_one_eiffeldirectory_argument: exactly_one_eiffeldirectory_argument
		once
			Result := eiffeldirectory_option.parameters.item (1)
		end

	command_line_includes_datadirectory_switch: BOOLEAN is
			-- Did user include --eiffeldirectory argument on the command line?
		require
--			valid_command_line_valid_options: command_line_parser /= Void and then command_line_parser.valid_options /= Void
		once
			Result := datadirectory_option.was_found
		end

	exactly_one_datadirectory_argument: BOOLEAN is
			-- Does the list of arguments given by user for the --eiffeldirectory argument contain exactly one item?
		require
			valid_command_line_valid_options: command_line_parser /= Void and then command_line_parser.valid_options /= Void
			command_line_includes_database_argument: command_line_includes_datadirectory_switch
		once
			Result := datadirectory_option.parameters.count = 1
		end

	datadirectory_argument: STRING is
			-- The -e argument given by the user
		require
--			valid_command_line_valid_options: command_line_parser /= Void and then command_line_parser.valid_options /= Void
			command_line_includes_database_argument: command_line_includes_datadirectory_switch
			exactly_one_datadirectory_argument: exactly_one_datadirectory_argument
		once
			Result := execution_environment.interpreted_string (datadirectory_option.parameters.item (1))
		end

	command_line_includes_goa_switch: BOOLEAN is
			-- Did user include --goa argument on the command line?
		require
--			valid_command_line_valid_options: command_line_parser /= Void and then command_line_parser.valid_options /= Void
		once
			Result := goa_flag.was_found
		end

	command_line_includes_trash_switch: BOOLEAN is
			-- Did user include --trash argument on the command line?
			-- You can then run gexslt (or another transformer) from the command line
			-- Using gexslt --param=prefix=NAMESPACE --file=validating_xml_writer.xsl --file=NAMESPACE.fl2
		require
--			valid_command_line_valid_options: command_line_parser /= Void and then command_line_parser.valid_options /= Void
		once
			Result := trash_flag.was_found
		end

	command_line_includes_author_switch: BOOLEAN is
			-- Did user include --author argument on the command line?
		require
--			valid_command_line_valid_options: command_line_parser /= Void and then command_line_parser.valid_options /= Void
		once
			Result := author_option.was_found
		end

	exactly_one_author_argument: BOOLEAN is
			-- Does the list of arguments given by user for the -e argument contain exactly one item?
		require
--			valid_command_line_valid_options: command_line_parser /= Void and then command_line_parser.valid_options /= Void
			command_line_includes_database_argument: command_line_includes_author_switch
		once
			Result := author_option.parameters.count = 1
		end

	author_argument: STRING is
			-- The --author argument given by the user
		require
--			valid_command_line_valid_options: command_line_parser /= Void and then command_line_parser.valid_options /= Void
			command_line_includes_database_argument: command_line_includes_author_switch
			exactly_one_author_argument: exactly_one_author_argument
		once
			Result := author_option.parameters.item (1)
		end

	command_line_includes_copyright_switch: BOOLEAN is
			-- Did user include --copyright argument on the command line?
		require
--			valid_command_line_valid_options: command_line_parser /= Void and then command_line_parser.valid_options /= Void
		once
			Result := copyright_option.was_found
		end

	exactly_one_copyright_argument: BOOLEAN is
			-- Does the list of arguments given by user for the -e argument contain exactly one item?
		require
--			valid_command_line_valid_options: command_line_parser /= Void and then command_line_parser.valid_options /= Void
			command_line_includes_database_argument: command_line_includes_copyright_switch
		once
			Result := copyright_option.parameters.count = 1
		end

	copyright_argument: STRING is
			-- The --copyright argument given by the user
		require
--			valid_command_line_valid_options: command_line_parser /= Void and then command_line_parser.valid_options /= Void
			command_line_includes_database_argument: command_line_includes_copyright_switch
			exactly_one_copyright_argument: exactly_one_copyright_argument
		once
			Result := copyright_option.parameters.item (1)
		end

	command_line_includes_license_switch: BOOLEAN is
			-- Did user include --license argument on the command line?
		require
--			valid_command_line_valid_options: command_line_parser /= Void and then command_line_parser.valid_options /= Void
		once
			Result := license_option.was_found
		end

	exactly_one_license_argument: BOOLEAN is
			-- Does the list of arguments given by user for the -e argument contain exactly one item?
		require
--			valid_command_line_valid_options: command_line_parser /= Void and then command_line_parser.valid_options /= Void
			command_line_includes_database_argument: command_line_includes_license_switch
		once
			Result := license_option.parameters.count = 1
		end

	license_argument: STRING is
			-- The --license argument given by the user
		require
--			valid_command_line_valid_options: command_line_parser /= Void and then command_line_parser.valid_options /= Void
			command_line_includes_database_argument: command_line_includes_license_switch
			exactly_one_license_argument: exactly_one_license_argument
		once
			Result :=  license_option.parameters.item (1)
		end

	command_line_includes_verbose_switch: BOOLEAN is
			-- Did user include the verbose_switch on the command line?
		require
--			valid_command_line_valid_options: command_line_parser /= Void and then command_line_parser.valid_options /= Void
		once
			Result := verbose_flag.was_found
		end

	command_line_includes_norefresh_switch: BOOLEAN is
			-- Did user include the norefresh_switch on the command line?
		require
--			valid_command_line_valid_options: command_line_parser /= Void and then command_line_parser.valid_options /= Void
		once
			Result := norefresh_flag.was_found
		end

feature {NONE} -- XSLT Transformations

	transformer_factory: GOA_XSLT_TRANSFORMER_FACTORY is
			-- Where XSLT Transformers come from
		once
			create Result.make_without_configuration
		end

	flatten_stage_1_transformer: GOA_XSLT_STRING_TRANSFORMER is
			-- XSLT Transformer used to perform stage 1 of combining included schemas into a single file
		once
			Result := transformer_factory.new_string_transformer_from_file_name ("flatten_1.xsl")
		end

	flatten_stage_2_transformer: GOA_XSLT_STRING_TRANSFORMER is
			-- XSLT Transformer used to perform stage 2 of combining included schemas into a single file
		once
			Result := transformer_factory.new_string_transformer_from_file_name ("flatten_2.xsl")
		end

	flatten_stage_3_transformer: GOA_XSLT_STRING_TRANSFORMER is
			-- XSLT Transformer used to perform stage 3 of combining included schemas into a single file
		once
			Result := transformer_factory.new_string_transformer_from_file_name ("flatten_3.xsl")
		end

	imported_transformer: GOA_XSLT_STRING_TRANSFORMER is
			-- XSLT Transformer used to generate the import schema file
		once
			Result := transformer_factory.new_string_transformer_from_file_name ("imported.xsl")
		end

	include_list_transformer: GOA_XSLT_STRING_TRANSFORMER is
			-- XSLT Transformer used to generate the list of included files specified in a grammar
		once
			Result := transformer_factory.new_string_transformer_from_file_name ("include_list.xsl")
		end

	xsl_included_files_transformer: GOA_XSLT_STRING_TRANSFORMER is
			-- XSLT Transformer used to generate the list of included files specified in a grammar
		once
			Result := transformer_factory.new_string_transformer_from_file_name ("xsl_include_list.xsl")
		end

	validating_xml_writer_transformer: GOA_XSLT_STRING_TRANSFORMER is
			-- XSLT Transformer used to generate eiffel fully effective class {FILE_NAME}_XML_DOCUMENT
		once
			Result := transformer_factory.new_string_transformer_from_file_name ("validating_xml_writer.xsl")
		end

	deferred_xml_writer_transformer: GOA_XSLT_STRING_TRANSFORMER is
			-- XSLT Transformer used to generate deferred eiffel class {FILE_NAME}_XML_DOCUMENT
		once
			Result := transformer_factory.new_string_transformer_from_file_name ("deferred_xml_writer.xsl")
		end

	schema_codes_transformer: GOA_XSLT_STRING_TRANSFORMER is
			-- XSLT Transformer used to generate eiffel class {FILE_NAME}_SCHEMA_CODES
		once
			Result := transformer_factory.new_string_transformer_from_file_name ("schema_codes.xsl")
		end

	attribute_values_transformer: GOA_XSLT_STRING_TRANSFORMER is
			-- XSLT Transformer used to generate eiffel class {FILE_NAME}_ATTRIBUTE_VALUES
		once
			Result := transformer_factory.new_string_transformer_from_file_name ("attribute_values.xsl")
		end

feature {NONE} -- Output Facilities

	put_string_to_current_directory (file_name, content: STRING) is
			-- Write content to a file named file_name in the current working directory
		require
			valid_file_name: file_name /= Void and then not file_name.is_empty
			valid_content: content /= Void
			-- Current Directory is writable
		do
			put_string_to_file ("", file_name, content)
		end

	put_string_to_data_directory (file_name, content: STRING) is
			-- Write content to a file named file_name in the data_directory
		require
			valid_file_name: file_name /= Void and then not file_name.is_empty
			valid_content: content /= Void
			valid_data_directory: command_line_includes_datadirectory_switch implies file_system.directory_exists (datadirectory_argument)
			-- Data Directory is writable
		do
			if command_line_includes_datadirectory_switch then
				put_string_to_file (datadirectory_argument, file_name, content)
			else
				put_string_to_file ("", file_name, content)
			end

		end

	put_string_to_eiffel_directory (file_name, content: STRING) is
			-- Write content to a file named file_name in the eiffel_directory
		require
			valid_file_name: file_name /= Void and then not file_name.is_empty
			valid_content: content /= Void
			valid_data_directory: command_line_includes_eiffeldirectory_switch implies file_system.directory_exists (eiffeldirectory_argument)
			-- Data Directory is writable
		do
			if command_line_includes_eiffeldirectory_switch then
				put_string_to_file (eiffeldirectory_argument, file_name, content)
			else
				put_string_to_file ("", file_name, content)
			end
		end

	put_string_to_file (directory, file_name, content: STRING) is
			-- Write file containing content in directory
		require
			valid_file_name: file_name /= Void and then not file_name.is_empty
			valid_content: content /= Void
			valid_directory: directory /= Void and then not directory.is_empty implies file_system.directory_exists (directory)
			-- Directory is writable
		local
			local_directory, local_file_name: STRING
			the_file: KI_TEXT_OUTPUT_FILE
		do
			if not directory.is_empty then
				local_file_name := file_system.pathname (directory, file_name)
			else
				local_file_name := file_name
			end
			the_file := file_system.new_output_file (local_file_name)
			the_file.open_write
			the_file.put_string (content)
			the_file.close
		end

end -- class GOA_BUILD
