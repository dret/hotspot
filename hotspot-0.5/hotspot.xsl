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
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns="http://www.w3.org/1999/xhtml" xmlns:html="http://www.w3.org/1999/xhtml" xmlns:hotspot="http://dret.net/xmlns/hotspot/1" xmlns:kilauea="http://xmlns.sharpeleven.net/kilauea" xpath-default-namespace="http://dret.net/xmlns/hotspot/1" exclude-result-prefixes="xs hotspot html kilauea">
	<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
	<!-- this is the output method for hotspot presentations. -->
	<xsl:output name="slides" method="xhtml" encoding="UTF-8" doctype-public="-//W3C//DTD XHTML 1.0 Transitional//EN" doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd" omit-xml-declaration="yes" indent="no" exclude-result-prefixes="xs hotspot html kilauea"/>
	<xsl:output name="slides-indent" method="xhtml" encoding="UTF-8" doctype-public="-//W3C//DTD XHTML 1.0 Transitional//EN" doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd" omit-xml-declaration="yes" indent="yes" exclude-result-prefixes="xs hotspot html kilauea"/>
	<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
	<!-- this is the output method for toc files. -->
	<xsl:output name="toc" encoding="US-ASCII" method="xhtml" indent="no" omit-xml-declaration="yes" exclude-result-prefixes="xs hotspot html kilauea"/>
	<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
	<!-- this is the output method for XML dump files -->
	<xsl:output name="dump" method="xml" encoding="UTF-8" indent="yes" exclude-result-prefixes="xs hotspot html kilauea"/>
	<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
	<xsl:strip-space elements="hotspot presentation part slide layout class list"/>
	<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
	<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
	<!-- this parameter allows to generate only a specified set (comma-separated ids) of presentations rather than the complete set. -->
	<xsl:param name="presentation" select="'*'"/>
	<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
	<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
	<!-- this parameter allows to process the input XML only in a specified set of modes (comma-separated mode names). Note that (unlike for presentations) there is neither a default 'full' set nor a shorthand denoting such a set (e.g., '*'). Porcessing modes must always be specified explicitely. The default processing mode is 'default' (what a surprise). -->
	<xsl:param name="mode" select="'default'"/>
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
			<outline title="Outline" hidden-title="yes" count-text=" (* Slides)" count-depth="2"/>
			<outlink mark="all" style="→ *"/>
			<link author="" glossary="" home="" contents=""/>
			<misc title-separator=" ; " generate-IDs="yes"/>
			<notes show="no" embed="yes"/>
			<!-- the following settings can be specified only once, on the hotspot:hotspot level -->
			<extension file="html" link="html"/>
			<target mode="" directory="."/>
			<paths kilauea="kilauea" layout="layout" img="." listing="."/>
		</configuration>
	</xsl:variable>
	<!--. . . . . . . . . . . . . . . . . . . . . . . . . . . -->
	<!-- . . . . . . . . . . . . . . . . . . . . . . . . . . .-->
	<!--. . . . . . . . . . . . . . . . . . . . . . . . . . . -->
	<!-- process the path variables                           -->
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
	<!-- '''''''''''''''''''''''''''''''''''''''''''''''''''' -->
	<!-- the hotspot-level configuration                      -->
	<!-- .................................................... -->
	<!-- first, the configurations from the layout override   -->
	<!-- the built-in default configurations.                 -->
	<!-- N.B.:                                                -->
	<!-- although it would be no problem to take both steps   -->
	<!-- at the same time, we store this $basic-configuration -->
	<!-- separately, because all mode-specific configurations -->
	<!-- will refine this one, rather than the $configuration -->
	<!-- . . . . . . . . . . . . . . . . . . . . . . . . . . .-->
	<!--. . . . . . . . . . . . . . . . . . . . . . . . . . . -->
	<xsl:variable name="basic-configuration" as="element(hotspot:configuration)">
		<xsl:call-template name="merge-configurations">
			<xsl:with-param name="existing" select="$default-configuration"/>
			<xsl:with-param name="refining" select="$layout/configuration"/>
		</xsl:call-template>
	</xsl:variable>
	<!-- . . . . . . . . . . . . . . . . . . . . . . . . . . .-->
	<!--. . . . . . . . . . . . . . . . . . . . . . . . . . . -->
	<!-- then, the explicit hotspot-level configurations      -->
	<!-- which are found in the input XML document override   -->
	<!-- the above $layout-configuration. the configurations  -->
	<!-- may be further refined for each hotspot:presentation -->
	<!-- (in the first step, just by applying the templates:  -->
	<!-- <xsl:apply-templates select="." mode="merge"/>       -->
	<!-- . . . . . . . . . . . . . . . . . . . . . . . . . . .-->
	<!--. . . . . . . . . . . . . . . . . . . . . . . . . . . -->
	<xsl:variable name="configuration" as="element(hotspot:configuration)">
		<xsl:call-template name="merge-configurations">
			<xsl:with-param name="existing" select="$basic-configuration"/>
			<xsl:with-param name="refining" select="hotspot/configuration[empty(@mode)]"/>
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
				<xsl:apply-templates select="hotspot/presentation[exists(slide | part | @include | @external)]" mode="preprocess">
					<xsl:with-param name="layout" select="$layout" tunnel="yes"/>
					<xsl:with-param name="configuration" select="$configuration" tunnel="yes"/>
				</xsl:apply-templates>
				<xsl:sequence select="$layout"></xsl:sequence>
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
		<!-- a presentation is processed only if it has at least one slide or part (the first step has already taken care of this), is not external, if all presentations are selected, or if it appears in the list of presentations to be generated. -->
		<xsl:apply-templates select="$preprocessed/presentation[empty(@external)][$presentation = '*' or @id = tokenize($presentation, '\s*,\s*')]">
			<xsl:with-param name="shortcut-stack" as="element(hotspot:shortcuts)+" tunnel="yes">
				<hotspot:shortcuts level="hotspot">
					<xsl:copy-of select="hotspot/*[local-name() = $shortcuts]"/>
				</hotspot:shortcuts>
			</xsl:with-param>
		</xsl:apply-templates>
		
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
				<hotspot:outline/>
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
	<!-- second step templates (@mode="#default")             -->
	<!-- .................................................... -->
	<!-- . . . . . . . . . . . . . . . . . . . . . . . . . . .-->
	<!--. . . . . . . . . . . . . . . . . . . . . . . . . . . -->
	<!-- by default, copy everything through: elements... -->
	<xsl:template match="node()">
		<xsl:copy copy-namespaces="no">
			<xsl:apply-templates select="node() | @*"/>
		</xsl:copy>
	</xsl:template>
	<!-- ...as well as attributes... -->
	<xsl:template match="@*">
		<xsl:copy/>
	</xsl:template>
	<!-- ...except for configuration stuff,... -->
	<!-- (it would be much nicer and cleaner to do a namespace-based filtering here, but our user-friendly xmlns-sloppiness makes this impossible, because almost everthing can be in the hotspot xmlns.) -->
	<xsl:template match="configuration"></xsl:template>
	<!-- ...and except for elements that reside in the hotspot xmlns due to our naemspace sloppiness only. -->
	<xsl:template match="hotspot:*">
		<!-- move every element which is not handled otherwise from the hotspot namespace to the xhtml namespace. before doing that, check wether the element is an indexing element and has to be mapped to an xhtml span. -->
		<xsl:choose>
			<xsl:when test="local-name() = $index-elements">
				<!-- if the element is listed as an indexing element, it is mapped to a span with the @class set as specified. -->
				<span class="{key('categoryKey', local-name(), root())/@class}">
					<xsl:apply-templates select="node()"/>
				</span>
			</xsl:when>
			<xsl:otherwise>
				<!-- otherwise, the element is simply copied through, assuming that it is an xhtml element. -->
				<xsl:element name="{local-name()}" namespace="http://www.w3.org/1999/xhtml">
					<xsl:apply-templates select="@* | node()"/>
				</xsl:element>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!-- . . . . . . . . . . . . . . . . . . . . . . . . . . .-->
	<!--. . . . . . . . . . . . . . . . . . . . . . . . . . . -->
	<!-- '''''''''''''''''''''''''''''''''''''''''''''''''''' -->
	<!-- the presentation template                            -->
	<!-- .................................................... -->
	<xsl:template match="presentation">
		<!-- calculate the number of slides -->
		<xsl:variable name="total-slides" select="count(.//*[local-name() = $slidish])"/>
		<xsl:variable name="content-slides" select="count(.//slide)"/>
		<xsl:call-template name="message">
			<xsl:with-param name="text" select="concat(hotspot:presentationfilename(.), ' (', $content-slides, '+', $total-slides - $content-slides, '=', $total-slides, ' slides)')"/>
		</xsl:call-template>
		<!-- output one result document for each presentation -->
		<xsl:result-document format="slides{ if ($params/@indent eq 'yes') then '-indent' else '' }" href="{hotspot:presentationfilename(.)}">
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
			<html>
				<xsl:call-template name="head">
					<xsl:with-param name="layout" select="$layout" tunnel="yes"/>
					<xsl:with-param name="configuration" select="$configuration" tunnel="yes"/>
					<xsl:with-param name="shortcut-stack" as="element(hotspot:shortcuts)+" tunnel="yes">
						<xsl:call-template name="push-shortcuts"/>
					</xsl:with-param>
				</xsl:call-template>
				<xsl:call-template name="body">
					<xsl:with-param name="layout" select="$layout" tunnel="yes"/>
					<xsl:with-param name="configuration" select="$configuration" tunnel="yes"/>
					<xsl:with-param name="shortcut-stack" as="element(hotspot:shortcuts)+" tunnel="yes">
						<xsl:call-template name="push-shortcuts"/>
					</xsl:with-param>
				</xsl:call-template>
			</html>
		</xsl:result-document>
	</xsl:template>
	<!-- . . . . . . . . . . . . . . . . . . . . . . . . . . .-->
	<!--. . . . . . . . . . . . . . . . . . . . . . . . . . . -->
	<!-- '''''''''''''''''''''''''''''''''''''''''''''''''''' -->
	<!-- the HTML head                                        -->
	<!-- .................................................... -->
	<xsl:template name="head" as="element(html:head)">
		<xsl:param name="layout" as="element(hotspot:layout)" tunnel="yes"/>
		<xsl:param name="configuration" as="element(hotspot:configuration)" tunnel="yes"/>
		<head>
			<!-- '''''''''''''''''''''''' -->
			<!-- the page title           -->
			<!-- ........................ -->
			<title>
				<xsl:value-of select="hotspot:title(., 'title', 'long', 'string')"/>
				<xsl:if test="string-length(hotspot:title(., 'author', 'long', 'string')) > 0">
					<xsl:value-of select="$configuration/misc/@title-separator"/>
					<xsl:value-of select="hotspot:title(., 'author', 'long', 'string')"/>
				</xsl:if>
				<xsl:if test="string-length(hotspot:title(., 'affiliation', 'long', 'string')) > 0">
					<xsl:value-of select="$configuration/misc/@title-separator"/>
					<xsl:value-of select="hotspot:title(., 'affiliation', 'long', 'string')"/>
				</xsl:if>
			</title>
			<!-- if a copyright notice is set explicitly, it will be used for the copyright notice instead of the default (date/author). -->
			<meta name="copyright" content="Copyright &#169; { if ( hotspot:title(., 'copyright', 'long', 'string') ne '' ) then hotspot:title(., 'copyright', 'long', 'string') else concat(hotspot:title(., 'date', 'long', 'string'), ' ', hotspot:title(., 'author', 'long', 'string'))}"/>
			<!-- '''''''''''''''''''''''' -->
			<!-- stylesheets              -->
			<!-- ........................ -->
			<!-- include the basic kilauea CSS styles which are functionally essential -->
			<link rel="stylesheet" type="text/css" media="screen, projection, print" href="{ $kilauea-path }css/kilauea.css"/>
			<!-- include all CSS stylesheet documents which are required by the layout -->
			<xsl:for-each select="$layout/css">
				<link rel="stylesheet" type="text/css" media="{ if (@media) then @media else 'screen, projection'}" href="{ @document }"/>
			</xsl:for-each>
			
			<!-- '''''''''''''''''''''''' -->
			<!-- link elements            -->
			<!-- ........................ -->
			<xsl:apply-templates select="$configuration/link">
				<xsl:with-param name="context" select="."/>
			</xsl:apply-templates>
			
			<!-- '''''''''''''''''''''''' -->
			<!-- javascript               -->
			<!-- ........................ -->
			<!-- include the kilauea javascript -->
			<script type="text/javascript" src="{$kilauea-path}/js/kilauea.js"/>
<!--						<script type="text/javascript" src="{$kilauea-path}/js/kilauea.packed.js"/>-->
			<!-- generate the js code that is needed to initialize Kilauea -->
			<xsl:call-template name="kilauea-init"/>
			<!-- '''''''''''''''''''''''' -->
			<!-- inlined CSS / JS parts   -->
			<!-- ........................ -->
			<!-- style and script elements are copied from the hotspot element and the current presentation element. -->
			<xsl:apply-templates select="*[local-name() = ('style', 'script')] | css | parent::hotspot/*[local-name() = ('style', 'script')]"/>
		</head>
	</xsl:template>
	
	<xsl:template match="style[@src] | css[@src]">
		<!-- style elements referring to external stylesheets must be mapped to xhtml <link rel="stylesheet" href="" .../>. -->
		<link rel="stylesheet" href="{@src}">
			<xsl:apply-templates select="@*[local-name() ne 'src']"/>
		</link>
	</xsl:template>
	
	<!-- . . . . . . . . . . . . . . . . . . . . . . . . . . .-->
	<!--. . . . . . . . . . . . . . . . . . . . . . . . . . . -->
	<!-- '''''''''''''''''''''''''''''''''''''''''''''''''''' -->
	<!-- the HTML body                                        -->
	<!-- .................................................... -->
	<xsl:template name="body" as="element(html:body)">
		<xsl:param name="layout" as="element(hotspot:layout)" tunnel="yes"/>
		<body>
			<!-- process the backbrounds,... -->
			<xsl:apply-templates select="$layout/class"/>
			<xsl:if test="count($layout/cover) ne 1">
				<xsl:call-template name="message">
					<xsl:with-param name="level" select="'warning'"/>
					<xsl:with-param name="text" select="concat(if (exists($layout/cover)) then 'More than one' else 'No', ' cover slide defined.')"/>
				</xsl:call-template>
			</xsl:if>
			<!-- ...the cover, and... -->
			<xsl:apply-templates select="$layout/cover"/>
			<!-- ...the content slides. -->
			<xsl:apply-templates select="slide | outline | part"/>
		</body>
	</xsl:template>
	<!-- . . . . . . . . . . . . . . . . . . . . . . . . . . .-->
	<!--. . . . . . . . . . . . . . . . . . . . . . . . . . . -->
	<!-- '''''''''''''''''''''''''''''''''''''''''''''''''''' -->
	<!-- background slides                                    -->
	<!-- .................................................... -->
	<xsl:template match="hotspot:class">
		<div class="background{ if ( exists(@id) ) then concat(' ', @id) else '' }">
			<xsl:apply-templates/>
		</div>
	</xsl:template>
	<!-- . . . . . . . . . . . . . . . . . . . . . . . . . . .-->
	<!--. . . . . . . . . . . . . . . . . . . . . . . . . . . -->
	<!-- '''''''''''''''''''''''''''''''''''''''''''''''''''' -->
	<!-- cover slide                                          -->
	<!-- .................................................... -->
	<xsl:template match="hotspot:cover">
		<div class="slide cover{ if (exists(@class)) then concat(' ', @class) else '' }">
			<xsl:apply-templates/>
		</div>
	</xsl:template>
	<!-- . . . . . . . . . . . . . . . . . . . . . . . . . . .-->
	<!--. . . . . . . . . . . . . . . . . . . . . . . . . . . -->
	<!-- '''''''''''''''''''''''''''''''''''''''''''''''''''' -->
	<!-- the slide template                                   -->
	<!-- .................................................... -->
	<!-- map slides to an enclosing div containing everything which is contained in the slide element. -->
	<xsl:template match="slide">
		<xsl:param name="layout" as="element(hotspot:layout)" tunnel="yes"/>
		<xsl:param name="configuration" as="element(hotspot:configuration)" tunnel="yes"/>
		<!-- consistency checking -->
		<xsl:if test="exists(@class)">
			<!-- the following loop iterates over all xs:tokens found in @class (the regex is the xs:token definition from the schema for schemas) and issues warnings if they refer to undefined classes. -->
			<xsl:analyze-string select="@class" regex="(\i\c*)">
				<xsl:matching-substring>
					<xsl:if test="empty($layout/class[@id eq regex-group(1)])">
						<xsl:call-template name="message">
							<xsl:with-param name="text" select="concat('Found slide with undefined class=&quot;', regex-group(1), '&quot; (but there may be a CSS class)')"/>
							<xsl:with-param name="level" select="'warning'"/>
						</xsl:call-template>
					</xsl:if>
				</xsl:matching-substring>
			</xsl:analyze-string>
		</xsl:if>
		<!-- the @class information is simply copied through. -->
		<div class="slide{ if ( exists(@class) ) then concat(' ', normalize-space(@class)) else ''}">
			<xsl:if test="exists(@id) or $configuration/misc/@generate-IDs = 'yes'">
				<xsl:attribute name="id" select="if (exists(@id)) then @id else @generated-id"/>
			</xsl:if>
			<xsl:apply-templates/>
		</div>
	</xsl:template>
	<!-- . . . . . . . . . . . . . . . . . . . . . . . . . . .-->
	<!--. . . . . . . . . . . . . . . . . . . . . . . . . . . -->
	<!-- '''''''''''''''''''''''''''''''''''''''''''''''''''' -->
	<!-- the part template                                    -->
	<!-- .................................................... -->
	<xsl:template match="part">
		<xsl:param name="configuration" as="element(hotspot:configuration)" tunnel="yes"/>
		<!-- generate part wrapping divs for kilauea -->
		<div class="part">
			<xsl:if test="exists(@id) or $configuration/misc/@generate-IDs = 'yes'">
				<xsl:attribute name="id" select="if (exists(@id)) then @id else @generated-id"/>
			</xsl:if>
			<h1 class="partTitle">
				<xsl:value-of select="hotspot:title(., 'title', 'long', 'nodes')"/>
			</h1>
			<xsl:apply-templates select="slide | outline | part">
				<xsl:with-param name="shortcut-stack" as="element(hotspot:shortcuts)+" tunnel="yes">
					<xsl:call-template name="push-shortcuts"/>
				</xsl:with-param>
			</xsl:apply-templates>
		</div>
	</xsl:template>
	<!-- . . . . . . . . . . . . . . . . . . . . . . . . . . .-->
	<!--. . . . . . . . . . . . . . . . . . . . . . . . . . . -->
	<!-- '''''''''''''''''''''''''''''''''''''''''''''''''''' -->
	<!-- the outline template                                 -->
	<!-- .................................................... -->
	<xsl:template match="outline">
		<xsl:param name="configuration" as="element(hotspot:configuration)" tunnel="yes"/>
		<xsl:param name="shortcut-stack" as="element(hotspot:shortcuts)+" tunnel="yes"/>
		
		<div class="slide outline">
			<xsl:if test="$configuration/misc/@generate-IDs = 'yes'">
				<xsl:attribute name="id" select="generate-id()"/>
			</xsl:if>
			<h1>
				<xsl:value-of select="$configuration/outline/@title"/>
				<xsl:if test="$configuration/outline/@hidden-title eq 'yes'">
					<!-- this text is invisible on the slide, but visible in the contents window of kilauea. -->
					<span style="display : none">
						<xsl:value-of select="concat(' (', hotspot:expand-shortcut('title', 'part', $shortcut-stack, 'long', 'string'),')')"/>
					</span>
				</xsl:if>
			</h1>
			<ol class="outline">
				<xsl:apply-templates select="ancestor::presentation[1]/part" mode="outline">
					<xsl:with-param name="current" select="." tunnel="yes"/>
					<xsl:with-param name="depth" select="1"/>
				</xsl:apply-templates>
			</ol>
		</div>
	</xsl:template>
	<!-- . . . . . . . . . . . . . . . . . . . . . . . . . . .-->
	<!--. . . . . . . . . . . . . . . . . . . . . . . . . . . -->
	<!-- '''''''''''''''''''''''''''''''''''''''''''''''''''' -->
	<!-- listing parts within outline slides                  -->
	<!-- .................................................... -->
	<xsl:template match="part" mode="outline">
		<xsl:param name="configuration" as="element(hotspot:configuration)" tunnel="yes"/>
		<xsl:param name="shortcut-stack" as="element(hotspot:shortcuts)+" tunnel="yes"/>
		<xsl:param name="current" tunnel="yes"/>
		<xsl:param name="depth" as="xs:decimal"/>
		
		<li>
			<xsl:if test=". is $current">
				<xsl:attribute name="class" select="'expand outline-current'"/>
			</xsl:if>
			<xsl:if test="some $i in descendant::* satisfies $i is $current">
				<xsl:attribute name="class" select="'expand'"/>
			</xsl:if>
			<xsl:choose>
				<xsl:when test=". is $current">
					<xsl:apply-templates select="hotspot:expand-shortcut('title', 'part', $shortcut-stack, 'long', 'nodes')/node()"/>
				</xsl:when>
				<xsl:otherwise>
					<a href="{hotspot:id(.)}" title="go to part &quot;{hotspot:expand-shortcut('title', 'part', $shortcut-stack, 'long', 'string')}&quot;">
						<xsl:apply-templates select="hotspot:expand-shortcut('title', 'part', $shortcut-stack, 'long', 'nodes')/node()"/>
					</a>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:if test="$configuration/outline/@count-depth eq 'all' or $depth le $configuration/outline/@count-depth cast as xs:decimal">
				<xsl:value-of select="concat(substring-before($configuration/outline/@count-text, '*'), count(descendant::slide), substring-after($configuration/outline/@count-text, '*'))"/>
			</xsl:if>
			<xsl:if test="exists(part)">
				<ol class="outline">
					<xsl:apply-templates select="part" mode="outline">
						<xsl:with-param name="depth" select="$depth + 1"/>
						<xsl:with-param name="shortcut-stack" as="element(hotspot:shortcuts)+" tunnel="yes">
							<xsl:call-template name="push-shortcuts"/>
						</xsl:with-param>
					</xsl:apply-templates>
				</ol>
			</xsl:if>
		</li>
	</xsl:template>
	<!-- . . . . . . . . . . . . . . . . . . . . . . . . . . .-->
	<!--. . . . . . . . . . . . . . . . . . . . . . . . . . . -->
	<!-- '''''''''''''''''''''''''''''''''''''''''''''''''''' -->
	<!-- non-empty title elements within slides               -->
	<!-- .................................................... -->
	<!-- non-empty slide/title elements are mapped to html h1 elements (which are then selected by kilauea css magic). -->
	<xsl:template match="slide/title[exists(node())]">
		<h1>
			<xsl:apply-templates select="@*[not(local-name() = ('short'))] | node()"/>
		</h1>
	</xsl:template>
	<!-- . . . . . . . . . . . . . . . . . . . . . . . . . . .-->
	<!--. . . . . . . . . . . . . . . . . . . . . . . . . . . -->
	<!-- '''''''''''''''''''''''''''''''''''''''''''''''''''' -->
	<!-- link elements (e.g., for use wit cmSiteNavigation)   -->
	<!-- .................................................... -->
	<xsl:template match="hotspot:configuration/hotspot:link">
		<xsl:param name="context" as="element(hotspot:presentation)"/>
		<xsl:if test="@author ne ''">
			<!-- if the user configured a link to a "author" document, include a link to it. -->
			<link rel="author" href="{@author}"/>
		</xsl:if>
		<xsl:if test="@contents ne ''">
			<!-- if the user configured a link to a "contents" document, include a link to it. -->
			<link rel="contents" href="{@contents}" title="{hotspot:title(/hotspot, 'title', 'short', 'string')}"/>
		</xsl:if>
		<xsl:if test="@glossary ne ''">
			<!-- if the user configured a link to a "glossary" document, include a link to it. -->
			<link rel="glossary" href="{@glossary}"/>
		</xsl:if>
		<xsl:if test="@home ne ''">
			<!-- if the user configured a link to a "home" document, include a link to it. -->
			<link rel="home" href="{@home}" title="{hotspot:title(/hotspot, 'title', 'short', 'string')}"/>
		</xsl:if>
		<xsl:variable name="next" select="$context/following-sibling::presentation[1]"/>
		<!-- if there is a "next" presentation, include a link to it. -->
		<xsl:if test="exists($next)">
			<link rel="next" href="{ if ( exists($next/@external) ) then $next/@external else hotspot:presentationlinkname($next) }" title="{hotspot:title($next, 'title', 'short', 'string')}"/>
		</xsl:if>
		<xsl:variable name="last" select="$context/following-sibling::presentation[last()]"/>
		<!-- if there is a "last" presentation, include a link to it. -->
		<xsl:if test="exists($last)">
			<link rel="last" href="{ if ( exists($last/@external) ) then $last/@external else hotspot:presentationlinkname($last) }" title="{hotspot:title($last, 'title', 'short', 'string')}"/>
		</xsl:if>
		<xsl:variable name="prev" select="$context/preceding-sibling::presentation[1]"/>
		<!-- if there is a "previous" presentation, include a link to it. -->
		<xsl:if test="exists($prev)">
			<link rel="prev" href="{ if ( exists($prev/@external) ) then $prev/@external else hotspot:presentationlinkname($prev) }" title="{hotspot:title($prev, 'title', 'short', 'string')}"/>
		</xsl:if>
		<xsl:variable name="first" select="$context/preceding-sibling::presentation[last()]"/>
		<!-- if there is a "first" presentation, include a link to it. -->
		<xsl:if test="exists($first)">
			<link rel="start" href="{ if ( exists($first/@external) ) then $first/@external else hotspot:presentationlinkname($first) }" title="{hotspot:title($first, 'title', 'short', 'string')}"/>
			<!-- officially, this is called "start", but opera does not recognize "start" and instead needs this to be called "first". -->
			<link rel="first" href="{ if ( exists($first/@external) ) then $first/@external else hotspot:presentationlinkname($first) }" title="{hotspot:title($first, 'title', 'short', 'string')}"/>
		</xsl:if>
	</xsl:template>
	<!-- . . . . . . . . . . . . . . . . . . . . . . . . . . .-->
	<!--. . . . . . . . . . . . . . . . . . . . . . . . . . . -->
	<!-- '''''''''''''''''''''''''''''''''''''''''''''''''''' -->
	<!-- Hotspot elements within slides                       -->
	<!-- (e.g., title and author elements)                    -->
	<!-- .................................................... -->
	<!-- the title group elements are expanded when found within a slide and empty (apart from attributes as defined by the schema). -->
	<xsl:template match="slide//*[local-name() = ('title', 'author', 'affiliation', 'date', 'copyright', 'location', 'occasion')][count(@* | node()) eq count(@level | @form)]">
		<xsl:param name="context" select="." tunnel="yes"/>
		<!-- set the @level parameter to the default value if not supplied. -->
		<xsl:variable name="level-value" select="if ( exists(@level) ) then string(@level) else 'slide'"/>
		<!-- for layout slides (which are invoked from the $layout variable, thus not from the input document), force $level to be either 'hotspot' or 'presentation' (default). the if () part would have been better using the "is" node comparison, but saxon seems to have a problem with that. -->
		<xsl:variable name="level" select="if ( (/) is $stdin ) then $level-value else if ( $level-value eq 'hotspot' ) then 'hotspot' else 'presentation'"/>
		<xsl:variable name="content" select="hotspot:title($context/ancestor-or-self::*[local-name() eq $level][1], local-name(), if ( @form eq 'short' ) then 'short' else 'long', 'nodes' )"/>
		<!-- if a text-based form has been asked for, generate a string, otherwise copy the nodes of the result. -->
		<xsl:choose>
			<xsl:when test="@form = ('text' , 'short')">
				<xsl:value-of select="$content"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates select="$content/node()"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!-- . . . . . . . . . . . . . . . . . . . . . . . . . . .-->
	<!--. . . . . . . . . . . . . . . . . . . . . . . . . . . -->
	<!-- '''''''''''''''''''''''''''''''''''''''''''''''''''' -->
	<!-- Hotspot elements within the cover slide              -->
	<!-- .................................................... -->
	<xsl:template match="cover//*[local-name() = $shortcuts][count(@* | node()) eq count(@level | @form)]">
		<xsl:param name="position" tunnel="yes" select="'last'"/>
		<xsl:param name="shortcut-stack" as="element(hotspot:shortcuts)+" tunnel="yes"/>
		<xsl:param name="form"/>
		<!-- for cover slides, the level must be either 'hotspot' or 'presentation', with the latter being the default level -->
		<xsl:variable name="level" select="if ( @level eq 'hotspot' ) then 'hotspot' else 'presentation'"/>
		<xsl:variable name="content" select="hotspot:expand-shortcut(local-name(), $level, $shortcut-stack, @form, if (($form, @form) = ('text', 'short')) then 'string' else 'nodes', $position)"/>
		<!-- if a text-based form has been asked for, generate a string, otherwise copy the nodes of the result. -->
		<xsl:choose>
			<xsl:when test="$content instance of xs:string">
				<xsl:value-of select="$content"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates select="$content/node()"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!-- . . . . . . . . . . . . . . . . . . . . . . . . . . .-->
	<!--. . . . . . . . . . . . . . . . . . . . . . . . . . . -->
	<!-- '''''''''''''''''''''''''''''''''''''''''''''''''''' -->
	<!-- iterate over multiple authors              -->
	<!-- .......................................... -->
	<xsl:template match="cover//for-each-author">
		<xsl:param name="shortcut-stack" as="element(hotspot:shortcuts)+" tunnel="yes"/>
		<xsl:param name="context" select="." tunnel="yes"/>
		<!-- for cover slides, the level must be either 'hotspot' or 'presentation', with the latter being the default level -->
		<xsl:variable name="level" select="if ( .//author/@level eq 'hotspot' ) then 'hotspot' else 'presentation'"/>
		<!-- collect all authors (the author information will be fetched a second time while applying the tempaltes below. therefore, we can fetch the info in just any form, e.g., as short string) -->
		<xsl:variable name="authors" select="hotspot:expand-shortcut('author', $level, $shortcut-stack, 'short', 'string', 'all')"/>
		<!-- stor the current context, as "current()" wont work within the for-loop below -->
		<xsl:variable name="current" select="."/>
		<!-- process the content of hotspot:for-each-author for each author -->
		<xsl:for-each select="(1 to count($authors))">
			<xsl:apply-templates select="$current/node()">
				<xsl:with-param name="position" select="." tunnel="yes"/>
			</xsl:apply-templates>
		</xsl:for-each>
	</xsl:template>
	<!-- . . . . . . . . . . . . . . . . . . . . . . . . . . .-->
	<!--. . . . . . . . . . . . . . . . . . . . . . . . . . . -->
	<!-- '''''''''''''''''''''''''''''''''''''''''''''''''''' -->
	<!-- microformats! turn authors into hcards               -->
	<!-- .................................................... -->
	<xsl:template match="author/node()">
		<span class="vcard">
			<xsl:choose>
				<xsl:when test="self::text()">
					<span class="fn">
						<xsl:value-of select="."/>
					</span>
				</xsl:when>
				<xsl:when test="local-name() eq 'a'">
					<a>
						<xsl:attribute name="class" select="string-join((if (position() eq 1) then 'fn' else '', if (starts-with(@href, 'mailto:')) then 'email' else 'url', @class), ' ')"/>
						<xsl:copy-of select="@*[local-name() ne 'class']"/>
						<xsl:apply-templates select="node()"/>
					</a>
				</xsl:when>
				<xsl:otherwise>
					<span class="fn">
						<xsl:apply-templates select="node()"/>
					</span>
				</xsl:otherwise>
			</xsl:choose>
