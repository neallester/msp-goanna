<?xml version="1.0"?> 
<!--
     	description: "XSLT Transform to HTML for xml conforming to goa_common.rnc"
	author: "Neal L Lester	<neal@3dsafety.com>"
	date: "$Date: 2007-04-29 13:51:47 -0700 (Sun, 29 Apr 2007) $"
	revision: "$Revision: 572 $"
	copyright: "Copyright (c) 2004 Neal L Lester"
	License: "Eiffel Forum License Version 2 (see forum.txt)"
-->

<xsl:transform xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
  xmlns:goa_common="http://www.sourceforge.net/projects/goanna/goa_common"
  exclude-result-prefixes="goa_common"
  >

<xsl:key name="popup_hyperlink" match="goa_common:popup_hyperlink" use="'A'" />
<xsl:key name="tool_tip" match="goa_common:tool_tip"  use="'A'" />

<xsl:template match="goa_common:division">

	<!-- Division Template -->

	<xsl:element name="div">
		<xsl:call-template name="goa_common:class" />
		<xsl:apply-templates />
	</xsl:element>
</xsl:template>

		
<xsl:template match="goa_common:ordered_list">

	<!-- Ordered List Template -->

	<xsl:element name="ol">
		<xsl:apply-templates />
	</xsl:element>
</xsl:template>
		
<xsl:template match="goa_common:unordered_list">

	<!-- Unordered List Template -->

	<xsl:element name="ul">
		<xsl:apply-templates/>
	</xsl:element>
</xsl:template>

<xsl:template match="goa_common:list_item">

	<!-- Item in a ordered or unordered list -->

	<xsl:element name="li">		
		<xsl:apply-templates />
	</xsl:element>
</xsl:template>


<xsl:template match="goa_common:table">

	<!-- Generic Table Template -->
	
	<xsl:element name="table">
		<xsl:call-template name="goa_common:class" />
		<xsl:attribute name="summary"><xsl:value-of select="@summary"/></xsl:attribute>
		<xsl:if test="@cellspacing"><xsl:attribute name="cellspacing"><xsl:value-of select="@cellspacing" /></xsl:attribute></xsl:if>
		<xsl:if test="@cellpadding"><xsl:attribute name="cellpadding"><xsl:value-of select="@cellpadding" /></xsl:attribute></xsl:if>
		<xsl:apply-templates />
	</xsl:element>
</xsl:template>

<xsl:template match="goa_common:header">

	<!-- Generic Table Header Template -->
	
	<xsl:element name="thead">
		<xsl:call-template name="goa_common:class" />
		<xsl:apply-templates />
	</xsl:element>
</xsl:template>


<xsl:template match="goa_common:footer">

	<!-- Generic Table footer Template -->
	
	<xsl:element name="tfoot">
		<xsl:call-template name="goa_common:class" />
		<xsl:apply-templates />
	</xsl:element>
</xsl:template>
	
<xsl:template match="goa_common:body">

	<!-- Generic Table body Template -->
	
	<xsl:element name="tbody">
		<xsl:call-template name="goa_common:class" />
		<xsl:apply-templates />
	</xsl:element>
</xsl:template>

<xsl:template match="goa_common:row">

	<!-- Generic Table row Template -->
	
	<xsl:element name="tr">
		<xsl:call-template name="goa_common:class" />
		<xsl:apply-templates />
	</xsl:element>
</xsl:template>

<xsl:template match="goa_common:cell">

	<!-- Generic Table cell Template -->
	
	<xsl:element name="td">
		<xsl:call-template name="goa_common:class" />
		<xsl:if test="@colspan">
			<xsl:attribute name="colspan"><xsl:value-of select="@colspan" /></xsl:attribute>
		</xsl:if>
		<xsl:apply-templates />
	</xsl:element>
</xsl:template>

<xsl:template match="goa_common:input">
	
	<!-- Text and Password Input Template -->

	<xsl:element name="input">
		<xsl:call-template name="goa_common:input_attributes">
			<xsl:with-param name="type" select="@type" />
		</xsl:call-template>
	</xsl:element>
</xsl:template>
	
<xsl:template match="goa_common:password">

	<!-- Password input -->

	<xsl:element name="input">
		<xsl:call-template name="goa_common:input_attributes">
			<xsl:with-param name="type" select="@type" />
		</xsl:call-template>
	</xsl:element>
</xsl:template>	
	
