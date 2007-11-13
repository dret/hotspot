<?xml version="1.0" encoding="UTF-8"?>
<!-- $Id$ -->
<!-- . . . . . . . . . . . . . . . . . . . . . . . . . . .-->
<!--. . . * . . . . . . . . . . . . . . . . . . . . . . . -->
<!-- . . . . . . . . . . . . . . . . . . . . . . . . . . .-->
<!--. . . . . . . . . * . . . . . . . . . . . . . . . . . -->
<!-- . . . . . . . . . . . . . . . . . . . . . . * . . . .-->
<!--. . . . . . . . . . . . . . . * . . . . . . . . . . . -->
<!-- . . . . . . . . . . . . . . . . . . * . . . . . . . .-->
<!--. . . . . . * . . . . . . . . . . . . . . . . . . . . -->
<!-- . . . . . . . . . . . . . . . . . . . . . . . . . . .-->
<!--. . . . . . . . . . . . . . . . . . . . . . . . * . . -->
<!-- . . . . . . . . . . . . . . . . . . . . . . . . . . .-->
<!--. * . . . . . . . . . . . * . . . . . . . . . . . . . -->
<!-- . . . . . . . . . . . . . . . . . . . * . . . . . . .-->
<!--. . . . . . . * . . . . . . . . . . . . . . . . . . . -->
<!-- . * . . . . . . . . . . . . . . . . . . . . . . . . *-->
<!--. . * . . . . . . . . . . . . . . . . . . * * * . . * -->
<!-- . * * . . . . . . * * * . . . . . . * * * * * . * * *-->
<!--* . * * . * * . * * * * * * . . . * * * * * * . * * * -->
<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
<!-- Hotspot - Erik Wilde (http://dret.net/netdret/) - http://dret.net/projects/hotspot/ -->
<!-- Hotspot is licensed under the GNU Lesser General Public License (LGPL). See http://creativecommons.org/licenses/LGPL/2.1/ for licensing details. -->
<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns="http://www.w3.org/1999/xhtml" xmlns:html="http://www.w3.org/1999/xhtml" xmlns:hotspot="http://dret.net/xmlns/hotspot/1" xmlns:kilauea="http://xmlns.sharpeleven.net/kilauea" xpath-default-namespace="http://dret.net/xmlns/hotspot/1" exclude-result-prefixes="xs hotspot html">
	<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
	<!-- this is the output method for hotspot presentations. -->
	<xsl:output name="slides" method="xhtml" encoding="UTF-8" doctype-public="-//W3C//DTD XHTML 1.0 Transitional//EN" doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd" omit-xml-declaration="yes" indent="no" exclude-result-prefixes="xs hotspot html"/>
	<xsl:output name="slides-indent" method="xhtml" encoding="UTF-8" doctype-public="-//W3C//DTD XHTML 1.0 Transitional//EN" doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd" omit-xml-declaration="yes" indent="yes" exclude-result-prefixes="xs hotspot html"/>
	<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
	<!-- this is the output method for toc files. -->
	<xsl:output name="toc" encoding="US-ASCII" method="xhtml" indent="no" omit-xml-declaration="yes" exclude-result-prefixes="xs hotspot html"/>
	<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
	<!-- this is the output method for XML dump files -->
	<xsl:output name="dump" method="xml" encoding="UTF-8" indent="yes" exclude-result-prefixes="xs hotspot html"/>
	<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
	<xsl:strip-space elements="hotspot presentation part slide layout class list"/>
	<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
	<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
	<!-- this parameter allows to generate only a specified set (comma-separated ids) of presentations rather than the complete set. -->
	<xsl:param name="presentation" select="'*'"/>
	<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
	<!-- controls whether 'warning' messages should be output as well (default is that 'warning' messages are output). -->
	<xsl:param name="messages" select="'error'"/>
	<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
	<!-- controls whether slide notes should be included or removed. -->
	<xsl:param name="notes" select="'include'"/>
	<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
	<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
	<xsl:variable name="stdin" select="/"/>
	<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
	<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
	<xsl:variable name="base-uri" select="base-uri(/)" as="xs:anyURI"/>
	<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
	<!-- these variables are used for indicating the current hotspot version in the generated output files. -->
	<xsl:variable name="version" select="'0.5'"/>
	<xsl:variable name="svnid" select="'$Id$'"/>
	<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
	<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
	<xsl:variable name="index-elements" select="/hotspot/index/category/@element"/>
	<xsl:key name="categoryKey" match="hotspot/index/category" use="@element"/>
	<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
	<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
	<xsl:key name="structureIdKey" match="presentation | part | slide" use="@id"/>
	<xsl:key name="counterKey" match="counter" use="@id"/>
	
	
	<!-- . . . . . . . . . . . . . . . . . . . . . . . . . . .-->
	<!--. . . . . . . . . . . . . . . . . . . . . . . . . . . -->
	<xsl:variable name="includables" select="('presentation', 'part', 'slide')" as="xs:string+"/>
	<!-- . . . . . . . . . . . . . . . . . . . . . . . . . . .-->
	<!--. . . . . . . . . . . . . . . . . . . . . . . . . . . -->
	<xsl:variable name="configurables" select="('hotspot', 'presentation')" as="xs:string+"/>
	<!-- . . . . . . . . . . . . . . . . . . . . . . . . . . .-->
	<!--. . . . . . . . . . . . . . . . . . . . . . . . . . . -->
	<xsl:variable name="shortcuts" select="('title', 'author', 'affiliation', 'date', 'copyright', 'location', 'occasion')" as="xs:string+"/>
	<!-- . . . . . . . . . . . . . . . . . . . . . . . . . . .-->
	<!--. . . . . . . . . . . . . . . . . . . . . . . . . . . -->
	<xsl:variable name="slidish" select="('slide', 'cover', 'outline')" as="xs:string+"/>
	<!-- . . . . . . . . . . . . . . . . . . . . . . . . . . .-->
	<!--. . . . . . . . . . . . . . . . . . . . . . . . . . . -->
	
	
	<!-- . . . . . . . . . . . . . . . . . . . . . . . . . . .-->
	<!--. . . . . . . . . . . . . . . . . . . . . . . . . . . -->
	<!-- the following variables are for defining parameter defaults and their inclusion from "hotspot" processing instructions in the input document. please note that hotspot does not allow parameters to be passed as real xslt parameters. -->
	<xsl:variable name="params" as="element(hotspot:params)">
		<xsl:element name="hotspot:params">
			<!-- the default parameter values -->
			<xsl:attribute name="layout-path" select="'layout'"/>
			<xsl:attribute name="kilauea-path" select="'kilauea'"/>
			<xsl:attribute name="indent" select="'no'"/>
			<xsl:attribute name="layout" select="'zurich'"/>
			<!-- the input parameter values -->
			<xsl:for-each select="/processing-instruction('hotspot')">
				<!-- the following xpaths are not really readable, but xml/xpath's escape mechanisms make this necessary... -->
				<xsl:if test="matches(., concat('^\i\c*\s*=\s*(&quot;|', &quot;'&quot;, ').*\1\s*$'))">
					<xsl:attribute name="{replace(., concat('(\i\c*)\s*=\s*(&quot;|', &quot;'&quot;, ').*\2\s*$'), '$1')}" select="replace(., concat('\i\c*\s*=\s*(&quot;|', &quot;'&quot;, ')(.*)\1\s*$'), '$2')"/>
				</xsl:if>
			</xsl:for-each>
		</xsl:element>
	</xsl:variable>
	<!-- . . . . . . . . . . . . . . . . . . . . . . . . . . .-->
	<!--. . . . . . . . . . . . . . . . . . . . . . . . . . . -->
	<xsl:variable name="default-configuration" as="element(hotspot:configuration)" xmlns="http://dret.net/xmlns/hotspot/1">
		<configuration>
			<counter separator=": " format="full"/>
			<listing class="listing"/>
			<outline title="Outline" hidden-tite="'yes'"/>
			<outlink mark="all" style="→ *"/>
			<part-slide text=" (* Slides)" count="1"/>
			<link author="" glossary="" home="" contents=""/>
			<misc title-separator=" ; " generate-IDs="yes"/>
			<!-- the following settings can be specified only once, on the hotspot:hotspot level -->
			<extension file="html" link="html"/>
			<target mode="" directory="."/>
			<paths kilauea="kilauea" layout="layout" img="." listing="."/>
		</configuration>
	</xsl:variable>
	
	<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
	<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
	<!-- some of the parameters should better be pre-processed to deal with variations in user-defined values. the pre-processed values are available through variables. -->
	<!--  -->
	<!-- process the path variables -->
	<xsl:variable name="layout-path" select="concat( if ( $params/@layout-path eq '' ) then 'layout' else $params/@layout-path, if ( not(ends-with($params/@layout-path, '/')) ) then '/' else '' )"/>
	<xsl:variable name="kilauea-path" select="concat( if ( $params/@kilauea-path eq '' ) then 'kilauea' else $params/@kilauea-path, if ( not(ends-with($params/@kilauea-path, '/')) ) then '/' else '' )"/>
	<!--. . . . . . . . . . . . . . . . . . . . . . . . . . . -->
	<!-- . . . . . . . . . . . . . . . . . . . . . . . . . . .-->
	<!--. . . . . . . . . . . . . . . . . . . . . . . . . . . -->
	<!-- the hotspot-level layout                             -->
	<xsl:variable name="layout" as="element(hotspot:layout)">
		<xsl:apply-templates select="hotspot:fetch-layout-doc($params/@layout)/layout">
			<xsl:with-param name="current-layout" tunnel="yes" select="$params/@layout"/>
		</xsl:apply-templates>
	</xsl:variable>
	<!--. . . . . . . . . . . . . . . . . . . . . . . . . . . -->
	<!-- . . . . . . . . . . . . . . . . . . . . . . . . . . .-->
	<!--. . . . . . . . . . . . . . . . . . . . . . . . . . . -->
	<!-- the hotspot-level configuration                      -->
	<!-- first, the configurations from the layout override   -->
	<!-- the built-in default configurations.                 -->
	<!--                                                      -->
	<!-- then, the explicit hotspot-level configurations      -->
	<!-- which are found in the input XML document override   -->
	<!-- the above $layout-configuration. the configurations  -->
	<!-- may be further refined for each hotspot:presentation -->
	<!-- (in the first step, just by applying the templates:  -->
	<!-- <xsl:apply-templates select="configuration"/>        -->
	<!-- . . . . . . . . . . . . . . . . . . . . . . . . . . .-->
	<!--. . . . . . . . . . . . . . . . . . . . . . . . . . . -->
	<xsl:variable name="configuration" as="element(hotspot:configuration)">
		<xsl:call-template name="merge-configurations">
			<xsl:with-param name="existing" as="element(hotspot:configuration)">
				<xsl:call-template name="merge-configurations">
					<xsl:with-param name="existing" select="$default-configuration"/>
					<xsl:with-param name="refining" select="$layout/configuration"/>
				</xsl:call-template>
			</xsl:with-param>
			<xsl:with-param name="refining" select="hotspot/configuration"/>
		</xsl:call-template>
	</xsl:variable>
	<!-- . . . . . . . . . . . . . . . . . . . . . . . . . . .-->
	<!--. . . . . . . . . . . . . . . . . . . . . . . . . . . -->
	<!-- . . . . . . . . . . . . . . . . . . . . . . . . . . .-->
	<!--. . . . . . . . . . . . . . . . . . . . . . . . . . . -->
	<!-- . . . . . . . . . . . . . . . . . . . . . . . . . . .-->
	<!--. . . . . . . . . . . . . . . . . . . . . . . . . . . -->
	<!-- '''''''''''''''''''''''''''''''''''''''''''''''''''' -->
	<!-- the main template                                    -->
	<!-- .................................................... -->
	<!-- . . . . . . . . . . . . . . . . . . . . . . . . . . .-->
	<!--. . . . . . . . . . . . . . . . . . . . . . . . . . . -->
	<xsl:template match="/">
		<!-- first, let's be polite and talkative a little while -->
		<xsl:if test="exists(hotspot/@version) and ( $version ne hotspot/@version)">
			<xsl:call-template name="message">
				<xsl:with-param name="text" select="('&#xA;Transforming an', hotspot/@version, 'document with Hotspot', $version, 'may cause unexpected behavior...')"/>
				<xsl:with-param name="level" select="'warning'"/>
			</xsl:call-template>
		</xsl:if>
		<xsl:call-template name="message">
			<xsl:with-param name="text" select="('&#xA;Running Hotspot', $version, 'with the following options:')"/>
			<xsl:with-param name="level" select="'warning'"/>
		</xsl:call-template>
		<xsl:for-each select="$params/@*">
			<xsl:sort select="local-name()"/>
			<xsl:call-template name="message">
				<xsl:with-param name="text" select="concat('  ', local-name(), ' = &quot;', ., '&quot;')"/>
				<xsl:with-param name="level" select="'warning'"/>
			</xsl:call-template>
		</xsl:for-each>
		<xsl:call-template name="message">
			<xsl:with-param name="text" select="concat('The path settings are:&#xA;  layout-path = ', $layout-path, '&#xA;  kilauea-path = ', $kilauea-path)"/>
			<xsl:with-param name="level" select="'warning'"/>
		</xsl:call-template>
		<xsl:call-template name="message">
			<xsl:with-param name="text" select="''"/>
			<xsl:with-param name="level" select="'warning'"/>
		</xsl:call-template>
		<!-- . . . . . . . . . . . . . . . . . . . . . . . . . . .-->
		<!--. . . . . . . . . . . . . . . . . . . . . . . . . . . -->
		<!-- . . . . . . . . . . . . . . . . . . . . . . . . . . .-->
		<!--. . . . . . . . . . . . . . . . . . . . . . . . . . . -->
		<!-- . . . . . . . . . . . . . . . . . . . . . . . . . . .-->
		
		
		<!-- **************** -->
		<!-- *** STEP ONE *** -->
		<!-- **************** -->
		
		<xsl:variable name="preprocessed" as="element(hotspot:hotspot)">
			<hotspot:hotspot>
				<xsl:apply-templates select="hotspot/presentation" mode="preprocess">
					<xsl:with-param name="layout" select="$layout" tunnel="yes"/>
					<xsl:with-param name="configuration" select="$configuration" tunnel="yes"/>
				</xsl:apply-templates>
			</hotspot:hotspot>
		</xsl:variable>
		
		
		<!-- **************** -->
		<!-- *** STEP TWO *** -->
		<!-- **************** -->
		
		<xsl:result-document format="dump" href="dump.xml">
			<xsl:sequence select="$preprocessed"/>
		</xsl:result-document>
		
		
		<!-- '''''''''''''''''''''''''''''''''''' -->
		<!-- iterate over all non-empty           --> 
		<!-- and non-external presentations       -->
		<!-- .................................... -->
		<!-- a presentation is processed only if it has at least one slide or part, is not external, if all presentations are selected, or if it appears in the list of presentations to be generated. -->
		<xsl:for-each select="$preprocessed/presentation[exists(slide | part)][empty(@external)][$presentation = '*' or @id = tokenize($presentation, '\s*,\s*')]">
			<xsl:variable name="total-slides" select="count(.//*[local-name() = $slidish])"/>
			<xsl:variable name="content-slides" select="count(.//slide)"/>
			<xsl:call-template name="message">
				<xsl:with-param name="text" select="concat(hotspot:presentationfilename(.), ' (', $content-slides, '+', $total-slides - $content-slides, '=', $total-slides, ' slides)')"/>
			</xsl:call-template>
<!--			<xsl:result-document format="slides" href="{hotspot:presentationfilename(.)}">-->
<!--				<xsl:text>&#xA;</xsl:text>-->
<!--				<xsl:comment>-->
<!--					<xsl:text> Do not edit by hand! Generated by Hotspot </xsl:text>-->
<!--					<xsl:value-of select="concat($version, ' (', $svnid, ')')"/>-->
<!--					<xsl:text> on </xsl:text>-->
<!--					<xsl:value-of select="current-dateTime()"/>-->
<!--					<xsl:text> </xsl:text>-->
<!--				</xsl:comment>-->
<!--				<xsl:text>&#xA;</xsl:text>-->
<!--				<xsl:comment> For more information about Hotspot please visit http://dret.net/projects/hotspot/. </xsl:comment>-->
<!--				<html>-->
<!--				-->
<!--				</html>-->
<!--			</xsl:result-document>-->
		</xsl:for-each>
		
		<!-- '''''''''''''''''''''''''''''''''''' -->
		<!-- generate the TOC files               -->
		<!-- .................................... -->
		<!-- iterate over all toc elements and generate a file for each of them. -->
		<xsl:for-each select="/hotspot/toc[exists(@name)]">
			<xsl:call-template name="message">
				<xsl:with-param name="text" select="string(@name)"/>
			</xsl:call-template>
			<xsl:result-document format="toc" href="{@name}">
				<xsl:apply-templates/>
			</xsl:result-document>
		</xsl:for-each>
		
	</xsl:template>
	
	
	<!-- . . . . . . . . . . . . . . . . . . . . . . . . . . .-->
	<!--. . . . . . . . . . . . . . . . . . . . . . . . . . . -->
	<!-- . . . . . . . . . . . . . . . . . . . . . . . . . . .-->
	<!-- '''''''''''''''''''''''''''''''''''''''''''''''''''' -->
	<!-- first step templates (@mode="preprocess")            -->
	<!-- .................................................... -->
	<!--. . . . . . . . . . . . . . . . . . . . . . . . . . . -->
	<!-- . . . . . . . . . . . . . . . . . . . . . . . . . . .-->
	<xsl:template match="presentation" mode="preprocess">
		<xsl:param name="layout" as="element(hotspot:layout)" tunnel="yes"/>
		<!-- do we have to generate an ID? I think, no, because 'structureIdKey' only matters for explicitly named presentations. -->
		<xsl:choose>
			<xsl:when test="exists(@external)">
				<xsl:copy/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:copy>
					<xsl:apply-templates select="@*" mode="preprocess"/>
					<!-- hotspot:title and other $shortcuts may appear interleaved with slides and the cover, but hotspot:cover has to appear before all other slides -->
					<xsl:apply-templates select="configuration"/>
					<xsl:apply-templates select="$layout/cover" mode="preprocess"/>
					<xsl:apply-templates select="node()" mode="preprocess"/>
				</xsl:copy>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!-- . . . . . . . . . . . . . . . . . . . . . . . . . . .-->
	<!--. . . . . . . . . . . . . . . . . . . . . . . . . . . -->
	<xsl:template match="part" mode="preprocess">
		<xsl:copy>
			<!-- let's generate the ID here, in the first processing step, rather than during the second one. the rationale is to allow other stylesheets to obtain the sam generated IDs, given the same input XML document. note that the decision, whether or not the generated @id will be used, is postponed to the second processing step. -->
			<xsl:if test="empty(@id)">
				<xsl:attribute name="generated-id" select="generate-id()"/>
			</xsl:if>
			<xsl:apply-templates select="@*" mode="preprocess"/>
			<xsl:if test="not(@outline eq 'no')">
				<outline/>
			</xsl:if>
			<xsl:apply-templates select="node()" mode="preprocess"/>
		</xsl:copy>
	</xsl:template>
	<!-- . . . . . . . . . . . . . . . . . . . . . . . . . . .-->
	<!--. . . . . . . . . . . . . . . . . . . . . . . . . . . -->
	<xsl:template match="node() | @*" mode="preprocess">
		<xsl:copy>
			<xsl:apply-templates select="node() | @* | text()" mode="preprocess"/>
		</xsl:copy>
	</xsl:template>
	<!-- . . . . . . . . . . . . . . . . . . . . . . . . . . .-->
	<!--. . . . . . . . . . . . . . . . . . . . . . . . . . . -->
	<!-- . . . . . . . . . . . . . . . . . . . . . . . . . . .-->
	<!--. . . . . . . . . . . . . . . . . . . . . . . . . . . -->
	<!-- . . . . . . . . . . . . . . . . . . . . . . . . . . .-->
	<!-- '''''''''''''''''''''''''''''''''''''''''''''''''''' -->
	<!-- inclusion mechanism                                  -->
	<!-- .................................................... -->
	<xsl:template match="*[local-name() = $includables][@include]" mode="preprocess" as="element()?">
		<xsl:param name="visited" as="xs:anyURI*" tunnel="yes"/>
		<xsl:variable name="include" as="element()?">
			<xsl:apply-templates select="@include"/>
		</xsl:variable>
		<xsl:choose>
			<xsl:when test="$include/local-name() eq local-name() and $include/namespace-uri() eq 'http://dret.net/xmlns/hotspot/1' cast as xs:anyURI">
				<xsl:copy>
					<xsl:copy-of select="(. | $include)/@*[not(local-name() = ('id', 'name', 'class'))]"/>
					<!-- copy the @id of the including element, rather than the @id from the included one. -->
					<xsl:copy-of select="@id"/>
					<!-- the applies for the (presentation) @name -->
					<xsl:copy-of select="@name"/>
					<!-- merge the @class attributes (is this a good idea?) -->
					<xsl:apply-templates select="@class">
						<xsl:with-param name="merge-with" select="$include/@class"/>
					</xsl:apply-templates>
					<xsl:apply-templates select="$include/node()" mode="preprocess">
						<xsl:with-param name="visited" select="($visited, resolve-uri(@include, base-uri(root(.))))" tunnel="yes"/>
					</xsl:apply-templates>
				</xsl:copy>
			</xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="message">
					<xsl:with-param name="text" select="'The inclusion URI &quot;', string(@include), '&quot; leads to an element &quot;', name($include), '&quot;, but an element &quot;hotspot:', local-name(), '&quot; was expected.'"/>
				</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!--. . . . . . . . . . . . . . . . . . . . . . . . . . . -->
	<!-- . . . . . . . . . . . . . . . . . . . . . . . . . . .-->
	<xsl:template match="@include" as="element()?">
		<xsl:param name="visited" as="xs:anyURI*" tunnel="yes"/>
		<!-- do we have to resolve with the $base-uri? or using the base-uri(root(.))? -->
		<xsl:variable name="docname" as="xs:anyURI?" select="resolve-uri(tokenize(., '#')[1], base-uri(root(.)))"/>
<!--		<xsl:variable name="docname" as="xs:anyURI?" select="resolve-uri(tokenize(., '#')[1], $base-uri)"/>-->
		<xsl:variable name="fragment" as="xs:string?" select="tokenize(., '#')[2]"/>
		<xsl:choose>
			<xsl:when test="hotspot:illegal-inclusion($visited, $docname, $fragment)">
				<xsl:call-template name="message">
					<xsl:with-param name="text" select="concat('Illegal inclusion which implies a circular reference to &quot;', $docname, '&quot;')"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:variable name="include" as="element()?">
					<xsl:choose>
						<xsl:when test="doc-available($docname)">
							<xsl:choose>
								<xsl:when test="$fragment ne ''">
			<!--						<xsl:sequence select="id($fragment, doc($docname))"/>-->
									<xsl:sequence select="doc($docname)//(presentation | slide | part)[@id eq $fragment]"/>
								</xsl:when>
								<xsl:otherwise>
									<!-- this default behaviour in the absence of a fragment identifier is a design decision. other default strategies are conceivable, e.g., returning all presentations, or throwing an error. -->
									<xsl:sequence select="doc($docname)/hotspot/presentation[1]"/>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:when>
						<xsl:otherwise>
							<xsl:call-template name="message">
								<xsl:with-param name="text" select="concat('Unable to resolve document &quot;', $docname, '&quot;')"/>
							</xsl:call-template>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<xsl:if test="empty($include)">
					<xsl:call-template name="message">
						<xsl:with-param name="text" select="'The inclusion URI &quot;', string(.), '&quot; does not return any elements.'"/>
					</xsl:call-template>
				</xsl:if>
				<xsl:sequence select="$include"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!-- . . . . . . . . . . . . . . . . . . . . . . . . . . .-->
	<!--. . . . . . . . . . . . . . . . . . . . . . . . . . . -->
	<xsl:function name="hotspot:illegal-inclusion" as="xs:boolean">
		<xsl:param name="visited" as="xs:anyURI*"/>
		<xsl:param name="docname" as="xs:anyURI"/>
		<xsl:param name="fragment" as="xs:string?"/>
		<!-- split the visited URIs -->
		<!-- TODO ... may increase run-time complexity consideravly -->
		<!-- for the moment being, we're completely heedless. -->
		<xsl:sequence select="false()"/>
	</xsl:function>
	<!-- . . . . . . . . . . . . . . . . . . . . . . . . . . .-->
	<!--. . . . . . . . . . . . . . . . . . . . . . . . . . . -->
	
	
	
	<!-- . . . . . . . . . . . . . . . . . . . . . . . . . . .-->
	<!--. . . . . . . . . . . . . . . . . . . . . . . . . . . -->
	<!-- . . . . . . . . . . . . . . . . . . . . . . . . . . .-->
	<!-- '''''''''''''''''''''''''''''''''''''''''''''''''''' -->
	<!-- TOC elements                                         -->
	<!-- .................................................... -->
	<!-- . . . . . . . . . . . . . . . . . . . . . . . . . . .-->
	<!--. . . . . . . . . . . . . . . . . . . . . . . . . . . -->
	<!-- for for-each-presentation elements in toc elements, loop over all presentation elements to generate the toc file. -->
	<xsl:template match="toc//for-each-presentation">
		<xsl:variable name="context" select="."/>
		<xsl:for-each select="/hotspot/presentation">
			<xsl:apply-templates select="$context/*">
				<xsl:with-param name="context" select="." tunnel="yes"/>
			</xsl:apply-templates>
		</xsl:for-each>
	</xsl:template>
	<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
	<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
	<!-- for toc elements in toc elements, replace the toc element with the corresponding toc elements content from the presentation. -->
	<xsl:template match="toc//toc">
		<xsl:param name="context" tunnel="yes"/>
		<xsl:apply-templates select="$context/toc[@class eq current()/@class]/node()"/>
	</xsl:template>
	<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
	<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
	<!-- this enables conditional processing in tocs, only generating the if-toc's content if the correspondig toc is present. -->
	<xsl:template match="toc//if-toc">
		<xsl:param name="context" tunnel="yes"/>
		<xsl:choose>
			<xsl:when test="exists($context/toc[@class eq current()/@class])">
				<xsl:apply-templates select="node()"/>
			</xsl:when>
		</xsl:choose>
	</xsl:template>
	<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
	<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
	<!-- for toc elements in presentation content, replace the toc element with the corresponding toc elements content from the presentation. -->
	<xsl:template match="slide//toc | part//toc">
		<xsl:apply-templates select="ancestor::presentation/toc[@class eq current()/@class]/node()"/>
	</xsl:template>
	<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
	<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
	<!-- when appearing in a toc element, the title group elements must be treated in a special way. -->
	<xsl:template match="toc//*[local-name() = ('title', 'author', 'affiliation', 'date', 'copyright', 'location', 'occasion')][count(@* | node()) eq count(@level | @form)]">
		<xsl:param name="context" tunnel="yes"/>
<!--		<xsl:variable name="content" select="hotspot:title($context, local-name(), if ( @form eq 'short' ) then 'short' else 'long', 'nodes' )"/>-->
		<!-- if a text-based form has been asked for, generate a string, otherwise copy the nodes of the result. -->
<!--		<xsl:choose>-->
<!--			<xsl:when test="@form = ('text' , 'short')">-->
<!--				<xsl:value-of select="$content"/>-->
<!--			</xsl:when>-->
<!--			<xsl:otherwise>-->
<!--				<xsl:apply-templates select="$content/node()"/>-->
<!--			</xsl:otherwise>-->
<!--		</xsl:choose>-->
	</xsl:template>
	<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
	<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
	<!-- the slides element generates the number of slides in a presentation within a toc element. -->
	<!-- TODO -->
	<xsl:template match="toc//slides">
		<xsl:param name="context" tunnel="yes"/>
		<!-- get the expanded presentation fom $presentations and count the number of slide divs inside this presentation. -->
<!--		<xsl:variable name="slides" select="count($presentations/presentation[@id eq generate-id($context)]/descendant::html:div[contains(@class, 'slide')])"/>-->
		<!-- only produce a slide count if the presentation is not empty and not external. -->
<!--		<xsl:if test="exists($context/ancestor-or-self::presentation//(slide | part)) and not(exists($context/ancestor-or-self::presentation[@external]))">-->
			<!-- take the element content and replace the first asterisk with the slide count. -->
<!--			<xsl:value-of select="replace(text(), '\*', string($slides))"/>-->
<!--		</xsl:if>-->
	</xsl:template>
	<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
	<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
	
	
	
	
	<!-- '''''''''''''''''''''''''''''''''''''''''''''''''''' -->
	<!-- configuration utilities                              -->
	<!-- .................................................... -->
	<xsl:template match="configuration">
		<xsl:param name="configuration" as="element(hotspot:configuration)?" tunnel="yes"/>
		
		<xsl:call-template name="merge-configurations">
			<xsl:with-param name="existing" select="$configuration"/>
			<xsl:with-param name="refining" select="."/>
		</xsl:call-template>
	</xsl:template>
	<!-- . . . . . . . . . . . . . . . . . . . . . . . . . . .-->
	<!--. . . . . . . . . . . . . . . . . . . . . . . . . . . -->
	<xsl:template name="merge-configurations" as="element(hotspot:configuration)">
		<xsl:param name="existing" as="element(hotspot:configuration)?"/>
		<xsl:param name="refining" as="element(hotspot:configuration)?"/>
		
		<xsl:element name="hotspot:configuration">
			<!-- collect kilauea configurations -->
			<xsl:copy-of select="$refining/kilauea:kilauea"/>
			<xsl:copy-of select="$existing/kilauea:kilauea"/>
			<!-- merge hotspot configuration settings -->
			<xsl:variable name="distinct-elements" select="distinct-values(($existing | $refining)/hotspot:*/local-name())" as="xs:string*"/>
			<xsl:for-each select="$distinct-elements">
				<xsl:element name="hotspot:{.}">
					<xsl:copy-of select="$existing/hotspot:*[local-name() eq current()]/@*"/>
					<xsl:copy-of select="$refining/hotspot:*[local-name() eq current()]/@*"/>
				</xsl:element>
			</xsl:for-each>
		</xsl:element>
	</xsl:template>
	<!-- . . . . . . . . . . . . . . . . . . . . . . . . . . .-->
	<!--. . . . . . . . . . . . . . . . . . . . . . . . . . . -->
	<!-- '''''''''''''''''''''''''''''''''''''''''''''''''''' -->
	<!-- layout utilities                                     -->
	<!-- .................................................... -->
	<xsl:function name="hotspot:resolve-layout-docname" as="xs:anyURI">
		<xsl:param name="layout" as="xs:string"/>
		<xsl:value-of select="resolve-uri(concat($layout-path, $layout, '/layout.xml'), $base-uri)"/>
	</xsl:function>
	<!-- . . . . . . . . . . . . . . . . . . . . . . . . . . .-->
	<!--. . . . . . . . . . . . . . . . . . . . . . . . . . . -->
	<xsl:function name="hotspot:fetch-layout-doc" as="document-node(element(hotspot:layout))?">
		<xsl:param name="layout" as="xs:string"/>
		<!-- -->
		<xsl:variable name="layout-doc" select="hotspot:resolve-layout-docname($layout)"/>
		<xsl:choose>
			<xsl:when test="doc-available($layout-doc)">
				<xsl:sequence select="doc($layout-doc)"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="message">
					<xsl:with-param name="text" select="concat('Could not access layout XML file ', $layout-doc)"/>
					<xsl:with-param name="level" select="'error'"/>
				</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:function>
	<!-- . . . . . . . . . . . . . . . . . . . . . . . . . . .-->
	<!--. . . . . . . . . . . . . . . . . . . . . . . . . . . -->
	<xsl:template match="layout" as="element(hotspot:layout)">
		<xsl:param name="visited" as="xs:anyURI*"/>
		<!-- first, get all imported layouts recursively -->
		<xsl:variable name="imports" as="element(hotspot:layout)?">
			<xsl:if test="exists(import[@layout])">
				<xsl:variable name="import-docname" select="hotspot:resolve-layout-docname(import/@layout)" as="xs:anyURI"/>
				<xsl:choose>
					<!-- avoid loops -->
					<xsl:when test="not($import-docname = ($visited))">
						<xsl:apply-templates select="hotspot:fetch-layout-doc(import/@layout)/layout">
							<xsl:with-param name="visited">
								<!-- push the document URI to the list of visited documents in order to avoid loops -->
								<xsl:sequence select="($visited, $import-docname)"/>
							</xsl:with-param>
							<xsl:with-param name="current-layout" select="import/@layout" tunnel="yes"/>
						</xsl:apply-templates>
					</xsl:when>
					<xsl:otherwise>
						<xsl:call-template name="message">
							<xsl:with-param name="text" select="concat('Detected an illegal circular reference of &quot;', $import-docname, '&quot; in document &quot;', document-uri(/), '&quot;')"/>
							<xsl:with-param name="level" select="'warning'"/>
						</xsl:call-template>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:if>
		</xsl:variable>
		<!-- construct the merged layout -->
		<xsl:element name="hotspot:layout">
			<xsl:apply-templates select="configuration">
				<xsl:with-param name="configuration" select="$imports/configuration" tunnel="yes"/>
			</xsl:apply-templates>
<!--			<xsl:call-template name="merge-configurations">-->
<!--				<xsl:with-param name="existing" select="$imports/configuration"/>-->
<!--				<xsl:with-param name="refining" select="configuration"/>-->
<!--			</xsl:call-template>-->
			<!-- process backgrounds and cover slides (adjustes all image paths, where necessary)... -->
			<xsl:apply-templates select="class | cover"/>
			<!-- ...but only accept each background / cover exactly once -->
			<xsl:copy-of select="$imports/class[not(some $i in current()/class satisfies $i/@id eq @id)] | $imports/cover[empty(current()/cover)]"/>
			<!-- CSS documents can safely be include more than once; but the inclusion order matters, as it reflects the importance/precedence of the 'cascading' styles -->
			<xsl:copy-of select="$imports/css"/>
			<xsl:apply-templates select="css"/>
		</xsl:element>
	</xsl:template>
	<!-- . . . . . . . . . . . . . . . . . . . . . . . . . . .-->
	<!--. . . . . . . . . . . . . . . . . . . . . . . . . . . -->
	<xsl:template match="class | cover | css">
		<xsl:copy>
			<xsl:apply-templates select="@* | node() | text()" mode="layout"/>
		</xsl:copy>
	</xsl:template>
	<!-- . . . . . . . . . . . . . . . . . . . . . . . . . . .-->
	<!--. . . . . . . . . . . . . . . . . . . . . . . . . . . -->
	<xsl:template match="node() | @*" mode="layout">
		<xsl:copy>
			<xsl:apply-templates select="@* | node() | text()" mode="layout"/>
		</xsl:copy>
	</xsl:template>
	<!-- . . . . . . . . . . . . . . . . . . . . . . . . . . .-->
	<!--. . . . . . . . . . . . . . . . . . . . . . . . . . . -->
	<xsl:template match="@src | @data | @document" mode="layout">
		<xsl:param name="current-layout" as="xs:string" tunnel="yes"/>
		<!-- resolve the URIs of images and embedded objects correctly; each path relative to the URI of the respective layout document -->
		<xsl:attribute name="{local-name()}" select="resolve-uri(., concat($layout-path, $current-layout, '/layout.xml'))"/>
	</xsl:template>
	<!-- . . . . . . . . . . . . . . . . . . . . . . . . . . .-->
	<!--. . . . . . . . . . . . . . . . . . . . . . . . . . . -->
	
	
	
	<!-- . . . . . . . . . . . . . . . . . . . . . . . . . . .-->
	<!--. . . . . . . . . . . . . . . . . . . . . . . . . . . -->
	<!-- . . . . . . . . . . . . . . . . . . . . . . . . . . .-->
	<!--. . . . . . . . . . . . . . . . . . . . . . . . . . . -->
	<!-- . . . . . . . . . . . . . . . . . . . . . . . . . . .-->
	<!-- '''''''''''''''''''''''''''''''''''''''''''''''''''' -->
	<!-- utility templates                                    -->
	<!-- .................................................... -->
	<!-- . . . . . . . . . . . . . . . . . . . . . . . . . . .-->
	<!--. . . . . . . . . . . . . . . . . . . . . . . . . . . -->
	<xsl:template match="@class" as="attribute(class)">
		<xsl:param name="merge-with" as="attribute(class)?"/>
		<xsl:variable name="classes" as="xs:string*" select="distinct-values((tokenize(., '\s+'), tokenize($merge-with, '\s+')))"/>
		<xsl:attribute name="class" select="string-join($classes, ' ')"/>
	</xsl:template>
	<!-- . . . . . . . . . . . . . . . . . . . . . . . . . . .-->
	<!--. . . . . . . . . . . . . . . . . . . . . . . . . . . -->
	<!-- '''''''''''''''''''''''''''''''''''''''''''''''''''' -->
	<!-- utility template for informative messages            -->
	<!--                                                      -->
	<!-- messages may have different levels of importance:    -->
	<!-- - 'warning': only output, if $messages is set to     -->
	<!--              'warning' (i.e., via XSLT parameter)    -->
	<!-- - 'error': always output (default)                   -->
	<!-- .................................................... -->
	<xsl:template name="message">
		<xsl:param name="text"/>
		<!-- message level may be 'warning' or 'error' (default). -->
		<xsl:param name="level" select="'error'"/>
		<xsl:if test="not($level eq 'warning' and $messages eq 'error')">
			<xsl:message select="$text"/>
		</xsl:if>
	</xsl:template>
	
	<!-- . . . . . . . . . . . . . . . . . . . . . . . . . . .-->
	<!--. . . . . . . . . . . . . . . . . . . . . . . . . . . -->
	<!-- . . . . . . . . . . . . . . . . . . . . . . . . . . .-->
	<!--. . . . . . . . . . . . . . . . . . . . . . . . . . . -->
	<!-- . . . . . . . . . . . . . . . . . . . . . . . . . . .-->
	<!-- '''''''''''''''''''''''''''''''''''''''''''''''''''' -->
	<!-- utility functions                                    -->
	<!-- .................................................... -->
	<!-- . . . . . . . . . . . . . . . . . . . . . . . . . . .-->
	<!--. . . . . . . . . . . . . . . . . . . . . . . . . . . -->
	<!-- returns the name of the presentation based on the context and the position. if there is a @name, take the @name, if not, take the @id, if there is no @id, generate a name. -->
	<xsl:function name="hotspot:presentationname">
		<xsl:param name="presentation"/>
		<xsl:value-of select="if ( exists($presentation/@name) ) then $presentation/@name else if ( exists($presentation/@id) ) then $presentation/@id else concat('presentation-', count($presentation/preceding::presentation)+1)"/>
	</xsl:function>
	<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
	<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
	<!-- returns the name of the presentation based on the context and the position. -->
	<xsl:function name="hotspot:presentationfilename">
		<xsl:param name="context"/>
		<xsl:value-of select="concat(hotspot:presentationname($context/ancestor-or-self::presentation[1]), if ($configuration/extension/@file eq '' or starts-with($configuration/extension/@file, '.') ) then '' else '.', $configuration/extension/@file)"/>
	</xsl:function>
	
	
	<!-- . . . . . . . . . . . . . . . . . . . . . . . . . . .-->
	<!--. . . . . . . . . . . . . . . . . . . . . . . . . . . -->
	<!-- '''''''''''''''''''''''''''''''''''''''''''''''''''' -->
	<!-- kilauea JS-specific utilities                        -->
	<!-- .................................................... -->
	<xsl:function name="kilauea:param" as="xs:string">
		<xsl:param name="str" as="xs:string"/>
		<!-- this function simply wraps non-boolean values in single quotes, and escapes all single quotes. (kilauea usually requires booleans to be real js booleans, not strings. that's why quoting everythig wouldn't have been an option.) -->
		<xsl:choose>
			<xsl:when test="$str eq 'true' or $str eq 'false'">
				<xsl:value-of select="$str"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="concat(&quot;'&quot;, replace($str, &quot;'&quot;, &quot;\\'&quot;), &quot;'&quot;)"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:function>
	
	
	
</xsl:stylesheet>




<!-- . _   _   _____   _____   ____   __   _  ______. . . . . . . . . . . . . . . . . . .-->
<!--. | | | | /  _  \ |__ __| / ___\    -->
<!--  | |_| | | | | |   | |   \ \       -->
<!--. |  _  | | | | |   | |    \ \       -->
<!--  | | | | | |_| |   | |   __\ \   -->
<!--. |_| |_| \_____/   |_|   \____/     -->
<!--. . . . . . . . . . . . . . . . . . . . . . . . . . . -->
