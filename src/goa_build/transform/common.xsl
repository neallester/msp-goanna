<?xml version="1.0"?> 
<!--
     	description: "Common elements for XML Writing Classes specified by a Relax NG Schema "
	author: "Neal L Lester <neal@3dsafety.com>"
	date: "$Date: 2007-05-17 13:48:01 -0700 (Thu, 17 May 2007) $"
	revision: "$Revision: 573 $"
	copyright: "Copyright (c) 2004 Neal L Lester"
	license:   "Eiffel Forum License V2.0 (http://www.opensource.org/licenses/ver2_eiffel.php)"

-->
<xsl:transform xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
   xmlns:rng="http://relaxng.org/ns/structure/1.0"
   xmlns:xs="http://www.w3.org/2001/XMLSchema"
   xmlns:imp="http://www.sourceforge.net/projects/goanna/imported_grammars"
   exclude-result-prefixes="rng">
   
	<xsl:param name="prefix" select="in-scope-prefixes(/rng:grammar)[1]" />
  	<xsl:param name="author" select="''" />
  	<xsl:param name="copyright" select="''" />
  	<xsl:param name="license" select="''" />
  	<xsl:variable name="prefix_upper" as="xs:string" select="upper-case($prefix)" />
  	<xsl:variable name="prefix_lower" as="xs:string" select="lower-case($prefix)" />
	<xsl:variable name="namespace" as="xs:string" select="namespace-uri-for-prefix ($prefix, /rng:grammar)" />
	<xsl:variable name="imported_file_name" as="xs:string" select="concat ($prefix_lower, '.imp')" />
	<xsl:variable name="imported_elements" as="document-node()" select="document ($imported_file_name)" />
	<xsl:variable name="all_element_collections" select="//rng:define[child::rng:choice | child::rng:ref | child::rng:zeroOrMore | child::rng:oneOrMore]" />
	<xsl:key name="attributes" match="//rng:attribute" use="@name" />
	<xsl:key name="elements" match="//rng:element" use="../@name" />
	<xsl:key name="refs" match="//rng:ref" use="@name" />
	<xsl:key name="element_collections" match="//rng:define[child::rng:choice | child::rng:ref | child::rng:zeroOrMore | child::rng:oneOrMore]" use="@name" />


 
<xsl:template match="rng:element" mode="element_tag_constant">

	<!-- Name of string contstant for an element tag -->

	<xsl:value-of select="lower-case (translate(../@name, ':-', '__'))" />
	<xsl:text>_element_tag</xsl:text>
</xsl:template>

<xsl:template match="rng:attribute" mode="attribute_name_constant">

	<!-- Name of string constant for an attribute name -->

	<xsl:variable name="fixed_tag" as="xs:string" select="lower-case (translate(@name, ':-', '__'))" />
	<xsl:value-of select="$fixed_tag" />
	<xsl:text>_attribute_name</xsl:text>
</xsl:template>

<xsl:template match="rng:attribute" mode="attribute_code">

	<!-- Name of constant defining code for an attribute -->

	<xsl:value-of select="lower-case (translate(@name, ':-', '__'))" />
	<xsl:text>_attribute_code</xsl:text>
</xsl:template>

<xsl:template match="rng:element" mode="element_code">

	<!-- Name of constant defining code for an element -->

	<xsl:value-of select="lower-case (translate(../@name, ':-', '__'))" />
	<xsl:text>_element_code</xsl:text>
</xsl:template>


<xsl:template match="rng:element" mode="element_name">

	<!-- Name of a feature that adds an element to the document -->

	<xsl:choose>
		<xsl:when test="descendant::rng:ref[key ('elements', @name) | key ('element_collections', @name)]">
			<xsl:text>start_</xsl:text>
		</xsl:when>
		<xsl:otherwise>
			<xsl:text>add_</xsl:text>
		</xsl:otherwise>
	</xsl:choose>
	<xsl:value-of select="../@name" />
	<xsl:text>_element</xsl:text>
</xsl:template>