<xsl:template match="goa_common:submit">

	<!-- Submit Input -->

	<xsl:element name="input">
		<xsl:call-template name="goa_common:input_attributes">
			<xsl:with-param name="type" select="'submit'" />
			<xsl:with-param name="submit" select="'submit'" />
		</xsl:call-template>
	</xsl:element>	
</xsl:template>
		
<xsl:template match="goa_common:hidden">

	<!-- Hidden Input -->
	
	<xsl:element name="input">
		<xsl:call-template name="goa_common:input_attributes">
			<xsl:with-param name="type" select="'hidden'" />
		</xsl:call-template>
	</xsl:element>	
</xsl:template>
	
<xsl:template match="goa_common:radio">

	<!-- Radio Button Input -->
	
	<xsl:element name="input">
		<xsl:call-template name="goa_common:input_attributes">
			<xsl:with-param name="type" select="'radio'" />
		</xsl:call-template>
	</xsl:element>	
</xsl:template>

<xsl:template match="goa_common:checkbox">

	<!-- Checkbox Input -->
	
	<xsl:element name="input">
		<xsl:call-template name="goa_common:input_attributes">
			<xsl:with-param name="type" select="'checkbox'" />
		</xsl:call-template>
	</xsl:element>
</xsl:template>
	
<xsl:template match="goa_common:select">

	<!-- Select Element -->

	<xsl:element name="select">
		<xsl:call-template name="goa_common:input_attributes" />
		<xsl:for-each select="goa_common:option">
			<xsl:element name="option">
				<xsl:call-template name="goa_common:input_attributes" />
				<xsl:value-of select="." />
			</xsl:element>
		</xsl:for-each>
	</xsl:element>
</xsl:template>

<xsl:template match="goa_common:text_area">

	<!-- A text area input -->
	
	<xsl:element name="textarea">
		<xsl:call-template name="goa_common:input_attributes" />
		<xsl:value-of select="." />
	</xsl:element>
</xsl:template>	

<xsl:template name="goa_common:input_attributes">

	<!-- Attributes for input, select, submit, and textarea elements -->
	
	<xsl:param name="type" select="@type" />
	<xsl:param name="name" select="@name" />
	<xsl:param name="submit" select="''" />
	<xsl:call-template name="goa_common:class" />
	<xsl:if test="$type">
		<xsl:attribute name="type"><xsl:value-of select="$type" /></xsl:attribute>
	</xsl:if>
	<xsl:if test="$name">
		<xsl:attribute name="name"><xsl:value-of select="$name" /></xsl:attribute>
	</xsl:if>
	<xsl:if test="@maxlength">
		<xsl:attribute name="maxlength"><xsl:value-of select="@maxlength" /></xsl:attribute>
	</xsl:if>
	<xsl:if test="@size">
		<xsl:attribute name="size"><xsl:value-of select="@size" /></xsl:attribute>
	</xsl:if>
	<xsl:if test="@checked='yes'">
		<xsl:attribute name="checked" />
	</xsl:if>
	<xsl:if test="@disabled = 'yes'">
		<xsl:attribute name="disabled" />
	</xsl:if>
	<xsl:if test="@value">
		<xsl:attribute name="value"><xsl:value-of select="@value" /></xsl:attribute>
	</xsl:if>
	<xsl:if test="@multiple">
		<xsl:attribute name="multiple" />
	</xsl:if>
	<xsl:if test="@selected = 'yes'">
		<xsl:attribute name="selected" />
	</xsl:if>
	<xsl:if test="@rows">
		<xsl:attribute name="rows"><xsl:value-of select="@rows" /></xsl:attribute>
	</xsl:if>
	<xsl:if test="@columns">
		<xsl:attribute name="cols"><xsl:value-of select="@columns" /></xsl:attribute>
	</xsl:if>
	<xsl:if test="@on_click_script">
		<xsl:attribute name="onclick"><xsl:value-of select="@on_click_script" /> (this);</xsl:attribute>
	</xsl:if>
</xsl:template>

<xsl:template name="goa_common:class">
	
	<!-- Add class attribute to an element -->
	
	<xsl:if test="@class">
		<xsl:attribute name="class"><xsl:value-of select="@class" /></xsl:attribute>
	</xsl:if>
</xsl:template>

<xsl:template match="goa_common:paragraph">

	<!-- Template for a paragraph element -->
	
	<xsl:element name="p">
		<xsl:call-template name="goa_common:class" />
		<xsl:apply-templates />
	</xsl:element>
</xsl:template>
	
