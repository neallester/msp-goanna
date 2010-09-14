note
	description: "Objects that represent an XML-RPC call and response struct parameter values."
	project: "Project Goanna <http://sourceforge.net/projects/goanna>"
	library: "XML-RPC"
	date: "$Date: 2006-04-16 23:42:40 -0700 (Sun, 16 Apr 2006) $"
	revision: "$Revision: 491 $"
	author: "Glenn Maughan <glennmaughan@users.sourceforge.net>"
	copyright: "Copyright (c) 2001 Glenn Maughan and others"
	license: "Eiffel Forum License v2 (see forum.txt)."

class GOA_XRPC_STRUCT_VALUE

inherit
	
	GOA_XRPC_VALUE

create

	make, make_from_struct, unmarshall

feature -- Initialisation

	make (new_value: like value)
			-- Create struct type from 'new_value'. 
		require
			new_value_exists: new_value /= Void
		do
			type := Struct_type
			value := new_value
			unmarshall_ok := True
		end

	make_from_struct (struct: DS_HASH_TABLE [ANY, STRING])
			-- Create struct type from 'new_value'. 
		require
			struct_exists: struct /= Void
		local
			c: DS_HASH_TABLE_CURSOR [ANY, STRING]
		do
			type := Struct_type
			create value.make (struct.count)
			from
				c := struct.new_cursor
				c.start
			until
				c.off
			loop
				value.put (Value_factory.build (c.item), c.key)
				c.forth
			end
			unmarshall_ok := True
		end
		
	unmarshall (node: XM_ELEMENT)
			-- Unmarshall struct value from XML node.
		local
			member_cursor: DS_BILINEAR_CURSOR [XM_NODE]
			next, next_value, next_name: XM_ELEMENT
			name_text: STRING
			unmarshalled: GOA_XRPC_VALUE
		do
			unmarshall_ok := True
			type := Struct_type
			-- unmarshall each member
			if not node.is_empty then
				member_cursor := node.new_cursor
				create value.make (node.count)
				from
					member_cursor.start
				until
					member_cursor.off or not unmarshall_ok 
				loop
					next ?= member_cursor.item
					check
						next_is_element: next /= Void
					end
					if next.name.is_equal (Member_element) then
						-- find name and value elements
						next_name := get_named_element (next, Name_element)
						if next_name /= Void then
							next_value := get_named_element (next, Value_element)
							if next_value /= Void then
								-- unmarshall value and store in array
								unmarshalled := Value_factory.unmarshall (next_value)
								if unmarshalled.unmarshall_ok then
									name_text := next_name.text
									if name_text /= Void then
										value.put (unmarshalled, name_text.out)	
									else
										unmarshall_ok := False
										unmarshall_error_code := Invalid_struct_member_name
									end
								else
									unmarshall_ok := False
									unmarshall_error_code := unmarshalled.unmarshall_error_code
								end	
							else
								unmarshall_ok := False
								unmarshall_error_code := Missing_value_element_for_struct_member
							end			
						else
							unmarshall_ok := False
							unmarshall_error_code := Missing_name_element_for_struct_member
						end
					else
						unmarshall_ok := False
						unmarshall_error_code := Unexpected_struct_element
					end
					member_cursor.forth
				end
			else
				-- empty struct is allowed
				create value.make (0)
			end
				
		end

feature -- Mashalling

	marshall: STRING
			-- Serialize this struct param to XML format
		local
			c: DS_HASH_TABLE_CURSOR [GOA_XRPC_VALUE, STRING]
		do	
			create Result.make (300)
			Result.append ("<value><struct>")
			from
				c := value.new_cursor
				c.start
			until
				c.off
			loop
				Result.append ("<member><name>")
				Result.append (c.key)
				Result.append ("</name>")
				Result.append (c.item.marshall)
				Result.append ("</member>")
				c.forth
			end
			Result.append ("</struct></value>")
		end

feature -- Access

	value: DS_HASH_TABLE [GOA_XRPC_VALUE, STRING]
		-- Structure value

feature -- Conversion

	as_object: ANY
			-- Return value as an object. ie, extract the actual 
			-- object value from the XRPC_VALUE.
		local
			struct: DS_HASH_TABLE [ANY, STRING]
			c: DS_HASH_TABLE_CURSOR [GOA_XRPC_VALUE, STRING]
		do
			create struct.make (value.count)
			from
				c := value.new_cursor
				c.start
			until
				c.off
			loop
				struct.force (c.item.as_object, c.key)
				c.forth
			end
			Result := struct
		end	
		
end -- class GOA_XRPC_STRUCT_VALUE