<xsl:template match="rng:element[key ('elements', ../@name)]" mode="element_features">

	<xsl:param name="include_dbc" select="'yes'" />
	<xsl:param name="is_deferred" select="'yes'" />

	<!-- Features that add an elements to the document -->

	<xsl:variable name="name" as="xs:string" select="../@name"/>
	<xsl:variable name="element_code" as="xs:string" select="concat ($name, '_element_code')" />
	<xsl:variable name="last_ref" as="node()?" select="descendant::rng:ref[position () = last()]" />
 	<xsl:variable name="includes_elements" as="xs:boolean" select="count (descendant::rng:ref[key ('elements', @name) | key ('element_collections', @name)]) > 0" />
 	<xsl:variable name="open_ended" as="xs:boolean" select="$last_ref[ancestor::rng:oneOrMore or ancestor::rng:zeroOrMore]" />
 	<xsl:variable name="has_attributes" as="xs:boolean" select="count (descendant::rng:ref[key ('attributes', @name)]) > 0" />
 	<xsl:variable name="has_elements" as="xs:boolean" select="count (descendant::rng:ref[key ('elements', @name) | key ('element_collections', @name)]) > 0" />
 	<xsl:variable name="text_element_is_last" as="xs:boolean" select="name (descendant::*[last()]) eq 'text'" />
 	<xsl:variable name="only_one_text_element" as="xs:boolean" select="count (descendant::rng:text) = 1 and not (descendant::rng:text/ancestor::zeroOrMore) and not (descendant::rng:text/ancestor::oneOrMore)" />
 	<xsl:variable name="text_not_in_choice" as="xs:boolean" select="not (descendant::rng:text/ancestor::rng:choice)" />
 	<xsl:variable name="add_text_parameter" as="xs:boolean" select="$text_element_is_last and $only_one_text_element and $text_not_in_choice and not ($has_elements)" />
