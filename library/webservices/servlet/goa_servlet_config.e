indexing
	description: "Objects that hold configuration data for a servlet."
	project: "Project Goanna <http://sourceforge.net/projects/goanna>"
	library: "Servlet API"
	date: "$Date: 2006-04-16 23:42:40 -0700 (Sun, 16 Apr 2006) $"
	revision: "$Revision: 491 $"
	author: "Glenn Maughan <glennmaughan@users.sourceforge.net>"
	copyright: "Copyright (c) 2001 Glenn Maughan and others"
	license: "Eiffel Forum License v2 (see forum.txt)."

class GOA_SERVLET_CONFIG

feature -- Access

	document_root: STRING
			-- Root directory for documents
		
	server_port: INTEGER
			-- Port server is listening on
				
feature -- Status setting

	set_document_root (dir: STRING) is
			-- Set the document root to 'dir'
		require
			dir_exists: dir /= Void
		do
			document_root := dir
		end
		
	set_server_port (port: INTEGER) is
			-- Set the server port to 'port'
		require
			valid_port: port > 0
		do
			server_port := port
		end
		
end -- class GOA_SERVLET_CONFIG
