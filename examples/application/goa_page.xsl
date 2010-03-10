<?xml version="1.0"?> 
<!--
     	description: "Transform xml conforming to page.rnc to html"
	author: "Neal L Lester	<neal@3dsafety.com>"
	date: "$Date: 2007-03-29 05:19:54 -0800 (Thu, 29 Mar 2007) $"
	revision: "$Revision: 548 $"
	copyright: "Copyright (c) 2004 Neal L Lester"
	License: "Eiffel Forum License Version 2 (see forum.txt)"

-->
<xsl:transform xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
  xmlns:goa_page="http://www.sourceforge.net/projects/goanna/goa_page"
  xmlns:goa_common="http://www.sourceforge.net/projects/goanna/goa_common"
  xmlns:msp_common="http://www.mysafetyprogram.com/msp_common"
  exclude-result-prefixes="page goa_common msp_common"
  >
  
<xsl:output method="html" doctype-public="-//W3C//DTD HTML 4.01 Transitional//EN" doctype-system="http://www.w3.org/TR/html4/loose.dtd" />

<xsl:include href="goa_common.xsl" />

<xsl:template match="goa_page:page">

<xsl:element name="html">
  <xsl:element name="head">
    <!-- Page Title -->
    <xsl:element name ="title"><xsl:value-of select="/goa_page:page/@page_title" /></xsl:element>

    <xsl:element name="link">
	
      <!-- Link to external stylesheet -->

      <xsl:attribute name="rel">stylesheet</xsl:attribute>
      <xsl:attribute name="type">text/css</xsl:attribute>
      <xsl:attribute name="href">http://<xsl:value-of select="/goa_page:page/@host_name" />/<xsl:value-of select="/goa_page:page/@style_sheet" /></xsl:attribute>
    </xsl:element>
  </xsl:element>
  <xsl:element name="body">
    <xsl:choose>
      <xsl:when test="/goa_page:page/@submit_url"> 
	<xsl:element name="form">
	  <xsl:attribute name="action"><xsl:value-of select="/goa_page:page/@submit_url" /></xsl:attribute>
	  <xsl:attribute name="method">post</xsl:attribute>
	  <xsl:apply-templates />
	</xsl:element>
      </xsl:when>
      <xsl:otherwise>
	<xsl:apply-templates />
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates select="//goa_common:tool_tip" />
  </xsl:element>
</xsl:element>

</xsl:template>

</xsl:transform>