indexing
	description: "Global definitions for FCGI protocol"
	project: "Project Goanna <http://sourceforge.net/projects/goanna>"
	library: "FastCGI protocol"
	date: "$Date: 2006-04-16 23:42:40 -0700 (Sun, 16 Apr 2006) $"
	revision: "$Revision: 491 $"
	author: "Glenn Maughan <glennmaughan@users.sourceforge.net>"
	copyright: "Copyright (c) 2001 Glenn Maughan and others"
	license: "Eiffel Forum License v2 (see forum.txt)."

class GOA_FAST_CGI_DEFS

feature -- Access

	Fcgi_max_len: INTEGER is 65535
	
	Fcgi_header_len: INTEGER is 8
	Fcgi_end_req_body_len: INTEGER is 8
	Fcgi_begin_req_body_len: INTEGER is 8
	Fcgi_unknown_body_type_body_len: INTEGER is 8
	
	Fcgi_version: INTEGER is 1
	
	Fcgi_begin_request: INTEGER is 1
	Fcgi_abort_request: INTEGER is 2
	Fcgi_end_request: INTEGER is 3
	Fcgi_params: INTEGER is 4
	Fcgi_stdin: INTEGER is 5
	Fcgi_stdout: INTEGER is 6
	Fcgi_stderr: INTEGER is 7
	Fcgi_data: INTEGER is 8
	Fcgi_get_values: INTEGER is 9
	Fcgi_get_values_result: INTEGER is 10
	Fcgi_unknown_type: INTEGER is 11
	Fcgi_max_type: INTEGER is 11
	
	Fcgi_null_request_id: INTEGER is 0
	
	Fcgi_keep_conn:INTEGER is 1
	
	Fcgi_responder: INTEGER is 1
	Fcgi_authorizer: INTEGER is 2
	Fcgi_filter: INTEGER is 3
	
	Fcgi_request_complete: INTEGER is 0
	Fcgi_cant_mpx_conn: INTEGER is 1
	Fcgi_overload: INTEGER is 2
	Fcgi_unknown_role: INTEGER is 3
	
	Fcgi_max_conns: STRING is "FCGI_MAX_CONNS"
	Fcgi_max_reqs: STRING is "FCGI_MAX_REQS"
	Fcgi_mpxs_conns: STRING is "FCGI_MPXS_CONNS"
	
	Fcgi_stream_record: INTEGER is 0
	Fcgi_skip: INTEGER is 1
	Fcgi_begin_record: INTEGER is 2
	Fcgi_mgmt_record: INTEGER is 3
	
	Fcgi_unsupported_version: INTEGER is -2
	Fcgi_protocol_error: INTEGER is -3
	Fcgi_params_error: INTEGER is -4
	Fcgi_call_seq_error: INTEGER is -5
	
end -- class GOA_FAST_CGI_DEFS