<xsl:template match="goa_common:text_item">

	<!-- Template for text items -->

	<xsl:choose>
		<xsl:when test="@class">
			<xsl:element name="div">
				<xsl:call-template name="goa_common:class" />
				<xsl:text/><xsl:value-of select="." /><xsl:text/>
			</xsl:element>
		</xsl:when>
		<xsl:when test="@span">
			<xsl:element name="span">
				<xsl:attribute name="class"><xsl:value-of select="@span" /></xsl:attribute>
				<xsl:text/><xsl:value-of select="." /><xsl:text/>
			</xsl:element>
		</xsl:when>
		<xsl:otherwise>
			<xsl:text/><xsl:value-of select="." /><xsl:text/>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>
	
<xsl:template match="goa_common:hyperlink">

  <!-- Template for a hyperlink -->
  
  <xsl:element name="a">
    <xsl:call-template name="goa_common:class" />
    <xsl:apply-templates select="goa_common:tool_tip" mode="attributes"/>
    <xsl:attribute name="href"><xsl:value-of select="@url" /></xsl:attribute>
    <xsl:value-of select="text ()" />
  </xsl:element>
</xsl:template>

<xsl:template match="goa_common:image">

 	  	<!--  "Image" template -->
	  	
	<xsl:element name="img" >
		<xsl:call-template name="goa_common:class" />
		<xsl:attribute name="src"><xsl:value-of select="@url" /></xsl:attribute>
		<xsl:attribute name="height"><xsl:value-of select="@height" /></xsl:attribute>
		<xsl:attribute name="width"><xsl:value-of select="@width" /></xsl:attribute>
		<xsl:attribute name="alt"><xsl:value-of select="@alternate_text" /></xsl:attribute>
	</xsl:element>
</xsl:template>

<xsl:template name="goa_common_scripts">

	<xsl:if test="key ('popup_hyperlink', 'A')">
	
		<!-- Script that opens new window for popup hyperlinks -->
	
		<xsl:element name="script">
			<xsl:attribute name="LANGUAGE">JavaScript</xsl:attribute>
			<xsl:attribute name="TYPE">text/javascript</xsl:attribute>
			<!-- Modified from initial script by:  Nic Wolfe (Nic@TimelapseProductions.com) -->
			<!-- Web URL:  http://fineline.xs.mw -->
			<!-- This script and many more are available free online at -->
			<!-- The JavaScript Source!! http://javascript.internet.com -->
			function popUp(URL) {
						page1 = window.open(URL, "my_window", "toolbar=0,scrollbars=1,location=0,statusbar=0,menubar=0,resizable=1,top=50,left=400,width=350,height=450");
						page1.focus() ;
					}
		</xsl:element>
	</xsl:if>

	<xsl:if test="boolean (key ('tool_tip', 'A'))">

	  <!-- Scripts that display/hide tool tips -->

		<xsl:element name="script">
			<xsl:attribute name="LANGUAGE">JavaScript</xsl:attribute>
			<xsl:attribute name="TYPE">text/javascript</xsl:attribute>

var xOffset = 5;
var yOffset = -5;