<!-- Removed $text_element_is_last  -->
<!-- xsl:variable name="add_text_parameter" as="xs:boolean" select="$text_element_is_last and $only_one_text_element and $text_not_in_choice and not ($has_elements)" / -->

 	<xsl:variable name="text_is_mandatory" as="xs:boolean" select="not (descendant::rng:text/ancestor::rng:optional or descendant::rng:text/ancestor::rng:zeroOrMore)" />

 	<xsl:variable name="is_a_root_element" as="xs:boolean" select="count(//rng:ref[@name = $name]/ancestor::rng:start) > 0" />
	<xsl:text>&#x9;</xsl:text>
	<xsl:apply-templates select="." mode="element_name" />
	<xsl:if test="$has_attributes or $add_text_parameter">
		<xsl:text> (</xsl:text>
		<xsl:apply-templates select="descendant::rng:ref" mode="build_feature_variables">
		<xsl:with-param name="add_text_parameter" select="$add_text_parameter" />
		</xsl:apply-templates>
		<xsl:if test="$add_text_parameter">
			<xsl:text>text_to_add: STRING</xsl:text>
		</xsl:if>
		<xsl:text>)</xsl:text>
	</xsl:if>
	<xsl:text> is&#xA;</xsl:text>
	<xsl:choose>
		<xsl:when test="$includes_elements">
			<xsl:text>&#x9;&#x9;&#x9;-- Start a new </xsl:text><xsl:value-of select="@name" /><xsl:text> element to the xml document&#xA;</xsl:text>
			<xsl:text>&#x9;&#x9;&#x9;-- Use end_current_element when done adding sub-elements to this element&#xA;</xsl:text>
		</xsl:when>
		<xsl:otherwise>
			<xsl:text>&#x9;&#x9;&#x9;--Add a new </xsl:text><xsl:value-of select="@name" /><xsl:text> element to the xml document&#xA;</xsl:text>
		</xsl:otherwise>
	</xsl:choose>
	<xsl:if test="descendant::rng:ref[key ('attributes', @name) and ancestor::rng:choice and ancestor::rng:optional]">
		<xsl:text>&#x9;&#x9;&#x9;-- Use the attribute name code xml_null_code to indicate a null attribute for the choice&#xA;</xsl:text>
	</xsl:if>
	<xsl:if test="$include_dbc='yes'">
		<xsl:text>&#x9;&#x9;require&#xA;</xsl:text>
		<xsl:text>&#x9;&#x9;&#x9;ok_to_add_</xsl:text>
		<xsl:value-of select="$name" />
		<xsl:text>: </xsl:text>
		<xsl:choose>
			<xsl:when test="$is_a_root_element">
				<xsl:text>not root_element_added&#xA;</xsl:text>
			</xsl:when>
			<xsl:otherwise>
				<xsl:text>ok_to_add_element_or_text (</xsl:text>
				<xsl:value-of select="$element_code" />
				<xsl:text>)&#xA;</xsl:text>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:if test="$add_text_parameter and $text_is_mandatory">
			<xsl:text>&#x9;&#x9;&#x9;valid_text_to_add: text_to_add /= Void and then not text_to_add.is_empty&#xA;</xsl:text>
		</xsl:if>
		<xsl:apply-templates select="descendant::rng:ref" mode="adding_elements">
			<xsl:with-param name="mode" select="'require'" />
		</xsl:apply-templates>
	</xsl:if>
	<xsl:choose>
		<xsl:when test="$is_deferred='yes'">
			<xsl:text>		deferred&#xA;</xsl:text>
		</xsl:when>
		<xsl:otherwise>
			<xsl:text>		local&#xA;</xsl:text>
			<xsl:text>			name_index, value_index: INTEGER&#xA;</xsl:text>
			<xsl:text>		do&#xA;</xsl:text>
			<xsl:text>			writer.start_ns_tag ("", element_tag_for_code (</xsl:text>
			<xsl:value-of select="$element_code" />
			<xsl:text>))&#xA;</xsl:text>
			<xsl:if test="$is_a_root_element">
				<xsl:text>			root_element_added := True&#xA;</xsl:text>
				<xsl:text>			writer.set_a_name_space ("</xsl:text><xsl:value-of select="$prefix" /><xsl:text>", "</xsl:text><xsl:value-of select="$namespace" /><xsl:text>")&#xA;</xsl:text>
				<xsl:for-each select="$imported_elements//imp:namespace">
					<xsl:text>			writer.set_a_name_space ("</xsl:text><xsl:value-of select="@prefix" /><xsl:text>", "</xsl:text><xsl:value-of select="@uri" /><xsl:text>")&#xA;</xsl:text>
				</xsl:for-each>
			</xsl:if>
			<xsl:apply-templates select="descendant::rng:ref" mode="adding_elements">
				<xsl:with-param name="mode" select="'do'" />
			</xsl:apply-templates>
			<xsl:if test="$add_text_parameter">
				<xsl:text>			if text_to_add /= Void then&#xA;</xsl:text>
				<xsl:text>				writer.add_data (text_to_add)&#xA;</xsl:text>
				<xsl:text>			end&#xA;</xsl:text>
			</xsl:if>
			<xsl:text>			current_element_contents.force (</xsl:text>
			<xsl:value-of select="$element_code" />
			<xsl:text>, current_element_contents.upper + 1)&#xA;</xsl:text>
			<xsl:if test="$includes_elements">
				<xsl:text>			element_stack.put (</xsl:text>
				<xsl:value-of select="$element_code" />
				<xsl:text>)&#xA;</xsl:text>
				<xsl:text>			contents_stack.put (&lt;&lt;&gt;&gt;)&#xA;</xsl:text>
			</xsl:if>
			<xsl:if test="not ($includes_elements)">
				<xsl:text>			writer.stop_tag&#xA;</xsl:text>
			</xsl:if>
		</xsl:otherwise>
	</xsl:choose>
	<xsl:if test="$include_dbc='yes'">
		<xsl:text>&#x9;&#x9;ensure&#xA;</xsl:text>
		<xsl:if test="$is_a_root_element">
			<xsl:text>			root_element_added: root_element_added&#xA;</xsl:text>
		</xsl:if>
		<xsl:if test="$includes_elements">
			<xsl:text>			open_element_count_updated: element_stack.count = old element_stack.count + 1&#xA;</xsl:text>
			<xsl:text>			current_element_updated: current_element_code = </xsl:text>
			<xsl:value-of select="$element_code" />
			<xsl:text>&#xA;</xsl:text>
			<xsl:text>			current_element_content_is_empty: current_element_contents.is_empty&#xA;</xsl:text>
		</xsl:if>
		<xsl:if test="not ($includes_elements)">
			<xsl:text>			current_element_unchanged: current_element_code = old current_element_code&#xA;</xsl:text>
			<xsl:text>			open_element_count_unchanged: element_stack.count = old element_stack.count&#xA;</xsl:text>
			<xsl:text>			current_element_contents_updated: current_element_contents.count = (old current_element_contents.count + 1) and current_element_contents @ current_element_contents.upper = </xsl:text>
			<xsl:value-of select="$element_code" />
			<xsl:text>&#xA;</xsl:text>
		</xsl:if>
	</xsl:if>
	<xsl:text>&#x9;&#x9;end&#xA;&#xA;</xsl:text>
