<?xml version="1.0"?> 
<!--
     	description: "Create a pipe separated list of included files"
	author: "Neal L Lester <neal@3dsafety.com>"
	date: "$Date: 2006-04-16 23:42:40 -0700 (Sun, 16 Apr 2006) $"
	revision: "$Revision: 491 $"
	copyright: "Copyright (c) 2004 Neal L Lester"
	license:   "Eiffel Forum License V2.0 (http://www.opensource.org/licenses/ver2_eiffel.php)"

-->
<xsl:transform xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
   xmlns:rng="http://relaxng.org/ns/structure/1.0"
   exclude-result-prefixes="rng">
<xsl:output method="text" />

<xsl:template match="/rng:grammar">
<xsl:for-each select="rng:include">
<xsl:value-of select="@href" />
<xsl:if test="not (position()=last())">
<xsl:text>|</xsl:text>
</xsl:if>
</xsl:for-each>
</xsl:template>
</xsl:transform>