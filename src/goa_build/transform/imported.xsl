<?xml version="1.0"?> 
<!--
     	description: "Flatten a Relax NG grammer to inline referenced Include statements"
		     "Create a file containing imported namespaces and references for imported elements"
	author: "Neal L Lester <neal@3dsafety.com>"
	date: "$Date: 2006-04-16 23:42:40 -0700 (Sun, 16 Apr 2006) $"
	revision: "$Revision: 491 $"
	copyright: "Copyright (c) 2004 Neal L Lester"
	license:   "Eiffel Forum License V2.0 (http://www.opensource.org/licenses/ver2_eiffel.php)"

-->
<xsl:transform xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
   xmlns:imp="http://www.sourceforge.net/projects/goanna/imported_grammars"
   xmlns:xs="http://www.w3.org/2001/XMLSchema"
   xmlns:rng="http://relaxng.org/ns/structure/1.0"
   exclude-result-prefixes="rng">

<xsl:variable name="first_element" as="node()" select="(//rng:element)[1]" />
<xsl:variable name="name_of_first_element" as="xs:string" select="$first_element/@name" />
<xsl:variable name="cleaned_name_of_first_element" as="xs:string" select="substring-before ($name_of_first_element, ':')" />

<xsl:template match="rng:grammar">

<!-- Process all rng:include elements in the document -->

  <xsl:element namespace="http://www.sourceforge.net/projects/goanna/imported_grammars" name="imp:imported">
    <xsl:apply-templates select="//rng:include"/>
  </xsl:element>
</xsl:template>

<xsl:template match="rng:include">

  <!-- Add an imp:namespace element for each rng:include element, then process
       the referenced file -->

  <xsl:variable name="prefix" as="xs:string" select="substring-before (@href, '.')" />
  <xsl:element namespace="http://www.sourceforge.net/projects/goanna/imported_grammars" name="imp:namespace">
    <xsl:attribute name="prefix"><xsl:value-of select="$prefix"/></xsl:attribute>
    <xsl:attribute name="uri"><xsl:value-of select="namespace-uri-for-prefix ($prefix, doc(@href)/rng:grammar)"/></xsl:attribute>
  </xsl:element>
  <xsl:apply-templates select="doc(@href)" mode = "import"/>
</xsl:template>


<xsl:template match="rng:element" mode="import">

  <!-- add an imp:ref element for each rng:element in the imported file -->

  <xsl:element name="imp:ref" namespace="http://www.sourceforge.net/projects/goanna/imported_grammars">
    <xsl:attribute name="name">
      <xsl:value-of select="@name" />
    </xsl:attribute>
  </xsl:element>
</xsl:template>

<xsl:template match="rng:value" mode="import">

  <!-- Add an imp:value element for each rng:value element in
       the imported files -->

  <xsl:element name="imp:value" namespace="http://www.sourceforge.net/projects/goanna/imported_grammars">
    <xsl:attribute name="name"><xsl:value-of select="ancestor::define/@name"/>_<xsl:value-of select="." /></xsl:attribute>
    <xsl:attribute name="value"><xsl:value-of select="." /></xsl:attribute>
  </xsl:element>
</xsl:template>

</xsl:transform>