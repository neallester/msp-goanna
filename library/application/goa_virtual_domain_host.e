note
	description: "A virtual domain host; VIRTUAL_DOMAIN_HOST should inherit from this class"
	author: "Neal L Lester <neallester@users.sourceforge.net>"
	date: "$Date: 2007-06-14 13:46:53 -0700 (Thu, 14 Jun 2007) $"
	revision: "$Revision: 579 $"
	copyright: "(c) Neal L Lester"
	License: "Eiffel Forum License Version 2 (see forum.txt)"

class
	GOA_VIRTUAL_DOMAIN_HOST

feature -- Attributes

	host_name: STRING

	base_url (is_secure: BOOLEAN): STRING
			-- URL to current virtual domain host
		local
			base: STRING
		do
			if is_secure and use_ssl then
				base := "https://"
			else
				base := "http://"
			end
			Result := base + host_name + "/"
		end

	use_ssl: BOOLEAN
			-- Does this site use SSL to protect traffic?

feature -- Attribute Setting

	set_host_name (new_host_name: STRING)
			-- Set host_name to new_host_name
		require
			valid_new_host_name: new_host_name /= Void and then not new_host_name.is_empty
		do
			host_name := new_host_name
		ensure
			host_name_updated: host_name = new_host_name
		end

	set_use_ssl
			-- Set domain to to use ssl
		do
			use_ssl := True
		end

end -- class GOA_VIRTUAL_DOMAIN_HOST
