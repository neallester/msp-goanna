indexing
	description: "Objects that represent and can read a FastCGI request"
	project: "Project Goanna <http://sourceforge.net/projects/goanna>"
	library: "FastCGI protocol"
	date: "$Date: 2010-02-26 18:04:12 -0800 (Fri, 26 Feb 2010) $"
	revision: "$Revision: 626 $"
	author: "Glenn Maughan <glennmaughan@users.sourceforge.net>"
	copyright: "Copyright (c) 2001 Glenn Maughan and others"
	license: "Eiffel Forum License v2 (see forum.txt)."

class	GOA_FAST_CGI_REQUEST

inherit

	GOA_FAST_CGI_DEFS
		export
			{NONE} all
		end
	UT_STRING_FORMATTER
		export
			{NONE} all
		end
	KL_IMPORTED_INTEGER_ROUTINES
	POSIX_CONSTANTS
	GOA_STRING_MANIPULATION

creation
	make

feature -- Initialization

	make is
			-- Clear all request fields	
		do
			socket := Void
			read_ok := True
			write_ok := True
			app_status := 0
			num_writers := 0
			failed := False
			create parameters.make_equal (20)
		end

feature -- Access

	failed: BOOLEAN
		-- Did this request fail?

	socket: ABSTRACT_TCP_SOCKET
		-- The socket used to communicate with fastcgi

	read_ok: BOOLEAN
		-- Was the last read operation successful?

	write_ok: BOOLEAN
		-- Was the last write operation successful?

	request_id: INTEGER
		-- Request id. Zero for management request.

	role: INTEGER

	flags: INTEGER

	version: INTEGER

	type: INTEGER

	content_length: INTEGER

	padding_length: INTEGER

	app_status: INTEGER
			-- Application status

	num_writers: INTEGER
			-- Number of writers

	parameters: DS_HASH_TABLE [STRING, STRING]
			-- Table of parameters passed to this request.

	raw_stdin_content: STRING

feature -- Status setting

	set_socket (new_socket: like socket) is
			-- Set the socket for this request.
			-- Can be set to Void to invalidate the request.
		require
			valid_socket: new_socket /= Void implies new_socket.is_open
		do
			socket := new_socket
		end