<!--			<xsl:variable name="affiliation" select="$context/following-sibling::hotspot:affiliation[1]" as="element(hotspot:affiliation)?"/>-->
			<xsl:variable name="affiliation" select="parent::hotspot:author/following-sibling::hotspot:affiliation[1]" as="element(hotspot:affiliation)?"/>
<!--			<xsl:variable name="affiliation" select="()"/>-->
			<xsl:if test="exists($affiliation)">
				<span class="org" style="display: none">
					<xsl:apply-templates select="$affiliation/node">
						<xsl:with-param name="form">text</xsl:with-param>
					</xsl:apply-templates>
				</span>
			</xsl:if>
		</span>
	</xsl:template>
	<!-- . . . . . . . . . . . . . . . . . . . . . . . . . . .-->
	<!--. . . . . . . . . . . . . . . . . . . . . . . . . . . -->
	<!-- '''''''''''''''''''''''''''''''''''''''''''''''''''' -->
	<!-- microformats! turn affiliations into hcards          -->
	<!-- .................................................... -->
	<xsl:template match="affiliation/node()">
		<span class="vcard">
			<xsl:choose>
				<xsl:when test="local-name() eq 'a'">
					<a>
						<xsl:attribute name="class" select="string-join((if (position() eq 1) then 'fn org' else '', if (starts-with(@href, 'mailto:')) then 'email' else 'url', @class), ' ')"/>
						<xsl:copy-of select="@*[local-name() ne 'class']"/>
						<xsl:apply-templates select="node()"/>
					</a>
				</xsl:when>
				<xsl:otherwise>
					<span class="fn org">
						<xsl:apply-templates select="node()"/>
					</span>
				</xsl:otherwise>
			</xsl:choose>
		</span>
	</xsl:template>
	<!-- . . . . . . . . . . . . . . . . . . . . . . . . . . .-->
	<!--. . . . . . . . . . . . . . . . . . . . . . . . . . . -->
	<!-- '''''''''''''''''''''''''''''''''''''''''''''''''''' -->
	<!-- presentation notes                                   -->
	<!-- .................................................... -->
	<!-- note elements are mapped to a div (unless $notes has been set to 'remove' them), the note's contents are processed as usual. -->
	<xsl:template match="slide//note">
		<xsl:param name="configuration" as="element(hotspot:configuration)" tunnel="yes"/>
		<xsl:choose>
			<xsl:when test="$configuration/notes/@embed = 'yes'">
				<!-- this is the class that must be picked up in the javascript and css code for properly handling notes. -->
				<div class="note">
					<xsl:apply-templates select="node()"/>
				</div>
			</xsl:when>
			<xsl:otherwise>
				<!-- everything other than 'include' is treated as if 'remove' had been specified. -->
				<xsl:comment> an hotspot note has been removed here </xsl:comment>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	
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
	<xsl:template match="configuration" mode="merge">
		<xsl:param name="configuration" as="element(hotspot:configuration)?" tunnel="yes"/>
		<xsl:call-template name="merge-configurations">
			<xsl:with-param name="existing" select="$configuration"/>
			<xsl:with-param name="refining" select=".[@mode eq $configuration/@mode]"/>
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
					<xsl:when test="not($import-docname = (document-uri(/), $visited))">
						<xsl:apply-templates select="hotspot:fetch-layout-doc(import/@layout)/layout">
							<xsl:with-param name="visited">
								<!-- push the document URI to the list of visited documents in order to avoid loops -->
								<xsl:sequence select="($visited, document-uri(/), $import-docname)"/>
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
<!--			<xsl:apply-templates select="configuration[empty(@mode)]">-->
<!--				<xsl:with-param name="configuration" select="$imports/configuration" tunnel="yes"/>-->
<!--			</xsl:apply-templates>-->
			<xsl:call-template name="merge-configurations">
				<xsl:with-param name="existing" select="$imports/configuration"/>
				<xsl:with-param name="refining" select="configuration[empty(@mode)]"/>
			</xsl:call-template>
			<!-- process backgrounds and cover slides (adjustes all image paths, where necessary)... -->
			<xsl:apply-templates select="class | cover" mode="layout"/>
			<!-- ...but only accept each background / cover exactly once -->
			<xsl:copy-of select="$imports/class[not(some $i in current()/class satisfies string($i/@id) eq string(@id))] | $imports/cover[empty(current()/cover)]"/>
			<!-- CSS documents can safely be include more than once; but the inclusion order matters, as it reflects the importance/precedence of the 'cascading' styles -->
			<xsl:copy-of select="$imports/css"/>
			<xsl:apply-templates select="css" mode="layout"/>
		</xsl:element>
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
	<!-- shorcuts-stack-pushing template                      -->
	<!-- .................................................... -->
	<xsl:template name="push-shortcuts" as="element(hotspot:shortcuts)+">
		<xsl:param name="shortcut-stack" as="element(hotspot:shortcuts)*" tunnel="yes"/>
		<!-- return all shortcuts which we collected so far,... -->
		<xsl:sequence select="$shortcut-stack"/>
		<!-- ...create a new hotspot:shortcuts element,... -->
		<hotspot:shortcuts>
			<!-- ...indicate the current level,... -->
			<xsl:attribute name="level" select="local-name()"/>
			<!-- ...and push the current local shortcuts,... -->
			<xsl:copy-of select="*[local-name() = $shortcuts]"/>
			<!-- ...completed by the inherited shortcuts. -->
			<xsl:copy-of select="$shortcut-stack[last()]/*[not(local-name() = (current()/*/local-name()))]"/>
		</hotspot:shortcuts>
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
	
	<!-- returns the name of the presentation based on the context and the position. -->
	<xsl:function name="hotspot:presentationlinkname">
		<xsl:param name="context"/>
		<xsl:variable name="presentation" select="$context/ancestor-or-self::presentation[1]"/>
		<!-- if no @external attribute is present for the presentation, the linkname is computed; otherwise it is the value of the @external attribute. -->