</xsl:template>

<xsl:template match="rng:ref" mode="adding_elements">

	<!-- The preconditions and do for a feature that adds an element to the document -->

	<xsl:param name="mode" select="'require'" />
	<xsl:variable name="attribute" as="node()?" select="key ('attributes', @name)" />
	<xsl:if test="count ($attribute) > 0">
		<xsl:variable name="current_name" as="xs:string" select="$attribute/@name" />
		<xsl:variable name="attribute_code" as="xs:string" select="concat($current_name, '_attribute_code')" />
		<xsl:variable name="current_choice" as="node ()?" select="ancestor::rng:choice" />
		<xsl:variable name="is_a_choice" as="xs:boolean"  select="count ($current_choice) > 0" />
		<xsl:variable name="first_of_a_choice" as="xs:boolean" select="$is_a_choice and ancestor::rng:choice/rng:ref[1]/@name = $current_name" />
		<xsl:variable name="has_values" as="xs:boolean" select="$attribute/descendant::rng:value" />
		<xsl:variable name="multiple_attributes" as="xs:boolean" select="ancestor::rng:zeroOrMore or ancestor::rng:oneOrMore and ancestor::rng:choice" />
		<xsl:variable name="mandatory" as="xs:boolean" select="not (ancestor::rng:optional or ancestor::rng:zeroOrMore)" />
		<xsl:if test="$mode = 'require'">
			<xsl:if test="$first_of_a_choice">

				<xsl:if test="$multiple_attributes">
					<xsl:text>&#x9;&#x9;&#x9;valid_</xsl:text>
					<xsl:apply-templates select="." mode="choice_name" />
					<xsl:text>: </xsl:text>
					<xsl:apply-templates select="." mode="choice_name" /> 
					<xsl:text> /= Void</xsl:text>
					<xsl:if test="$mandatory">
						<xsl:text> and then not </xsl:text>
						<xsl:apply-templates select="." mode="choice_name" /> 
						<xsl:text>.is_empty</xsl:text>
					</xsl:if>
					<xsl:text>&#x9;&#x9;&#x9;valid_</xsl:text>
					<xsl:apply-templates select="." mode="choice_value" />
					<xsl:text>: </xsl:text>
					<xsl:apply-templates select="." mode="choice_value" />
					<xsl:text>/= Void&#xA;</xsl:text>					
					<xsl:text>&#x9;&#x9;&#x9;names_values_count_</xsl:text>
					<xsl:value-of select="generate-id(ancestor::rng:choice)" />
					<xsl:text>: equal (</xsl:text>
					<xsl:apply-templates select="." mode="choice_name" />
					<xsl:text>.count, </xsl:text>
					<xsl:apply-templates select="." mode="choice_value" />
					<xsl:text>.count)&#xA;</xsl:text>
					<xsl:text>&#x9;&#x9;&#x9;no_null_</xsl:text>
					<xsl:apply-templates select="." mode="choice_name" />
					<xsl:text>: not </xsl:text>
					<xsl:apply-templates select="." mode="choice_name" />
					<xsl:text>.has (xml_null_code)&#xA;</xsl:text>
					<xsl:text>&#x9;&#x9;&#x9;no_null_</xsl:text>
					<xsl:apply-templates select="." mode="choice_value" />
					<xsl:text>: not </xsl:text>
					<xsl:apply-templates select="." mode="choice_value" />
					<xsl:text>.has (Void)&#xA;</xsl:text>
					<xsl:text>&#x9;&#x9;&#x9;are_all_</xsl:text>
					<xsl:apply-templates select="." mode="choice_name" />
					<xsl:text>_valid: not </xsl:text>
					<xsl:apply-templates select="." mode="choice_name" />
					<xsl:text>.is_empty implies are_all_input_names_valid (</xsl:text>
					<xsl:apply-templates select="." mode="choice_name" />
					<xsl:text>, </xsl:text>
					<xsl:apply-templates select="." mode="choice_name" />
					<xsl:text>)&#xA;</xsl:text>
					<xsl:text>&#x9;&#x9;&#x9;are_all_</xsl:text>
					<xsl:apply-templates select="." mode="choice_value" />
					<xsl:text>_valid: not </xsl:text>
					<xsl:apply-templates select="." mode="choice_name" />
					<xsl:text>.is_empty implies are_all_attribute_values_valid (</xsl:text>
					<xsl:apply-templates select="." mode="choice_name" />
					<xsl:text>, </xsl:text>
					<xsl:apply-templates select="." mode="choice_value" />
					<xsl:text>)&#xA;</xsl:text>
				</xsl:if>
				<xsl:if test="not ($multiple_attributes)">
					<xsl:if test="$mandatory">
						<xsl:text>&#x9;&#x9;&#x9;valid_</xsl:text>
						<xsl:apply-templates select="." mode="choice_name" />
						<xsl:text>: </xsl:text>
						<xsl:apply-templates select="." mode="choice_name" /> 
						<xsl:text>/= xml_null_code&#xA;</xsl:text>
						<xsl:text>&#xA;</xsl:text>
						<xsl:text>&#x9;&#x9;&#x9;valid_</xsl:text>
						<xsl:apply-templates select="." mode="choice_value" />
						<xsl:text>: </xsl:text>
						<xsl:apply-templates select="." mode="choice_value" />
						<xsl:text>/= Void&#xA;</xsl:text>
					</xsl:if>
					<xsl:text>&#x9;&#x9;&#x9;is_valid_</xsl:text>
					<xsl:apply-templates select="." mode="choice_name" />
					<xsl:text>: </xsl:text>
					<xsl:apply-templates select="." mode="choice_name" />
					<xsl:text> /= xml_null_code implies (create {ARRAY[INTEGER]}.make_from_array (</xsl:text>
					<xsl:apply-templates select="$current_choice" mode="contents_as_attribute_code_array"/>
					<xsl:text>)).has (</xsl:text>
					<xsl:apply-templates select="." mode="choice_name" />
					<xsl:text>)&#xA;</xsl:text>
				</xsl:if>
			</xsl:if>
			<xsl:if test="not ($is_a_choice) and not ($multiple_attributes)">
				<xsl:text>&#x9;&#x9;&#x9;is_valid_value_</xsl:text>
				<xsl:apply-templates select="." mode="attribute_value_variable" />
				<xsl:text>: </xsl:text>
				<xsl:apply-templates select="." mode="attribute_value_variable" />
				<xsl:text> /= Void implies is_valid_attribute_value (</xsl:text>
				<xsl:apply-templates select="." mode="attribute_code" />
				<xsl:text>, </xsl:text>
				<xsl:apply-templates select="." mode="attribute_value_variable" />
				<xsl:text>)&#xA;</xsl:text>
			</xsl:if>
			<xsl:if test="$is_a_choice and not ($multiple_attributes)">
				<xsl:text>&#x9;&#x9;&#x9;valid_value_if_</xsl:text>
				<xsl:value-of select="$attribute/@name"/>
				<xsl:text>: </xsl:text>
				<xsl:apply-templates select="." mode="choice_name" />
				<xsl:text> = </xsl:text>
				<xsl:apply-templates select="." mode="attribute_code" />
				<xsl:text> implies is_valid_attribute_value (</xsl:text>
				<xsl:apply-templates select="." mode="attribute_code" />
				<xsl:text>, </xsl:text>
				<xsl:apply-templates select="." mode="choice_value" />
				<xsl:text>)&#xA;</xsl:text>
			</xsl:if>
			<xsl:if test="not ($is_a_choice) and $mandatory">
				<xsl:text>&#x9;&#x9;&#x9;valid_</xsl:text>
				<xsl:apply-templates select="." mode="attribute_value_variable" />
				<xsl:text>: </xsl:text>
				<xsl:apply-templates select="." mode="attribute_value_variable" />
				<xsl:text> /= Void&#xA;</xsl:text>
			</xsl:if>
			<xsl:if test="not ($is_a_choice) and $multiple_attributes">
				<xsl:text>&#x9;&#x9;&#x9;all_</xsl:text>
				<xsl:value-of select="$attribute/@name"/>
				<xsl:text>_attribute_values_are_valid: new_</xsl:text>
				<xsl:value-of select="$attribute/@name"/>
				<xsl:text> /= Void implies are_all_attribute_values_valid (&lt;&lt;</xsl:text>
				<xsl:apply-templates select="." mode="attribute_code" />
				<xsl:text>&gt;&gt;, </xsl:text>
				<xsl:apply-templates select="." mode="attribute_value_variable" />
				<xsl:text>)&#xA;</xsl:text>
			</xsl:if>
		</xsl:if>
		<xsl:if test="$mode = 'do'">
			<xsl:if test="$first_of_a_choice and not ($multiple_attributes)">
				<xsl:text>			if </xsl:text>
				<xsl:apply-templates select="." mode="choice_name" />
				<xsl:text> /= xml_null_code then&#xA;</xsl:text>
				<xsl:text>				writer.add_attribute (attribute_name_for_code (</xsl:text>
				<xsl:apply-templates select="." mode="choice_name" />
				<xsl:text>), </xsl:text>
				<xsl:apply-templates select="." mode="choice_value" />
				<xsl:text>)&#xA;</xsl:text>
				<xsl:text>			end&#xA;</xsl:text>
			</xsl:if>
			<xsl:if test="not ($is_a_choice) and not ($multiple_attributes)">
				<xsl:text>			if </xsl:text>
				<xsl:apply-templates select="." mode="attribute_value_variable" />
				<xsl:text> /= Void then&#xA;</xsl:text>
				<xsl:text>				writer.add_attribute (attribute_name_for_code (</xsl:text>
				<xsl:value-of select="$attribute_code" />
				<xsl:text>), </xsl:text>
				<xsl:apply-templates select="." mode="attribute_value_variable" />
				<xsl:text>)&#xA;</xsl:text>
				<xsl:text>			end&#xA;</xsl:text>
			</xsl:if>
			<xsl:if test="$multiple_attributes">
				<xsl:if test="$first_of_a_choice">
					<xsl:text>			if </xsl:text>
					<xsl:apply-templates select="." mode="choice_name" />
					<xsl:text> /= Void and </xsl:text>
					<xsl:apply-templates select="." mode="choice_value" />
					<xsl:text> /= Void then&#xA;</xsl:text>
					<xsl:text>				from&#xA;</xsl:text>
					<xsl:text>					name_index := </xsl:text>
					<xsl:apply-templates select="." mode="choice_name" />
					<xsl:text>.lower&#xA;</xsl:text>
					<xsl:text>					value_index := </xsl:text>
					<xsl:apply-templates select="." mode="choice_value" />
					<xsl:text>.lower&#xA;</xsl:text>
					<xsl:text>				until&#xA;</xsl:text>
					<xsl:text>					name_index > </xsl:text>
					<xsl:apply-templates select="." mode="choice_name" />
					<xsl:text>.upper&#xA;</xsl:text>
					<xsl:text>				loop&#xA;</xsl:text>
					<xsl:text>					writer.add_attribute (attribute_name_for_code (</xsl:text>
					<xsl:apply-templates select="." mode="choice_name" />
					<xsl:text> @ name_index), </xsl:text>
					<xsl:apply-templates select="." mode="choice_value" />
					<xsl:text> @ value_index)&#xA;</xsl:text>
					<xsl:text>					name_index := name_index + 1&#xA;</xsl:text>
					<xsl:text>					value_index := value_index + 1&#xA;</xsl:text>
					<xsl:text>				end&#xA;</xsl:text>
					<xsl:text>			end&#xA;</xsl:text>
				</xsl:if>
				<xsl:if test="not ($is_a_choice)">
					<xsl:text>			if </xsl:text>
					<xsl:apply-templates select="." mode="attribute_value_variable" />
					<xsl:text> /= Void then&#xA;</xsl:text>
					<xsl:text>				from&#xA;</xsl:text>
					<xsl:text>					value_index := </xsl:text>
					<xsl:apply-templates select="." mode="attribute_value_variable" />
					<xsl:text>.lower&#xA;</xsl:text>
					<xsl:text>				until&#xA;</xsl:text>
					<xsl:text>					value_index > </xsl:text>
					<xsl:apply-templates select="." mode="attribute_value_variable" />
					<xsl:text>.upper&#xA;</xsl:text>
					<xsl:text>				loop&#xA;</xsl:text>
					<xsl:text>					writer.add_attribute (attribute_name_for_code (</xsl:text>
					<xsl:apply-templates select="." mode="attribute_code" />
					<xsl:text>), </xsl:text>
					<xsl:apply-templates select="." mode="attribute_value_variable" />
					<xsl:text>@ value_index)&#xA;</xsl:text>
					<xsl:text>					value_index := value_index + 1&#xA;</xsl:text>
					<xsl:text>				end&#xA;</xsl:text>
					<xsl:text>			end&#xA;</xsl:text>
				</xsl:if>
			</xsl:if>
		</xsl:if>
	</xsl:if>