feature -- Basic operations

	read is
			-- Read a complete request including its begin request, params and stdin records.
			-- Process management records as they are encountered.
			--| Can be called recursively to read parts of a stream.
		local
			record_header: GOA_FAST_CGI_RECORD_HEADER
		do
   			debug ("fcgi_record_output")
				io.put_string (generating_type + "%N")
			end
			debug ("fcgi_protocol")
				print (generator + ".read%R%N")
			end
			from
				stdin_records_done := False
				param_records_done := False
			until
				not read_ok or (stdin_records_done and param_records_done)
			loop
				-- read begin request record. It may be a management record, if so, process it.
				record_header := read_header
				if read_ok then
					read_body (record_header)
				end
			end
			-- extract parameters
			if read_ok then
				process_parameter_raw_data
			end
			debug ("fcgi_protocol")
				print (generator + ".read - finished.%R%N")
			end
   			debug ("fcgi_record_output")
   				io.put_string ("Parameters%N")
				parameters.do_all_with_key (agent print_parameter (?, ?))
			end
		end

	print_parameter (a_value, a_key: STRING) is
		do
			io.put_string ("  " + a_key + " | " + a_value + "%N")
		end


	write_stderr (str: STRING) is
			-- Write 'str' as a stderr record to the socket
		require
			socket_exists: socket /= Void
			valid_socket: socket.is_open
		local
			record_header: GOA_FAST_CGI_RECORD_HEADER
			record_body: GOA_FAST_CGI_RAW_BODY
			offset, bytes_to_send: INTEGER
		do
			debug ("fcgi_protocol")
				print (generator + ".write_stderr%R%N")
			end
			-- split into chunks 65535 bytes or less.
			from
				offset := 1
				write_ok := socket.errno.first_value = 0
			until
				offset > str.count
			loop
				bytes_to_send := (65535).min (str.count - (offset - 1))
				-- create and send stderr stream record
				create record_header.make (version, request_id, Fcgi_stderr, bytes_to_send, 0)
				create record_body.make (str.substring (offset, offset + bytes_to_send - 1), 0)
				record_header.write (socket)
				if write_ok then
					record_body.write (socket)
				end
				offset := offset + 65535
			end
			-- end stderr stream record
			create record_header.make (version, request_id, Fcgi_stderr, 0, 0)
			record_header.write (socket)
			debug ("fcgi_protocol")
				print (generator + ".write_stderr - finished%R%N")
			end
		end

	write_stdout (str: STRING) is
			-- Write 'str' as a stdout record to the socket
		require
			socket_exists: socket /= Void
			valid_socket: socket.is_open
			write_ok: write_ok
		local
			record_header: GOA_FAST_CGI_RECORD_HEADER
			record_body: GOA_FAST_CGI_RAW_BODY
			offset, bytes_to_send: INTEGER
			body_string: STRING
		do
			debug ("fcgi_protocol")
				print (generator + ".write_stdout%R%N")
				print ("Data Length: " + str.count.out + "%N")
			end
			-- split into chunks 65535 bytes or less.
			from
				offset := 1
			until
				offset > str.count or not write_ok
			loop
				bytes_to_send := (65535).min (str.count - (offset - 1))
				-- create and send stdout stream record
				create record_header.make (version, request_id, Fcgi_stdout, bytes_to_send, 0)
				debug ("fcgi_protocol")
					body_string := str.substring (offset, offset + bytes_to_send - 1)
					print ("Bytes_to_send: " + bytes_to_send.out + "; body_string_length: " + body_string.count.out + "%R%N")
					print ("body_string: " + body_string + "%R%N")
				end
				create record_body.make (str.substring (offset, offset + bytes_to_send - 1), 0)
				record_header.write (socket)
				write_ok := record_header.write_ok
				if write_ok then
					record_body.write (socket)
					write_ok := record_body.write_ok
				end

				offset := offset + 65535
			end
			-- end stdout stream record
			create record_header.make (version, request_id, Fcgi_stdout, 0, 0)
			if write_ok then
				record_header.write (socket)
			end
			write_ok := record_header.write_ok
			debug ("fcgi_protocol")
				print (generator + ".write_stdout - finished%R%N")
			end
		end

	end_request is
			-- Notify the web server that this request has completed.
		require
			socket_exists: socket /= Void
		local
			record_header: GOA_FAST_CGI_RECORD_HEADER
			record_body: GOA_FAST_CGI_END_REQUEST_BODY
		do
			debug ("fcgi_protocol")
				print (generator + ".end_request%R%N")
			end
			-- send end request record
			if write_ok then
				create record_header.make (version, request_id, Fcgi_end_request,
					Fcgi_end_req_body_len, 0)
				create record_body.make (Fcgi_request_complete, 0)
				record_header.write (socket)
				if record_header.write_ok then
					record_body.write (socket)
				end
			end
			socket.close
			debug ("fcgi_protocol")
				print (generator + ".end_request - finished%R%N")
			end
		end

	as_fast_cgi_string (new_request_id: INTEGER): STRING is
		local
			begin_record: GOA_FAST_CGI_BEGIN_REQUEST_BODY
			raw_record: GOA_FAST_CGI_RAW_BODY
			end_record: GOA_FAST_CGI_END_REQUEST_BODY
		do
			create begin_record
			Result := begin_record.record_header (new_request_id).as_fast_cgi_string
			Result.append (begin_record.as_fast_cgi_string)
			if parameter_records = Void then
				create parameter_records.make
			end
			create raw_record.make ("", 0)
			parameter_records.force_last (raw_record)
			parameter_records.do_all (agent append_to_fast_cgi_string (?, new_request_id, Result))
			create end_record.make (app_status, 0)
			Result.append (end_record.record_header (new_request_id).as_fast_cgi_string)
			Result.append (end_record.as_fast_cgi_string)
		end

