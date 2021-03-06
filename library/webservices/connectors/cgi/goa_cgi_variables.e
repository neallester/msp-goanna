note
	description: "Objects that represent a CGI servlet application"
	project: "Project Goanna <http://sourceforge.net/projects/goanna>"
	library: "CGI servlets"
	date: "$Date: 2006-04-16 23:42:40 -0700 (Sun, 16 Apr 2006) $"
	revision: "$Revision: 491 $"
	author: "Glenn Maughan <glennmaughan@users.sourceforge.net>"
	copyright: "Copyright (c) 2001 Glenn Maughan and others"
	license: "Eiffel Forum License v2 (see forum.txt)."

class GOA_CGI_VARIABLES
	
feature -- Access

	Gateway_interface_var: STRING = "GATEWAY_INTERFACE"
	Server_name_var: STRING = "SERVER_NAME"
	Server_software_var: STRING = "SERVER_SOFTWARE"
	Server_protocol_var: STRING = "SERVER_PROTOCOL"
	Server_port_var: STRING = "SERVER_PORT"
	Request_method_var: STRING = "REQUEST_METHOD"
	Path_info_var: STRING = "PATH_INFO"
	Path_translated_var: STRING = "PATH_TRANSLATED"
	Script_name_var: STRING = "SCRIPT_NAME"
	Document_root_var: STRING = "DOCUMENT_ROOT"
	Query_string_var: STRING = "QUERY_STRING"
	Remote_host_var: STRING = "REMOTE_HOST"
	Remote_addr_var: STRING = "REMOTE_ADDR"
	Auth_type_var: STRING = "AUTH_TYPE"
	Remote_user_var: STRING = "REMOTE_USER"
	Remote_ident_var: STRING = "REMOTE_IDENT"
	Content_type_var: STRING = "CONTENT_TYPE"
	Content_length_var: STRING = "CONTENT_LENGTH"
	Http_from_var: STRING = "HTTP_FROM"
	Https_var: STRING = "HTTPS"
	Http_accept_var: STRING = "HTTP_ACCEPT"
	Http_user_agent_var: STRING = "HTTP_USER_AGENT"
	Http_referer_var: STRING = "HTTP_REFERER"
	Http_cookie_var: STRING = "HTTP_COOKIE"

end -- class GOA_CGI_VARIABLES
