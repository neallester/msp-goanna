<?xml version="1.0"?> 
<!--
     	description: "Create list of pipe separated included file names"
	author: "Neal L Lester <neal@3dsafety.com>"
	date: "$Date: 2006-04-16 23:42:40 -0700 (Sun, 16 Apr 2006) $"
	revision: "$Revision: 491 $"
	copyright: "Copyright (c) 2004 Neal L Lester"
	license:   "Eiffel Forum License V2.0 (http://www.opensource.org/licenses/ver2_eiffel.php)"

-->
<xsl:transform
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0">
<xsl:output method="text" />
<xsl:template match="/xsl:transform">
<xsl:for-each select="xsl:include">
<xsl:value-of select="@href" />
<xsl:if test="not (position()=last())">
<xsl:text>|</xsl:text>
</xsl:if>
</xsl:for-each>
</xsl:template>
<xsl:template match="@*|node()">
</xsl:template>
</xsl:transform>