feature {NONE} -- Implementation

	append_to_fast_cgi_string (raw_record: GOA_FAST_CGI_RAW_BODY; new_request_id: INTEGER; fast_cgi_string: STRING) is
			-- Append representation of raw_record to fast_cgi_string
		require
			valid_raw_record: raw_record /= Void
			valid_fast_cgi_string: fast_cgi_string /= Void
		do
			fast_cgi_string.append (raw_record.record_header (new_request_id).as_fast_cgi_string)
			fast_cgi_string.append (raw_record.as_fast_cgi_string)
		end


	stdin_records_done, param_records_done: BOOLEAN
			-- Have all stdin and param records been read?

	raw_param_content: STRING
			-- Buffers to hold raw data collected from stream records.

	read_header: GOA_FAST_CGI_RECORD_HEADER is
			-- Read record header from the socket.
		do
			debug ("fcgi_protocol")
				print (generator + ".read_header%R%N")
			end
			create Result.read (socket)
			read_ok := Result.read_ok
			debug ("fcgi_protocol")
				print (generator + ".read_header - finished%R%N")
			end
		end

	read_body (record_header: GOA_FAST_CGI_RECORD_HEADER) is
			-- Read the body of the record depending on the type of the
			-- record
		require
			record_header_exists: record_header /= Void
		do
			debug ("fcgi_protocol")
				print (generator + ".read_body%R%N")
			end
			inspect
				record_header.type
			when Fcgi_begin_request then
				read_begin_request_body (record_header)
			when Fcgi_params then
				read_param_request_body (record_header)
			when Fcgi_stdin then
				read_stdin_request_body (record_header)
--			when Fcgi_abort_request then
--				create {FAST_CGI_ABORT_REQUEST_BODY} record_body
			else
				-- TODO: handle unknown record type
				debug ("fcgi_protocol")
					print (generator + ".read_body - unknown record type%R%N")
				end
			end
			debug ("fcgi_protocol")
				print (generator + ".read_body - finished%R%N")
			end
		end

	read_begin_request_body (record_header: GOA_FAST_CGI_RECORD_HEADER) is
			-- Read body of begin request record and process data.
		local
			record_body: GOA_FAST_CGI_BEGIN_REQUEST_BODY
		do
			debug ("fcgi_protocol")
				print (generator + ".read_begin_request_body%R%N")
			end
			-- read body
			create record_body
			record_body.read (record_header, socket)
			read_ok := record_body.read_ok
			if read_ok then
				-- store header elements
				request_id := record_header.request_id
				version := record_header.version
				type := record_header.type
				content_length := record_header.content_length
				padding_length := record_header.padding_length
				-- store body elements
				role := record_body.role
				flags := record_body.flags
				debug ("fcgi_record_output")
					io.put_string ("  Role: " + role.out + "%N")
					io.put_string ("  Flags: " + flags.out + "%N")
				end

			end
			debug ("fcgi_protocol")
				print (generator + ".read_begin_request_body - finished%R%N")
			end
		end

	read_param_request_body (record_header: GOA_FAST_CGI_RECORD_HEADER) is
			-- Read body of param request record and process data.
		local
			record_body: GOA_FAST_CGI_RAW_BODY
		do
			debug ("fcgi_protocol")
				print (generator + ".read_param_request_body%R%N")
			end
			-- check if this is an empty param record. If so, flag end of params
			if record_header.content_length = 0 then
				param_records_done := True
			else
				-- read body
				create record_body.read (record_header, socket)
				read_ok := record_body.read_ok
				if read_ok then
					-- store body elements
					if raw_param_content = Void then
						create raw_param_content.make (record_header.content_length)
					end
					raw_param_content.append_string (record_body.raw_content_data)
					debug ("fcgi_protocol")
						print (generator + ".read_param_request_body = ")
						print (quoted_eiffel_string_out (record_body.raw_content_data) + "%R%N")
					end
				end
			end
			debug ("fcgi_protocol")
				print (generator + ".read_param_request_body - finished%R%N")
			end
		end

	read_stdin_request_body (record_header: GOA_FAST_CGI_RECORD_HEADER) is
			-- Read body of stdin request record and process data.
		local
			record_body: GOA_FAST_CGI_RAW_BODY
		do
			debug ("fcgi_protocol")
				print (generator + ".read_stdin_request_body%R%N")
			end
			-- check if this is an empty stdin record. If so, flag end of stdin
			if record_header.content_length = 0 then
				stdin_records_done := True
			else
				-- read body
				create record_body.read (record_header, socket)
				read_ok := record_body.read_ok
				if read_ok then
					if raw_stdin_content = Void then
						create raw_stdin_content.make (record_header.content_length)
					end
					-- store body elements
					raw_stdin_content.append_string (record_body.raw_content_data)
					debug ("fcgi_protocol")
						print (generator + ".read_stdin_request_body = ")
						print (quoted_eiffel_string_out (record_body.raw_content_data) + "%R%N")
					end
				end
			end
			debug ("fcgi_protocol")
				print (generator + ".read_stdin_request_body - finished%R%N")
			end
		end

	parameter_records: DS_LINKED_LIST [GOA_FAST_CGI_RAW_BODY]
		-- Parameter records add via add_parameter_record