</xsl:template>

<xsl:template match="rng:choice" mode="contents_as_attribute_code_array">

	<!-- 	The attribute elements within a choice formatted as a manifest array
		of their corresponding attribute codes -->
	
	<xsl:text>&lt;&lt;</xsl:text>
	<xsl:for-each select="descendant::rng:ref">
		<xsl:value-of select="@name" /><xsl:text>_attribute_code</xsl:text>
		<xsl:if test="position() != last()">
			<xsl:text>, </xsl:text>
		</xsl:if>
	</xsl:for-each>
	<xsl:text>&gt;&gt;</xsl:text>
</xsl:template>
     
<xsl:template match="rng:choice" mode="contents_as_element_code_array">

	<!-- The element references and text elements in a choice element formatted
	     as an Eiffel manifest array of their corresponding element codes -->
	<xsl:text>&lt;&lt;</xsl:text>
		<xsl:for-each select="descendant::*">
			<xsl:if test="@name"><xsl:value-of select="@name" />
				<xsl:text>_element_code</xsl:text>
			</xsl:if>
			<xsl:if test="lower-case(local-name ()) = 'text'">
				<xsl:text>xml_text_code</xsl:text>
			</xsl:if>
			<xsl:if test="position() != last()">
				<xsl:text>, </xsl:text>
			</xsl:if>
		 </xsl:for-each>
		<xsl:text>&gt;&gt;</xsl:text>
