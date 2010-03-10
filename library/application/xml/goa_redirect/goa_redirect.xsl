<?xml version="1.0"?> 
<!--
     	description: "Transform xml conforming to redirect.rnc to html"
	author: "Neal L Lester	<neal@3dsafety.com>"
	date: "$Date: 2006-04-16 23:42:40 -0700 (Sun, 16 Apr 2006) $"
	revision: "$Revision: 491 $"
	copyright: "Copyright (c) 2004 Neal L Lester"
	License: "Eiffel Forum License Version 2 (see forum.txt)"

-->
<xsl:transform xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
  xmlns:goa_redirect="http://www.sourceforge.net/projects/goanna/goa_redirect"
  xmlns:goa_common="http://www.sourceforge.net/projects/goanna/goa_common"
  exclude-result-prefixes="goa_redirect goa_common"
  >
  
<xsl:output method="html" doctype-public="-//W3C//DTD HTML 4.01 Transitional//EN" doctype-system="http://www.w3.org/TR/html4/loose.dtd" />

<xsl:include href="goa_common.xsl" />

  
<xsl:template match="goa_redirect:redirect">

<xsl:element name="HTML">
  <xsl:element name="HEAD">
    <xsl:element name="TITLE">
      <xsl:value-of select="@title" />
    </xsl:element>
    <xsl:element name="LINK">
      <xsl:attribute name="rel">stylesheet</xsl:attribute>
      <xsl:attribute name="type">text/css</xsl:attribute>
      <xsl:attribute name="href"><xsl:value-of select="@style_sheet" /></xsl:attribute>
    </xsl:element>
    <xsl:element name="META">
      <xsl:attribute name="http-equiv">refresh</xsl:attribute>
      <xsl:attribute name="content"><xsl:value-of select="@delay"/>; <xsl:value-of select="@url"/></xsl:attribute>
    </xsl:element>
  </xsl:element>
  <xsl:element name="BODY">
    <xsl:apply-templates />
  </xsl:element>
</xsl:element>

</xsl:template>


</xsl:transform>