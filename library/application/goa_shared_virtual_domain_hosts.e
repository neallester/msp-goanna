note
	description: "Shared access to Virtual Domain Hosts and related facilities"
	author: "Neal L Lester <neallester@users.sourceforge.net>"
	date: "$Date: 2006-04-16 23:42:40 -0700 (Sun, 16 Apr 2006) $"
	revision: "$Revision: 491 $"
	copyright: "(c) Neal L Lester"
	License: "Eiffel Forum License Version 2 (see forum.txt)"

class
	GOA_SHARED_VIRTUAL_DOMAIN_HOSTS
	
inherit
	
	GOA_SHARED_APPLICATION_CONFIGURATION
	
feature
	
	virtual_domain_for_host_name (host_name: STRING): VIRTUAL_DOMAIN_HOST
			-- Return virtual domain assigned to the host name
		do
			if virtual_domain_hosts.has (host_name) then
				Result := virtual_domain_hosts.item (host_name.as_lower)
			else
				Result := virtual_domain_hosts.item (configuration.default_virtual_host_lookup_string)
			end
		ensure
			valid_result: Result /= Void
		end
		
feature
	
	register_virtual_domain_host (host: VIRTUAL_DOMAIN_HOST; host_name: STRING)
			-- Register host under host_name
		require
			valid_host: host /= Void
			valid_host_name: host_name /= Void and then not host_name.is_empty
		do
			if virtual_domain_hosts.has (host_name) then
				virtual_domain_hosts.put (host, host_name)
			else
				virtual_domain_hosts.force (host, host_name)
			end
		end
		
	virtual_domain_hosts: DS_HASH_TABLE [VIRTUAL_DOMAIN_HOST, STRING]
			-- Table containing all virtual domain hosts
		once
			create Result.make_equal (5)
		end
	
invariant
	
	valid_virtual_domain_hosts: virtual_domain_hosts /= Void
	virtual_domain_hosts_has_default: virtual_domain_hosts.has (configuration.default_virtual_host_lookup_string)

end -- class GOA_SHARED_VIRTUAL_DOMAIN_HOSTS
