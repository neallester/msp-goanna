<?xml version="1.0"?> 
<!--
     	description: "Flatten a Relax NG grammer to inline referenced Include statements"
	             "Step three, remove include statements once they are no longer needed"
	author: "Neal L Lester <neal@3dsafety.com>"
	date: "$Date: 2006-04-16 23:42:40 -0700 (Sun, 16 Apr 2006) $"
	revision: "$Revision: 491 $"
	copyright: "Copyright (c) 2004 Neal L Lester"
	license:   "Eiffel Forum License V2.0 (http://www.opensource.org/licenses/ver2_eiffel.php)"

-->
<xsl:transform xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
   xmlns:rng="http://relaxng.org/ns/structure/1.0"
   exclude-result-prefixes="rng">

<xsl:template match="*|@*|comment()|processing-instruction()|text()">

  <!-- Copy all elements except those matching template below to output -->

  <xsl:copy>
    <xsl:apply-templates select="*|@*|comment()|processing-instruction()|text()" />
  </xsl:copy>
</xsl:template>

<!-- Swallow include elements; they are no longer needed -->

<xsl:template match="rng:include" />

</xsl:transform>