<!--		<xsl:value-of select="if ( empty($presentation/@external) ) then concat(hotspot:presentationname($presentation), if ( hotspot:param('extension-link') eq '' or starts-with(hotspot:param('extension-link'), '.') ) then '' else '.', hotspot:param('extension-link')) else $presentation/@external"/>-->
		<!-- todo: append extension/@link -->
		<xsl:value-of select="if ( empty($presentation/@external) ) then hotspot:presentationname($presentation) else $presentation/@external"/>
	</xsl:function>
	<!-- . . . . . . . . . . . . . . . . . . . . . . . . . . .-->
	<!--. . . . . . . . . . . . . . . . . . . . . . . . . . . -->
	<!-- '''''''''''''''''''''''''''''''''''''''''''''''''''' -->
	<!-- expand the shortcuts (in a given context)            -->
	<!-- .................................................... -->
	<xsl:function name="hotspot:expand-shortcut">
		<xsl:param name="name" as="xs:string"/>
		<!-- level: either 'hotspot', 'presentation', 'part', or 'slide' -->
		<xsl:param name="level" as="xs:string"/>
		<!-- data: the stack of current shortcut data -->
		<xsl:param name="data" as="element(hotspot:shortcuts)+"/>
		<!-- this is only a polymorphic alias, so to speak -->
		<xsl:sequence select="hotspot:expand-shortcut($name, $level, $data, 'long', 'nodes', 'last')"/>
	</xsl:function>
	<xsl:function name="hotspot:expand-shortcut">
		<xsl:param name="name" as="xs:string"/>
		<!-- level: either 'hotspot', 'presentation', 'part', or 'slide' -->
		<xsl:param name="level" as="xs:string"/>
		<!-- data: the stack of current shortcut data -->
		<xsl:param name="data" as="element(hotspot:shortcuts)+"/>
		<!-- form: either 'short' or 'long' (an attribute can also be passed, or even an empty sequence, which is interpreted as 'long') -->
		<xsl:param name="form"/>
		<!-- this is only a polymorphic alias, so to speak -->
		<xsl:sequence select="hotspot:expand-shortcut($name, $level, $data, $form, 'nodes', 'last')"/>
	</xsl:function>
	<xsl:function name="hotspot:expand-shortcut">
		<xsl:param name="name" as="xs:string"/>
		<!-- level: either 'hotspot', 'presentation', 'part', or 'slide' -->
		<xsl:param name="level" as="xs:string"/>
		<!-- data: the stack of current shortcut data -->
		<xsl:param name="data" as="element(hotspot:shortcuts)+"/>
		<!-- form: either 'short' or 'long' (an attribute can also be passed, or even an empty sequence, which is interpreted as 'long') -->
		<xsl:param name="form"/>
		<!-- value: either 'nodes' or 'string' -->
		<xsl:param name="value" as="xs:string"/>
		<!-- this is only a polymorphic alias, so to speak -->
		<xsl:sequence select="hotspot:expand-shortcut($name, $level, $data, $form, $value, 'last')"/>
	</xsl:function>
	<xsl:function name="hotspot:expand-shortcut">
		<xsl:param name="name" as="xs:string"/>
		<!-- level: either 'hotspot', 'presentation', 'part', or 'slide' -->
		<xsl:param name="level" as="xs:string"/>
		<!-- data: the stack of current shortcut data -->
		<xsl:param name="data" as="element(hotspot:shortcuts)+"/>
		<!-- form: either 'short' or 'long' (an attribute can also be passed, or even an empty sequence, which is interpreted as 'long') -->
		<xsl:param name="form"/>
		<!-- value: either 'nodes' or 'string' -->
		<xsl:param name="value" as="xs:string"/>
		<!-- position:  -->
		<xsl:param name="position"/>
		
<!--		<xsl:message select="$name"/>-->
<!--		<xsl:message select="$data"></xsl:message>-->
		
		<xsl:variable name="content" as="element()*">
			<xsl:sequence select="$data[@level eq $level][last()]/*[local-name() eq $name][if ($position castable as xs:decimal) then $position else if ($position eq 'all') then true() else last()]"/>
		</xsl:variable>
		<xsl:for-each select="$content">
			<xsl:sequence select="if ( ($form eq 'short') and exists(@short) ) then string(@short) else if ( $value eq 'nodes' ) then . else normalize-space(string-join(descendant-or-self::text(), ''))"/>
		</xsl:for-each>
		
		
	</xsl:function>
	
	<!-- return the most recent value of one of the titleGroup elements from the hotspot schema. return the short value if asked for and present, otherwise return the element's content. if $value is set to 'string', return the string value, otherwise (set to 'nodes') return the sequence of nodes found in the titleGroup. -->
	<xsl:function name="hotspot:title">
		<xsl:param name="context"/>
		<xsl:param name="name"/>
		<xsl:param name="form"/>
		<xsl:param name="value"/>
		
		<xsl:sequence select="hotspot:title($context, $name, $form, $value, 'last')"/>
	</xsl:function>
	<xsl:function name="hotspot:title">
		<xsl:param name="context"/>
		<xsl:param name="name"/>
		<xsl:param name="form"/>
		<xsl:param name="value"/>
		<xsl:param name="position"/>
		<xsl:variable name="title" as="element()*">
			<xsl:choose>
				<xsl:when test="$position castable as xs:decimal">
					<xsl:sequence select="$context/ancestor-or-self::*[*[local-name() eq $name]][last()]/*[local-name() eq $name][$position]"/>
				</xsl:when>
				<xsl:when test="$position eq 'all'">
					<xsl:sequence select="$context/ancestor-or-self::*[*[local-name() eq $name]][last()]/*[local-name() eq $name]"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:sequence select="($context/ancestor-or-self::*/*[local-name() eq $name])[last()]"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:for-each select="$title">
			<xsl:copy-of select="if ( ($form eq 'short') and exists(@short) ) then string(@short) else if ( $value eq 'nodes' ) then . else normalize-space(string-join(descendant-or-self::text(), ''))"/>
		</xsl:for-each>
	</xsl:function>
	
	
	<!-- . . . . . . . . . . . . . . . . . . . . . . . . . . .-->
	<!--. . . . . . . . . . . . . . . . . . . . . . . . . . . -->
	<!-- '''''''''''''''''''''''''''''''''''''''''''''''''''' -->
	<!-- get a slide's (or part's) anchor name / ID           -->
	<!-- .................................................... -->
	<xsl:function name="hotspot:id" as="xs:string">
		<xsl:param name="target" as="element()"/>
		<xsl:choose>
			<xsl:when test="exists($target/@id)">
				<xsl:value-of select="concat('#', string($target/@id))"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="concat('#(', count($target/preceding::*[local-name() = $slidish][ancestor::presentation[1] is $target/ancestor::presentation[1]]) + 1, ')')"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:function>
	<!-- . . . . . . . . . . . . . . . . . . . . . . . . . . .-->
	<!--. . . . . . . . . . . . . . . . . . . . . . . . . . . -->
	<!-- '''''''''''''''''''''''''''''''''''''''''''''''''''' -->
	<!-- kilauea JS-specific templates and utilities          -->
	<!-- .................................................... -->
	<xsl:template name="kilauea-init">
		<xsl:param name="layout" as="element(hotspot:layout)" tunnel="yes"/>
		<xsl:param name="configuration" as="element(hotspot:configuration)" tunnel="yes"/>
		
		<xsl:variable name="plugin-names" as="xs:string*">
			<xsl:sequence select="distinct-values($configuration/kilauea:kilauea/kilauea:plugins/*/local-name())"/>
		</xsl:variable>
		<script type="text/javascript">
			<xsl:text>Kilauea.init({'#body': {titleSeparator: </xsl:text>
			<xsl:value-of select="kilauea:param($configuration/misc/@title-separator)"/>
			<xsl:text>, settings: {</xsl:text>
			<!-- todo: maybe we should respect configuration/notes/@show -->
			<xsl:for-each select="$configuration/kilauea:kilauea/kilauea:settings/@*">
				<xsl:value-of select="concat(local-name(), ': ', kilauea:param(.))"/>
				<xsl:if test="position() ne last()">
					<xsl:text>, </xsl:text>
				</xsl:if>
			</xsl:for-each>
			<xsl:text>}, plugins: {</xsl:text>
			<xsl:for-each select="$plugin-names">
				<xsl:value-of select="concat(., ': ', '{')"/>
				<xsl:for-each select="$configuration/kilauea:kilauea/kilauea:plugins/*[local-name() eq current()][1]/@*">
					<xsl:value-of select="concat(local-name(), ': ', kilauea:param(.))"/>
					<xsl:if test="position() ne last()">
						<xsl:text>, </xsl:text>
					</xsl:if>
				</xsl:for-each>
				<xsl:text>}</xsl:text>
				<xsl:if test="position() ne last()">
					<xsl:text>, </xsl:text>
				</xsl:if>
			</xsl:for-each>
			<xsl:text>}}})</xsl:text>
		</script>
	</xsl:template>
	
	
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