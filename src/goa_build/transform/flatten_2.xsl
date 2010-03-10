<?xml version="1.0"?>
<!--
		 	description: "Flatten a Relax NG grammer to inline referenced Include statements"
				 "Step 2; Merge references in combine elements with their corresponding choose element"
	author: "Neal L Lester <neal@3dsafety.com>"
	date: "$Date: 2007-04-24 13:18:52 -0700 (Tue, 24 Apr 2007) $"
	revision: "$Revision: 570 $"
	copyright: "Copyright (c) 2004 Neal L Lester"
	license:	 "Eiffel Forum License V2.0 (http://www.opensource.org/licenses/ver2_eiffel.php)"

-->
<xsl:transform xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
	 xmlns:rng="http://relaxng.org/ns/structure/1.0"
	 exclude-result-prefixes="rng">

<xsl:key name="elements" match="//rng:element" use="../@name" />
<xsl:key name="defines" match="//rng:define" use="@name" />

<xsl:template match="*|@*|comment()|processing-instruction()|text()">

	<!-- Copy all elements except those matching other templates to output -->

	<xsl:copy>
		<xsl:apply-templates select="*|@*|comment()|processing-instruction()|text()"/>
	</xsl:copy>
</xsl:template>



<!--
<xsl:template match="rng:choice[key ('elements', child::rng:ref/@name) and not(ancestor::rng:start)]">

	 Combine choice elements with parent rng:element elements of the same name

	<xsl:variable name="choice-name" select="ancestor::rng:define/@name" />
	<xsl:element name="choice" namespace="http://relaxng.org/ns/structure/1.0">
		<xsl:for-each select="//rng:ref[ancestor::rng:define/@name=$choice-name and key ('elements', @name)]">
			<xsl:element name="ref" namespace="http://relaxng.org/ns/structure/1.0">
				<xsl:attribute name="name">
					<xsl:value-of select="@name"/>
				</xsl:attribute>
			</xsl:element>
			<xsl:text>&#xA;</xsl:text>
		</xsl:for-each>
	</xsl:element>
</xsl:template>
-->


<!--  -->
<xsl:template match="rng:define">
	<xsl:variable name="thisName" select="@name" />
	<xsl:variable name="defs" as="node()*" select="//rng:define[@name=$thisName]" />

<!--
	<xsl:text>
		debug
	</xsl:text>
	<xsl:for-each select="$defs/child::*">
		<xsl:text>&#x9; local-name: </xsl:text><xsl:value-of select="local-name ()" />
		<xsl:if test="@name">   @name: <xsl:value-of select="@name" /></xsl:if>
		<xsl:text>&#xA;</xsl:text>
	</xsl:for-each>
	<xsl:text>
		gubed
	</xsl:text>
 -->

	<xsl:copy>
		<xsl:apply-templates select="@*"/>
<!--  -->
		<xsl:choose>
			<xsl:when test="count($defs) > 1">
				<xsl:element name="choice" namespace="http://relaxng.org/ns/structure/1.0">
					<xsl:for-each select="$defs/child::*">
						<xsl:choose>
							<xsl:when test="local-name() eq 'choice'">
								<xsl:for-each select="child::*">
									<xsl:apply-templates select="."/>
								</xsl:for-each>
							</xsl:when>
							<xsl:otherwise>
								<xsl:apply-templates select="."/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:for-each>
				</xsl:element>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates select="*|@*|comment()|processing-instruction()|text()"/>
			</xsl:otherwise>
		</xsl:choose>

	</xsl:copy>
</xsl:template>



<!-- Swallow all define elements that have a combine="choice" attribute.
		 These are duplicates from the included rng files, and we only one want define
		 element (from the primary file) for each rng:element in the output
-->
<xsl:template match="rng:define[@combine='choice' or @combine='interleave']" />


<!-- swallow all 'a:documentation' -->
<xsl:template	xmlns:a="http://relaxng.org/ns/compatibility/annotations/1.0" match="a:documentation" />

</xsl:transform>