</xsl:template>

 
<xsl:template match="rng:ref" mode="attribute_value_variable">

	<!-- Feature parameter name to add a new attribute value to an element -->

	<xsl:text>new_</xsl:text>
	<xsl:value-of select="@name" />
</xsl:template>

<xsl:template match="rng:ref" mode="attribute_code">
	
	<!-- Name of attribute code corresponding to current element -->
	
	<xsl:value-of select="@name" />
	<xsl:text>_attribute_code</xsl:text>
</xsl:template>

<xsl:template match="rng:ref" mode="choice_name">

	<!-- 	Name of feature to add the attribute name code for the choice
		containing the current element to an element -->

	<xsl:text>choice_</xsl:text>
	<xsl:value-of select="generate-id(ancestor::rng:choice)" />
	<xsl:text>_name_code</xsl:text>
</xsl:template>

<xsl:template match="rng:ref" mode="choice_value">

	<!-- 	Name of feature to add the attribute value for the choice
		containing the current element to an element -->

	<xsl:text>choice_</xsl:text>
	<xsl:value-of select="generate-id(ancestor::rng:choice)" />
	<xsl:text>_value</xsl:text>
</xsl:template>


<xsl:template match="rng:ref" mode="value_type">

	<!-- 	The Eiffel Type (class name) for a feature parameter to add an attribute value
		to an element -->

	<xsl:choose>
		<xsl:when test="ancestor::rng:zeroOrMore or ancestor::rng:oneOrMore and ancestor::rng:choice">
			<xsl:text>ARRAY [STRING]</xsl:text>
		</xsl:when>
		<xsl:otherwise>
			<xsl:text>STRING</xsl:text>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<xsl:template match="rng:ref" mode="name_type">

	<!-- 	The Eiffel Type (class name) for a feature parameter to add an attribute name code
		which is part of a choice to an element -->

	<xsl:choose>
		<xsl:when test="ancestor::rng:zeroOrMore or ancestor::rng:oneOrMore">
			<xsl:text>ARRAY [INTEGER]</xsl:text>
		</xsl:when>
		<xsl:otherwise>
			<xsl:text>INTEGER</xsl:text>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<xsl:template match="rng:include">
	<xsl:variable name="class_prefix" as="xs:string" select="upper-case(substring-before (@href, '.'))" />
	<!-- 	Build class name for any included schemas for use
		in the inheritance clause -->
	<xsl:value-of select="$class_prefix" />_XML_DOCUMENT_EXTENDED
</xsl:template>

</xsl:transform>