feature {TS_TEST_CASE} -- Process Raw Parameter Data

	process_parameter_raw_data is
			-- Extract parameters from 'raw_param_content'
		local
			short_name, short_value: BOOLEAN
			offset: INTEGER
			name_length, value_length: INTEGER
			name, value: STRING
		do
			from
				parameters.wipe_out
				offset := 1
			until
				offset >= raw_param_content.count
			loop
				-- determine number of bytes in name length, 1 or 4
				short_name := INTEGER_.bit_shift_right (raw_param_content.item (offset).code, 7) = 0
				-- build name length
				if short_name then
					name_length := INTEGER_.bit_and (raw_param_content.item (offset).code, 127)
					offset := offset + 1
				else
					name_length := INTEGER_.bit_shift_left (INTEGER_.bit_and (raw_param_content.item (offset).code, 127), 24)
						+ INTEGER_.bit_shift_left (raw_param_content.item (offset + 1).code, 16)
						+ INTEGER_.bit_shift_left (raw_param_content.item (offset + 2).code, 8)
						+ raw_param_content.item (offset + 3).code
					offset := offset + 4
				end
				-- determine number of bytes in value length, 1 or 4
				short_value := INTEGER_.bit_shift_right (raw_param_content.item (offset).code, 7) = 0
				-- build value length
				if short_value then
					value_length := INTEGER_.bit_and (raw_param_content.item (offset).code, 127)
					offset := offset + 1
				else
					value_length := INTEGER_.bit_shift_left (INTEGER_.bit_and (raw_param_content.item (offset).code, 127), 24)
						+ INTEGER_.bit_shift_left (raw_param_content.item (offset + 1).code, 16)
						+ INTEGER_.bit_shift_left (raw_param_content.item (offset + 2).code, 8)
						+ raw_param_content.item (offset + 3).code
					offset := offset + 4
				end
				-- build name
				name := raw_param_content.substring (offset, offset + name_length - 1)
				offset := offset + name_length
				-- build value
				value := raw_param_content.substring (offset, offset + value_length - 1)
				offset := offset + value_length
				-- store parameter
				parameters.force (value, name)
				debug ("fcgi_protocol")
					print (generator + ".process_parameter_raw_data: name = "
						+ quoted_eiffel_string_out (name))
					print (" value = " + quoted_eiffel_string_out (value) + "%R%N")
				end
			end
			debug ("fcgi_protocol")
				print (generator + ".process_parameter_raw_data: Finished")
			end
		end

feature

	add_parameter_record (a_name, a_value: STRING) is
		require
			valid_a_name: a_name /= Void
			valid_a_value: a_value /= Void
		local
			new_record: GOA_FAST_CGI_RAW_BODY
		do
			if parameter_records = Void then
				create parameter_records.make
			end
			create new_record.make (parameter_as_raw_content (a_name, a_value), 0)
			parameter_records.force_last (new_record)
		end

	add_parameter_to_raw_content (a_name, a_value: STRING) is
		require
			valid_a_name: a_name /= Void
			valid_a_value: a_value /= Void
		do
			if raw_param_content = Void then
				raw_param_content := ""
			end
			raw_param_content.append (parameter_as_raw_content (a_name, a_value))
		end

	parameter_as_raw_content (a_name, a_value: STRING): STRING is
		require
			valid_a_name: a_name /= Void
			valid_a_value: a_value /= Void
		do
			Result := ""
			Result.append (encode_length (a_name.count))
			Result.append (encode_length (a_value.count))
			Result.append (a_name)
			Result.append (a_value)
		end

	encode_length (a_length: INTEGER): STRING is
		require
			non_negative_a_length: a_length >= 0
		do
			-- See http://www.fastcgi.com/devkit/doc/fcgi-spec.html
			-- If length fits into 7 bits: use a single byte
			-- Else: use 4 bytes (1st bit is the flag indicating 4 byte length)
			if a_length < 128 then
				Result := ""
				Result.extend (a_length.to_character_8)
			else
				Result := as_32_bit_string (a_length + a_length.min_value)
				-- This forces the flag bit to be 1; leaving all the other bits the same
			end
		end

end -- class GOA_FAST_CGI_REQUEST