function showToolTipPopup (objectId, ToolTipId, eventObj) {
  // Show the ToolTip associated with ToolTipId
  // Above the element given by objectId; below if it won't fit above

  // stop event from bubbling up any farther
  eventObj.cancelBubble = true;

  // Get some
  var baseObject = document.getElementById (objectId) ;
  var toolTipObject = getStyleObject (ToolTipId) ;
  var Positions = cumulativeOffset (baseObject) ;
  var leftPosition = (eventObj.pageX)?eventObj.pageX + xOffset:eventObj.x + xOffset + ((document.body.scrollLeft)?document.body.scrollLeft:0);
  var theScreenSize = windowSize () ;
  var windowWidth = theScreenSize [0] ;
  var windowHeight = theScreenSize [1] ;
  var windowScroll = getScrollXY() ;

  // Width is 25% of window or 250 pixels; whichever is greater

  toolTipWidth = Math.round (windowWidth / 4) ;
  if (toolTipWidth &lt; 250) {
    toolTipWidth = 250 ;
  }
  if (toolTipWidth &gt; windowWidth) {

    toolTipWidth = windowWidth - 5 ;

  }

  toolTipObject.width = toolTipWidth + "px"

  // Bottom Position is 5 pixels above the object containing the tool tip

  bottomPosition = Positions [1] - objHeight (ToolTipId) - 5 ;

  // If tool tip won't fit above object, make it wider
  // Until it is 5 pixels less then the window width

  maxToolTipWidth = windowWidth - 5
  toolTipIncrement = Math.round (windowWidth / 5) ;

  while ((bottomPosition &lt; windowScroll [1] + 1) &amp;&amp; (toolTipWidth &lt; maxToolTipWidth)) {
     if (toolTipWidth &gt; maxToolTipWidth) {
        toolTipWidth = maxToolTipWidth ;
     } ;
     toolTipWidth = toolTipWidth + toolTipIncrement ;
     toolTipObject.width = toolTipWidth + "px";
     bottomPosition = Positions [1] - objHeight (ToolTipId) - 5 ;
  };

  // If tool tip still won't fit above the object
  // resize it and display it below the object

  if (bottomPosition &lt; windowScroll [1] + 3) {
    toolTipWidth = Math.round (windowWidth / 4) ;
    if (toolTipWidth &lt; 250) {
      toolTipWidth = 250 ;
    }
    toolTipObject.width = toolTipWidth + "px";
    bottomPosition = Positions [1] + objHeight (objectId) + 5 ;
    leftPosition = leftPosition + 10 ;
  }
  if (leftPosition + toolTipWidth &gt; windowWidth) {
    leftPosition = windowWidth - toolTipWidth - 5 ;
  }

  // Move and display the tool tip

  moveObject (ToolTipId, leftPosition, bottomPosition) ;
  changeObjectVisibility (ToolTipId, 'visible') ;

}

function hideToolTip (ToolTipId) {

  changeObjectVisibility (ToolTipId, 'hidden') ;
  var theScreenSize = windowSize () ;
  moveObject (ToolTipId, 0, theScreenSize [1]) ;


}

function getScrollXY() {
	// Get Scroll Offset of current window and return as an array of
	// [Scroll X, Scroll Y]
  var scrOfX = 0, scrOfY = 0;
  if( typeof( window.pageYOffset ) == 'number' ) {
    //Netscape compliant
    scrOfY = window.pageYOffset;
    scrOfX = window.pageXOffset;
  } else if( document.body &amp;&amp; ( document.body.scrollLeft || document.body.scrollTop ) ) {
    //DOM compliant
    scrOfY = document.body.scrollTop;
    scrOfX = document.body.scrollLeft;
  } else if( document.documentElement &amp;&amp;
      ( document.documentElement.scrollLeft || document.documentElement.scrollTop ) ) {
    //IE6 standards compliant mode
    scrOfY = document.documentElement.scrollTop;
    scrOfX = document.documentElement.scrollLeft;
  }
  return [ scrOfX, scrOfY ];
}


		</xsl:element>
	</xsl:if>

</xsl:template>

<xsl:template match="goa_common:popup_hyperlink">

	<!-- A hyperlink that opens a small pop-up window -->

	<xsl:element name="a">
	        <xsl:apply-templates select="goa_common:tool_tip" />
		<xsl:call-template name="goa_common:class" />
		<xsl:attribute name="href">javascript:popUp('<xsl:value-of select="@url" />')</xsl:attribute>
		<xsl:value-of select="." />
	</xsl:element>
</xsl:template>

<xsl:template match="goa_common:tool_tip" mode="attributes">
  <!-- Add attributes to create a tool tip for an element; the element must support onmouseover and onmouseout javascript -->
  <!-- May be called by any template for an element that may contain a tool tip element -->
  <!-- Must be called while element may still accept attributes -->

   <xsl:attribute name="onmouseover">showToolTipPopup ('<xsl:value-of select="generate-id(..)" />', '<xsl:value-of select="generate-id()" />', event);</xsl:attribute>
   <xsl:attribute name="onmouseout">hideToolTip ('<xsl:value-of select="generate-id ()" />');</xsl:attribute>
   <xsl:attribute name="id"><xsl:value-of select="generate-id(..)" /></xsl:attribute>

</xsl:template>

<xsl:template match="goa_common:tool_tip">
  <!-- A small popup that displays some text to the user via Javascript -->

  <xsl:element name="div">
    <xsl:attribute name="style">position: absolute ; visibility: hidden</xsl:attribute>
    <xsl:attribute name="class"><xsl:value-of select="@class" /></xsl:attribute>
    <xsl:attribute name="id"><xsl:value-of select="generate-id ()" /></xsl:attribute>
    <xsl:value-of select="." />
  </xsl:element>
</xsl:template>

</xsl:transform>
