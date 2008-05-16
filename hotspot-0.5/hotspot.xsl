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
	<!-- . . . . . . . . . . . . . . . . . . . . . . . . . . .-->
	<!--. . . . . . . . . . . . . . . . . . . . . . . . . . . -->
	<!-- this is the output method for hotspot presentations. -->
	<xsl:output name="slides" method="xhtml" encoding="UTF-8" doctype-public="-//W3C//DTD XHTML 1.0 Transitional//EN" doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd" omit-xml-declaration="yes" indent="no" exclude-result-prefixes="xs hotspot html kilauea"/>
	<xsl:output name="slides-indent" method="xhtml" encoding="UTF-8" doctype-public="-//W3C//DTD XHTML 1.0 Transitional//EN" doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd" omit-xml-declaration="yes" indent="yes" exclude-result-prefixes="xs hotspot html kilauea"/>
	<!-- . . . . . . . . . . . . . . . . . . . . . . . . . . .-->
	<!--. . . . . . . . . . . . . . . . . . . . . . . . . . . -->
	<!-- this is the output method for toc files. -->
	<xsl:output name="toc" encoding="US-ASCII" method="xhtml" indent="no" omit-xml-declaration="yes" exclude-result-prefixes="xs hotspot html kilauea"/>
	<!-- . . . . . . . . . . . . . . . . . . . . . . . . . . .-->
	<!--. . . . . . . . . . . . . . . . . . . . . . . . . . . -->
	<!-- this is the output method for XML dump files -->
	<xsl:output name="dump" method="xml" encoding="UTF-8" indent="yes" exclude-result-prefixes="xs hotspot html kilauea"/>
	<!-- . . . . . . . . . . . . . . . . . . . . . . . . . . .-->
	<!--. . . . . . . . . . . . . . . . . . . . . . . . . . . -->
	<xsl:strip-space elements="hotspot presentation part slide layout class list"/>
	<!-- . . . . . . . . . . . . . . . . . . . . . . . . . . .-->
	<!--. . . . . . . . . . . . . . . . . . . . . . . . . . . -->
	<!-- this parameter allows to generate only a specified set (comma-separated ids) of presentations rather than the complete set. -->
	<xsl:param name="presentation" select="'*'"/>
	<!-- . . . . . . . . . . . . . . . . . . . . . . . . . . .-->
	<!--. . . . . . . . . . . . . . . . . . . . . . . . . . . -->
	<!-- this parameter allows to process the input XML only in a specified set of modes (comma-separated mode names). Note that (unlike for presentations) there is neither a default 'full' set nor a shorthand denoting such a set (e.g., '*'). Porcessing modes must always be specified explicitely. The default processing mode is 'default' (what a surprise). -->
	<xsl:param name="mode" select="'default'"/>
	<!-- . . . . . . . . . . . . . . . . . . . . . . . . . . .-->
	<!--. . . . . . . . . . . . . . . . . . . . . . . . . . . -->
	<!-- controls which level of messages should be output (default is that 'error' messages are output). for a more detailed description of the message levels, see the comments far below, where the tempalte <xsl:template name="message"> is defined. -->
	<xsl:param name="messages" select="'error'"/>
	<xsl:param name="message-level" select="$messages"/>
	<!-- . . . . . . . . . . . . . . . . . . . . . . . . . . .-->
	<!--. . . . . . . . . . . . . . . . . . . . . . . . . . . -->
	<xsl:variable name="base-uri" select="base-uri(/)" as="xs:anyURI"/>
	<!-- . . . . . . . . . . . . . . . . . . . . . . . . . . .-->
	<!--. . . . . . . . . . . . . . . . . . . . . . . . . . . -->
	<xsl:variable name="nonEditableClass" select="''"/>
	<!-- . . . . . . . . . . . . . . . . . . . . . . . . . . .-->
	<!--. . . . . . . . . . . . . . . . . . . . . . . . . . . -->
	<!-- these variables are used for indicating the current hotspot version in the generated output files. -->
	<xsl:variable name="version" select="'0.5'"/>
	<xsl:variable name="svnid" select="'$Id$'"/>
	<!-- . . . . . . . . . . . . . . . . . . . . . . . . . . .-->
	<!--. . . . . . . . . . . . . . . . . . . . . . . . . . . -->
	<xsl:variable name="index-elements" select="/hotspot/categories/category/@element" as="xs:string*"/>
	<xsl:key name="categoryKey" match="hotspot/categories/category" use="@element"/>
	<xsl:key name="indexKey" match="*[local-name() = $index-elements]" use="local-name()"/>
	<!-- . . . . . . . . . . . . . . . . . . . . . . . . . . .-->
	<!--. . . . . . . . . . . . . . . . . . . . . . . . . . . -->
	<xsl:key name="structureIdKey" match="presentation | part | slide" use="@id"/>
	<xsl:key name="counterKey" match="counter" use="@id"/>
	<!-- . . . . . . . . . . . . . . . . . . . . . . . . . . .-->
	<!--. . . . . . . . . . . . . . . . . . . . . . . . . . . -->
	<!-- '''''''''''''''''''''''''''''''''''''''''''''''''''' -->
	<!-- run-time configuration through PIs and XSLT params   -->
	<!--                                                      -->
	<!-- these few configuration parameters are different     -->
	<!-- from the configuration settings which are given      -->
	<!-- within hotspot:configuation elements in XML form:    -->
	<!-- - they can only be specified on the hotspot level,   -->
	<!--   and they can be specified only exactly once.       -->
	<!-- - this can be done either as an XML processing       -->
	<!--   instruction (or PI, for short) or as an XSLT       -->
	<!--   parameter. thereby, the latter overrides the former-->
	<!-- - "additional-shortcuts" is special insofar as it can-->
	<!--   only be used as a PI, and not as an XSLT parameter.-->
	<!-- .................................................... -->
	<!-- . . . . . . . . . . . . . . . . . . . . . . . . . . .-->
	<!--. . . . . . . . . . . . . . . . . . . . . . . . . . . -->
	<!-- these are the XSLT processor params                  -->
	<xsl:param name="layout-path" select="''"/>
	<xsl:param name="kilauea-path" select="''"/>
	<xsl:param name="indent" select="''"/>
	<xsl:param name="layout" select="''"/>
	<!-- . . . . . . . . . . . . . . . . . . . . . . . . . . .-->
	<!--. . . . . . . . . . . . . . . . . . . . . . . . . . . -->
	<xsl:variable name="params" as="element(hotspot:params)">
		<xsl:element name="hotspot:params">
			<!-- the default parameter values -->
			<xsl:attribute name="layout-path" select="'layout'"/>
			<xsl:attribute name="kilauea-path" select="'kilauea'"/>
			<xsl:attribute name="indent" select="'no'"/>
			<xsl:attribute name="layout" select="'zurich'"/>
			<xsl:attribute name="additional-shortcuts" select="''"/>
			<!-- the input parameter values -->
			<xsl:for-each select="/processing-instruction('hotspot')">
				<!-- the following xpaths are not really readable, but xml/xpath's escape mechanisms make this necessary... -->
				<xsl:if test="matches(., concat('^\i\c*\s*=\s*(&quot;|', &quot;'&quot;, ').*\1\s*$'))">
					<xsl:attribute name="{replace(., concat('(\i\c*)\s*=\s*(&quot;|', &quot;'&quot;, ').*\2\s*$'), '$1')}" select="replace(., concat('\i\c*\s*=\s*(&quot;|', &quot;'&quot;, ')(.*)\1\s*$'), '$2')"/>
				</xsl:if>
			</xsl:for-each>
			<xsl:if test="$layout-path ne ''">
				<xsl:attribute name="layout-path" select="$layout-path"/>
			</xsl:if>
			<xsl:if test="$kilauea-path ne ''">
				<xsl:attribute name="kilauea-path" select="$kilauea-path"/>
			</xsl:if>
			<xsl:if test="$indent ne ''">
				<xsl:attribute name="indent" select="$indent"/>
			</xsl:if>
			<xsl:if test="$layout ne ''">
				<xsl:attribute name="layout" select="$layout"/>
			</xsl:if>
		</xsl:element>
	</xsl:variable>
	<!-- . . . . . . . . . . . . . . . . . . . . . . . . . . .-->
	<!--. . . . . . . . . . . . . . . . . . . . . . . . . . . -->
	<!-- '''''''''''''''''''''''''''''''''''''''''''''''''''' -->
	<!-- the default configuration                            -->
	<!-- in principle, even the default configuration could   -->
	<!-- be included from an external XML document.           -->
	<!-- .................................................... -->
	<!-- . . . . . . . . . . . . . . . . . . . . . . . . . . .-->
	<!--. . . . . . . . . . . . . . . . . . . . . . . . . . . -->
	<xsl:variable name="default-configuration" as="element(hotspot:configuration)" xmlns="http://dret.net/xmlns/hotspot/1">
		<configuration>
			<counter separator=": " format="full"/>
			<listing class="listing"/>
			<outline title="Outline" hidden-title="yes" count-text=" (* Slides)" count-depth="2"/>
			<outlink mark="all" style="→ *"/>
			<link author="" glossary="" home="" index="" contents="" chapters="yes" sections="yes" subsections="no" bookmarks="no" versions="" help="" cmSiteNavigationCompatibility="yes"/>
			<misc title-separator=" ; " generate-IDs="no"/>
			<notes show="no" embed="yes" draggable="no"/>
			<!-- the following settings can be specified only once, on the hotspot:hotspot level -->
			<extension file="html" link="html"/>
			<target mode="" directory="."/>
			<paths kilauea="kilauea" layout="layout" img="." listing="."/>
		</configuration>
	</xsl:variable>
	<!-- . . . . . . . . . . . . . . . . . . . . . . . . . . .-->
	<!--. . . . . . . . . . . . . . . . . . . . . . . . . . . -->
	<!-- '''''''''''''''''''''''''''''''''''''''''''''''''''' -->
	<!-- sequences of local-names, that can be used in the    -->
	<!-- following way:   match="*[local-name() = $slidish]"  -->
	<!-- .................................................... -->
	<!-- . . . . . . . . . . . . . . . . . . . . . . . . . . .-->
	<!--. . . . . . . . . . . . . . . . . . . . . . . . . . . -->
	<xsl:variable name="includables" select="('presentation', 'part', 'slide')" as="xs:string+"/>
	<!-- . . . . . . . . . . . . . . . . . . . . . . . . . . .-->
	<!--. . . . . . . . . . . . . . . . . . . . . . . . . . . -->
	<xsl:variable name="configurables" select="('hotspot', 'presentation')" as="xs:string+"/>
	<!-- . . . . . . . . . . . . . . . . . . . . . . . . . . .-->
	<!--. . . . . . . . . . . . . . . . . . . . . . . . . . . -->
	<xsl:variable name="slidish" select="('slide', 'cover', 'outline')" as="xs:string+"/>
	<!-- . . . . . . . . . . . . . . . . . . . . . . . . . . .-->
	<!--. . . . . . . . . . . . . . . . . . . . . . . . . . . -->
	<xsl:variable name="shortcuts" select="('title', 'author', 'affiliation', 'date', 'copyright', 'location', 'occasion', tokenize($params/@additional-shortcuts, '\s*,\s*'))" as="xs:string+"/>
	<!-- . . . . . . . . . . . . . . . . . . . . . . . . . . .-->
	<!--. . . . . . . . . . . . . . . . . . . . . . . . . . . -->
	<xsl:variable name="for-each-elements" select="('for-each-author', 'for-each-presentation', 'for-each-category', 'for-each-reference')" as="xs:string+"/>
	<!-- . . . . . . . . . . . . . . . . . . . . . . . . . . .-->
	<!--. . . . . . . . . . . . . . . . . . . . . . . . . . . -->
	<!-- '''''''''''''''''''''''''''''''''''''''''''''''''''' -->
	<!-- global path variables to the kilauea and the layout  -->
	<!-- directory, respectively. both paths carry a trailing -->
	<!-- slash.                                               -->
	<!-- .................................................... -->
	<!-- . . . . . . . . . . . . . . . . . . . . . . . . . . .-->
	<!--. . . . . . . . . . . . . . . . . . . . . . . . . . . -->
	<!-- process the path variables                           -->
	<!-- (note that the processed vars are called *-dir now)  -->
	<xsl:variable name="layout-dir" select="concat( if ( $params/@layout-path eq '' ) then 'layout' else $params/@layout-path, if ( not(ends-with($params/@layout-path, '/')) ) then '/' else '' )"/>
	<xsl:variable name="kilauea-dir" select="concat( if ( $params/@kilauea-path eq '' ) then 'kilauea' else $params/@kilauea-path, if ( not(ends-with($params/@kilauea-path, '/')) ) then '/' else '' )"/>
	<!--. . . . . . . . . . . . . . . . . . . . . . . . . . . -->
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
		<!-- say hello! -->
		<xsl:if test="empty(hotspot)">
			<xsl:call-template name="message">
				<xsl:with-param name="text" select="concat('&#xA;The input document ', $base-uri, ' is not a hotspot XML document. Its root element must be hotspot:hotspot, but ', (if (empty(*)) then 'no root element at all' else 'a different root element'), ' is found.&#xA;')"/>
				<xsl:with-param name="level" select="'error'"/>
			</xsl:call-template>
		</xsl:if>
		<xsl:if test="exists(hotspot/@version) and ($version ne hotspot/@version)">
			<xsl:call-template name="message">
				<xsl:with-param name="text" select="concat('&#xA;Transforming an ', hotspot/@version, ' document with Hotspot ', $version, ' may cause unexpected behavior...')"/>
				<xsl:with-param name="level" select="'warning'"/>
			</xsl:call-template>
		</xsl:if>
		<xsl:call-template name="message">
			<xsl:with-param name="text" select="('', concat('Running Hotspot ', $version, ' with the following options:'))"/>
			<xsl:with-param name="level" select="'informative'"/>
		</xsl:call-template>
		<xsl:for-each select="$params/@*">
			<xsl:sort select="local-name()"/>
			<xsl:call-template name="message">
				<xsl:with-param name="text" select="concat('   ', local-name(), ' = &quot;', ., '&quot;')"/>
				<xsl:with-param name="level" select="'informative'"/>
			</xsl:call-template>
		</xsl:for-each>
		<xsl:call-template name="message">
			<xsl:with-param name="text" select="('The path settings are:', concat('   layout-path = ', $layout-dir), concat('   kilauea-path = ', $kilauea-dir), '')"/>
			<xsl:with-param name="level" select="'informative'"/>
		</xsl:call-template>
		<!-- . . . . . . . . . . . . . . . . . . . . . . . . . . .-->
		<!--. . . . . . . . . . . . . . . . . . . . . . . . . . . -->
		<!-- the hotspot-level layout                             -->
		<xsl:variable name="selected-layout" as="element(hotspot:layout)">
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
				<xsl:with-param name="refining" select="$selected-layout/configuration"/>
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
		<!-- **************** -->
		<!-- *** STEP ONE *** -->
		<!-- **************** -->
		<xsl:call-template name="message">
			<xsl:with-param name="text" select="'Preprocessing the presentations...'"/>
			<xsl:with-param name="level" select="'informative'"/>
		</xsl:call-template>
		<xsl:variable name="preprocessed" as="document-node(element(hotspot:hotspot))">
			<xsl:document>
				<hotspot:hotspot>
					<!-- copy (actually, for extensibility: 'process') the shortcuts,... -->
					<xsl:apply-templates select="hotspot/*[local-name() = $shortcuts]" mode="preprocess"/>
					<!-- ...the script and style elements,... -->
					<xsl:apply-templates select="hotspot/(html:style | style | html:script | script)" mode="preprocess"/>
					<!-- ...the toc and index elements,... -->
					<xsl:apply-templates select="hotspot/(toc | index | categories)" mode="preprocess"/>
					<!-- ...and process the relevant presentations -->
					<xsl:apply-templates select="hotspot/presentation[exists(slide | part | @include | @external)]" mode="preprocess">
						<xsl:with-param name="layout" select="$selected-layout" tunnel="yes"/>
						<xsl:with-param name="configuration" select="$configuration" tunnel="yes"/>
					</xsl:apply-templates>
				</hotspot:hotspot>
			</xsl:document>
		</xsl:variable>
		<!-- **************** -->
		<!-- *** STEP TWO *** -->
		<!-- **************** -->
		<xsl:call-template name="message">
			<xsl:with-param name="text" select="'...done.'"/>
			<xsl:with-param name="level" select="'informative'"/>
		</xsl:call-template>
		<!-- write the dump file -->
		<!-- Todo: do not dump the intermediate XML once hotspot is running smoothly -->
		<xsl:result-document format="dump" href="dump.xml">
			<xsl:sequence select="$preprocessed"/>
		</xsl:result-document>
		<!-- process the $preprocessed XML and produce the presentation XHTML -->
		<xsl:apply-templates select="$preprocessed/hotspot">
			<xsl:with-param name="layout" select="$selected-layout" tunnel="yes"/>
			<xsl:with-param name="configuration" select="$configuration" tunnel="yes"/>
			<xsl:with-param name="basic-configuration" select="$basic-configuration" tunnel="yes"/>
		</xsl:apply-templates>
		<!-- say goodbye! -->
		<xsl:call-template name="message">
			<xsl:with-param name="text" select="'Hotspot is done!'"/>
			<xsl:with-param name="level" select="'informative'"/>
		</xsl:call-template>
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
					<!-- $shortcuts may appear interleaved with slides and the cover, but hotspot:cover has to appear before all other slides -->
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
	<xsl:template match="slide" mode="preprocess">
		<xsl:copy>
			<!-- let's generate the ID here, in the first processing step, rather than during the second one. the rationale is to allow other stylesheets to obtain the sam generated IDs, given the same input XML document. note that the decision, whether or not the generated @id will be used, is postponed to the second processing step. -->
			<xsl:if test="empty(@id)">
				<xsl:attribute name="generated-id" select="generate-id()"/>
			</xsl:if>
			<xsl:apply-templates select="@* | node()" mode="preprocess"/>
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
	<xsl:template match="*[local-name() = $index-elements]" mode="preprocess">
		<xsl:copy>
			<xsl:if test="not(@index)">
				<xsl:attribute name="index" select="hotspot:text(.)"/>
			</xsl:if>
			<xsl:apply-templates select="node() | @*" mode="preprocess"/>
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
					<xsl:copy-of select="(. | $include)/@*[not(local-name() = ('id', 'name', 'class', 'include'))]"/>
					<!-- copy the @id of the including element, rather than the @id from the included one. -->
					<xsl:copy-of select="@id"/>
					<!-- the applies for the (presentation) @name -->
					<xsl:copy-of select="@name"/>
					<!-- merge the @class attributes (is this a good idea?) -->
					<xsl:apply-templates select="@class">
						<xsl:with-param name="merge-with" select="$include/@class"/>
					</xsl:apply-templates>
					<!-- store back the resolved inclusion URI -->
					<xsl:attribute name="include" select="resolve-uri(@include, base-uri(root(.)))"/>
					<!-- parts need outlines (but only if they want them) -->
					<xsl:if test="$include/self::hotspot:part and not($include/@outline eq 'no')">
						<hotspot:outline/>
					</xsl:if>
					<xsl:apply-templates select="$include/node()" mode="preprocess">
						<xsl:with-param name="visited" select="($visited, resolve-uri(@include, base-uri(root(.))))" tunnel="yes"/>
					</xsl:apply-templates>
				</xsl:copy>
			</xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="message">
					<xsl:with-param name="text" select="concat('The inclusion URI &quot;', string(@include), '&quot; leads to an element &quot;', name($include), '&quot;, but an element &quot;hotspot:', local-name(), '&quot; was expected.')"/>
					<xsl:with-param name="level" select="'error'"/>
				</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!--. . . . . . . . . . . . . . . . . . . . . . . . . . . -->
	<!-- . . . . . . . . . . . . . . . . . . . . . . . . . . .-->
	<xsl:template match="@include" as="element()?">
		<xsl:param name="visited" as="xs:anyURI*" tunnel="yes"/>
		<xsl:variable name="uri" as="xs:string" select="tokenize(., '#')[1]"/>
		<xsl:variable name="fragment" as="xs:string?" select="tokenize(., '#')[2]"/>
		<!-- todo: solve this riddle: do we have to resolve with the $base-uri? or using the base-uri(root(.))? -->
		<xsl:variable name="docname" as="xs:anyURI?" select="resolve-uri($uri, base-uri(root(.)))"/>
<!--		<xsl:variable name="docname" as="xs:anyURI?" select="resolve-uri($uri, $base-uri)"/>-->
		<xsl:choose>
			<xsl:when test="hotspot:illegal-inclusion($visited, $docname, $fragment)">
				<xsl:call-template name="message">
					<xsl:with-param name="text" select="concat('Illegal inclusion which implies a circular reference to &quot;', $docname, '&quot;')"/>
					<xsl:with-param name="level" select="'error'"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:variable name="include" as="element()?">
					<xsl:choose>
						<!-- it is a local include -->
						<xsl:when test="$uri eq ''">
							<xsl:choose>
								<xsl:when test="$fragment ne ''">
									<xsl:sequence select="key('structureIdKey', $fragment)"/>
								</xsl:when>
								<xsl:otherwise>
									<!-- this default behaviour in the absence of a fragment identifier is a design decision. other default strategies are conceivable, e.g., returning all presentations, or throwing an error. -->
									<xsl:sequence select="/hotspot/presentation[1]"/>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:when>
						<!-- it is an external include -->
						<xsl:when test="doc-available($docname)">
							<xsl:choose>
								<xsl:when test="$fragment ne ''">
									<xsl:sequence select="doc($docname)//(presentation | slide | part)[@id eq $fragment]"/>
								</xsl:when>
								<xsl:otherwise>
									<!-- this default behaviour in the absence of a fragment identifier is a design decision. other default strategies are conceivable, e.g., returning all presentations, or throwing an error. -->
									<xsl:sequence select="doc($docname)/hotspot/presentation[1]"/>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:when>
						<!-- it is an external include, but the required document is not available -->
						<xsl:otherwise>
							<xsl:call-template name="message">
								<xsl:with-param name="text" select="concat('Unable to resolve document &quot;', $docname, '&quot;')"/>
								<xsl:with-param name="level" select="'error'"/>
							</xsl:call-template>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<!-- notify the user, if nothing has been retrieved -->
				<xsl:if test="empty($include)">
					<xsl:call-template name="message">
						<xsl:with-param name="text" select="concat('The inclusion URI &quot;', string(.), '&quot; does not return any elements.')"/>
						<xsl:with-param name="level" select="'warning'"/>
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
		<!-- TODO: check whether the include will result in a circular disaster ... even though this is indispensable in principle, such a test may increase run-time complexity considerably -->
		<!-- for the moment being, we're completely heedless. -->
		<xsl:sequence select="false()"/>
	</xsl:function>
	<!-- . . . . . . . . . . . . . . . . . . . . . . . . . . .-->
	<!--. . . . . . . . . . . . . . . . . . . . . . . . . . . -->
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
				<span class="{key('categoryKey', local-name())/@class}" id="{generate-id(.)}">
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
	<!-- the hotspot template                                 -->
	<!-- .................................................... -->
	<xsl:template match="hotspot">
		<!-- '''''''''''''''''''''''''''''''''''' -->
		<!-- iterate over all non-empty           --> 
		<!-- and non-external presentations       -->
		<!-- .................................... -->
		<xsl:call-template name="message">
			<xsl:with-param name="text" select="('Generating the XHTML presentation documents...', '')"/>
			<xsl:with-param name="level" select="'informative'"/>
		</xsl:call-template>
		<!-- a presentation is processed only if it has at least one slide or part (the first step has already taken care of this), is not external, if all presentations are selected, or if it appears in the list of presentations to be generated. -->
		<xsl:apply-templates select="presentation[empty(@external)][$presentation = '*' or @id = tokenize($presentation, '\s*,\s*')]">
			<xsl:with-param name="shortcut-stack" as="element(hotspot:shortcuts)+" tunnel="yes">
				<xsl:call-template name="push-shortcuts"/>
			</xsl:with-param>
		</xsl:apply-templates>
		<xsl:call-template name="message">
			<xsl:with-param name="text" select="('', '...done.')"/>
			<xsl:with-param name="level" select="'informative'"/>
		</xsl:call-template>
		<!-- '''''''''''''''''''''''''''''''''''' -->
		<!-- generate the TOC and index files     -->
		<!-- .................................... -->
		<xsl:call-template name="message">
			<xsl:with-param name="text" select="if (exists((toc | index)[exists(@name)])) then ('Generating the TOC and index documents...', '') else 'No TOC documents to generate.'"/>
			<xsl:with-param name="level" select="'informative'"/>
		</xsl:call-template>
		<!-- process all toc and index elements that have a @name -->
		<xsl:apply-templates select="(toc | index)[exists(@name)]">
			<xsl:with-param name="shortcut-stack" as="element(hotspot:shortcuts)+" tunnel="yes">
				<xsl:call-template name="push-shortcuts"/>
			</xsl:with-param>
		</xsl:apply-templates>
		<xsl:if test="exists((toc | index)[exists(@name)])">
			<xsl:call-template name="message">
				<xsl:with-param name="text" select="('...done.', '')"/>
				<xsl:with-param name="level" select="'informative'"/>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>
	<!-- . . . . . . . . . . . . . . . . . . . . . . . . . . .-->
	<!--. . . . . . . . . . . . . . . . . . . . . . . . . . . -->
	<!-- '''''''''''''''''''''''''''''''''''''''''''''''''''' -->
	<!-- the presentation template                            -->
	<!-- .................................................... -->
	<xsl:template match="presentation">
		<xsl:param name="configuration" as="element(hotspot:configuration)" tunnel="yes"/>
		<!-- calculate the number of slides -->
		<xsl:variable name="total-slides" select="count(.//*[local-name() = $slidish])"/>
		<xsl:variable name="content-slides" select="count(.//slide)"/>
		<xsl:call-template name="message">
			<xsl:with-param name="text" select="concat(hotspot:presentationfilename(., $configuration), ' (', $content-slides, '+', $total-slides - $content-slides, '=', $total-slides, ' slides)')"/>
		</xsl:call-template>
		<!-- output one result document for each presentation -->
		<xsl:result-document format="slides{ if ($params/@indent eq 'yes') then '-indent' else '' }" href="{hotspot:presentationfilename(., $configuration)}">
<!--			<xsl:text>&#xA;</xsl:text>-->
			<xsl:comment>
				<xsl:text> Do not edit by hand! Generated by Hotspot </xsl:text>
				<xsl:value-of select="concat($version, ' (', $svnid, ')')"/>
				<xsl:text> on </xsl:text>
				<xsl:value-of select="current-dateTime()"/>
				<xsl:text>. Edit the source XML document instead! </xsl:text>
			</xsl:comment>
<!--			<xsl:text>&#xA;</xsl:text>-->
<!--			<xsl:comment> For more information about Hotspot please visit http://dret.net/projects/hotspot/. </xsl:comment>-->
			<html>
				<xsl:call-template name="head">
					<xsl:with-param name="shortcut-stack" as="element(hotspot:shortcuts)+" tunnel="yes">
						<xsl:call-template name="push-shortcuts"/>
					</xsl:with-param>
					<xsl:with-param name="configuration" as="element(hotspot:configuration)" tunnel="yes">
						<xsl:call-template name="merge-configurations">
							<xsl:with-param name="existing" select="$configuration"/>
							<xsl:with-param name="refining" select="configuration"/>
						</xsl:call-template>
					</xsl:with-param>
				</xsl:call-template>
				<xsl:call-template name="body">
					<xsl:with-param name="shortcut-stack" as="element(hotspot:shortcuts)+" tunnel="yes">
						<xsl:call-template name="push-shortcuts"/>
					</xsl:with-param>
					<xsl:with-param name="configuration" as="element(hotspot:configuration)" tunnel="yes">
						<xsl:call-template name="merge-configurations">
							<xsl:with-param name="existing" select="$configuration"/>
							<xsl:with-param name="refining" select="configuration"/>
						</xsl:call-template>
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
		<xsl:param name="shortcut-stack" as="element(hotspot:shortcuts)+" tunnel="yes"/>
		<head>
			<xsl:if test="hotspot:lang(.) ne ''">
				<xsl:attribute name="lang" select="hotspot:lang(.)"/>
				<xsl:attribute name="xml:lang" select="hotspot:lang(.)"/>
			</xsl:if>
			<!-- '''''''''''''''''''''''' -->
			<!-- the page title           -->
			<!-- ........................ -->
			<title>
				<xsl:value-of select="string-join((hotspot:expand-shortcut($shortcut-stack, 'title'), hotspot:expand-shortcut($shortcut-stack, 'author'), hotspot:expand-shortcut($shortcut-stack, 'affiliation')), $configuration/misc/@title-separator)"/>
			</title>
			<!-- if a copyright notice is set explicitly, it will be used for the copyright notice instead of the default (date/author). -->
			<meta name="copyright" content="Copyright &#169; { if (hotspot:expand-shortcut($shortcut-stack, 'copyright') ne '' ) then hotspot:expand-shortcut($shortcut-stack, 'copyright') else concat(hotspot:expand-shortcut($shortcut-stack, 'date'), ' ', hotspot:expand-shortcut($shortcut-stack, 'author'))}"/>
			<!-- '''''''''''''''''''''''' -->
			<!-- stylesheets              -->
			<!-- ........................ -->
			<!-- include the basic kilauea CSS styles which are functionally essential -->
			<link rel="stylesheet" type="text/css" media="screen, projection, print" href="{ $kilauea-dir }kilauea.css"/>
			<!-- include all CSS stylesheet documents which are required by the layout -->
			<xsl:for-each select="$layout/css">
				<xsl:choose>
					<xsl:when test="@document">
						<link rel="stylesheet" type="text/css" media="{ if (@media) then @media else 'screen, projection'}" href="{ @document }"/>
					</xsl:when>
					<xsl:otherwise>
						<style type="text/css">
							<xsl:apply-templates select="node()"/>
						</style>
					</xsl:otherwise>
				</xsl:choose>
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
			<script type="text/javascript" src="{$kilauea-dir}kilauea.js"/>
<!--						<script type="text/javascript" src="{$kilauea-dir}/js/kilauea.packed.js"/>-->
			<!-- generate the js code that is needed to initialize Kilauea -->
			<xsl:call-template name="kilauea-init"/>
			<!-- '''''''''''''''''''''''' -->
			<!-- inlined CSS / JS parts   -->
			<!-- ........................ -->
			<!-- style and script elements are copied from the hotspot element and the current presentation element. -->
			<xsl:apply-templates select="*[local-name() = ('style', 'script')] | css | parent::hotspot/*[local-name() = ('style', 'script')]"/>
		</head>
	</xsl:template>
	<!-- . . . . . . . . . . . . . . . . . . . . . . . . . . .-->
	<!--. . . . . . . . . . . . . . . . . . . . . . . . . . . -->
	<xsl:template match="style[@src] | html:style[@src]">
		<!-- style elements referring to external stylesheets must be mapped to xhtml <link rel="stylesheet" href="" .../>. -->
		<link rel="stylesheet" href="{@src}">
			<xsl:apply-templates select="@*[local-name() ne 'src']"/>
		</link>
	</xsl:template>
	<!-- . . . . . . . . . . . . . . . . . . . . . . . . . . .-->
	<!--. . . . . . . . . . . . . . . . . . . . . . . . . . . -->
	<!-- . . . . . . . . . . . . . . . . . . . . . . . . . . .-->
	<!--. . . . . . . . . . . . . . . . . . . . . . . . . . . -->
	<!-- '''''''''''''''''''''''''''''''''''''''''''''''''''' -->
	<!-- the HTML body                                        -->
	<!-- .................................................... -->
	<xsl:template name="body" as="element(html:body)">
		<body>
			<xsl:call-template name="presentation"/>
		</body>
	</xsl:template>
	<xsl:template name="presentation" as="element()*">
		<xsl:param name="layout" as="element(hotspot:layout)" tunnel="yes"/>
		<!-- process the backgrounds,... -->
		<xsl:apply-templates select="$layout/class"/>
		<xsl:if test="count($layout/cover) ne 1">
			<xsl:call-template name="message">
				<xsl:with-param name="text" select="concat(if (exists($layout/cover)) then 'More than one' else 'No', ' cover slide defined.')"/>
				<xsl:with-param name="level" select="'warning'"/>
			</xsl:call-template>
		</xsl:if>
		<!-- ...the cover, and... -->
		<xsl:apply-templates select="$layout/cover"/>
		<!-- ...the content slides. -->
		<xsl:apply-templates select="slide | outline | part"/>
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
	<xsl:template match="cover">
		<xsl:param name="configuration" as="element(hotspot:configuration)" tunnel="yes"/>
		<div class="slide cover{ if (exists(@class)) then concat(' ', @class) else '' }">
			<xsl:if test="exists(@id) or $configuration/misc/@generate-IDs = 'yes'">
				<xsl:attribute name="id" select="if (exists(@id)) then @id else generate-id()"/>
			</xsl:if>
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
		<xsl:param name="shortcut-stack" as="element(hotspot:shortcuts)+" tunnel="yes"/>
		<!-- generate part wrapping divs for kilauea -->
		<div class="part">
			<xsl:if test="exists(@id) or $configuration/misc/@generate-IDs = 'yes'">
				<xsl:attribute name="id" select="if (exists(@id)) then @id else @generated-id"/>
			</xsl:if>
			<xsl:if test="exists(title/node())">
				<h1 class="partTitle">
					<xsl:if test="exists(title/@short)">
						<xsl:attribute name="title" select="title/@short"/>
					</xsl:if>
					<xsl:sequence select="title/node()"/>
				</h1>
			</xsl:if>
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
						<xsl:value-of select="concat(' (', hotspot:expand-shortcut($shortcut-stack, 'title'),')')"/>
					</span>
				</xsl:if>
			</h1>
			<ol class="outline">
				<xsl:apply-templates select="ancestor::presentation[1]/part" mode="outline">
					<xsl:with-param name="current" select="parent::part" tunnel="yes"/>
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
			<!-- highlight the $current entry (the part currently being presented) using the CSS class "outline-current" -->
			<xsl:choose>
				<xsl:when test=". is $current">
					<xsl:attribute name="class" select="'expand outline-current'"/>
				</xsl:when>
				<xsl:when test="some $i in descendant::* satisfies $i is $current">
					<xsl:attribute name="class" select="'expand'"/>
				</xsl:when>
			</xsl:choose>
			<!-- todo: this reasoning is sophisticated, but wrong nevertheless. -->
			<!-- collect the local shortcuts. we have to use them differently later, depending on whether the currently processed part is the $current part (in which case we descend, and therefore push the $local-shortcuts onto the stack) or not (in which case we replace the stack's topmost entry by the $local-shortcuts). -->
			<xsl:variable name="local-shortcuts" select="hotspot:push-shortcuts((), .)" as="element(hotspot:shortcuts)" />
			<xsl:choose>
				<!-- it's the $current entry (the part currently being presented): -->
				<xsl:when test=". is $current">
					<xsl:apply-templates select="hotspot:expand-shortcut(($shortcut-stack, $local-shortcuts), 'title', 'long', 'nodes')"/>
				</xsl:when>
				<!-- it's an other, non-$current part -->
				<xsl:otherwise>
					<a href="{hotspot:id(.)}" title="go to part &quot;{hotspot:expand-shortcut($shortcut-stack, 'title')}&quot;">
						<xsl:apply-templates select="hotspot:expand-shortcut(($shortcut-stack, $local-shortcuts), 'title', 'long', 'nodes')"/>
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
			<xsl:if test="exists(@short)">
				<xsl:attribute name="title" select="@short"/>
			</xsl:if>
			<xsl:apply-templates select="@*[not(local-name() = ('short'))] | node()"/>
		</h1>
	</xsl:template>
	<!-- . . . . . . . . . . . . . . . . . . . . . . . . . . .-->
	<!--. . . . . . . . . . . . . . . . . . . . . . . . . . . -->
	<!-- '''''''''''''''''''''''''''''''''''''''''''''''''''' -->
	<!-- link elements (e.g., for use with cmSiteNavigation)  -->
	<!-- .................................................... -->
	<xsl:template match="configuration/link">
		<xsl:param name="context" as="element(hotspot:presentation)"/>
		<xsl:param name="configuration" as="element(hotspot:configuration)" tunnel="yes"/>
		<xsl:param name="shortcut-stack" as="element(hotspot:shortcuts)+" tunnel="yes"/>
		<!-- for a list of rel types see http://www.w3.org/TR/xhtml-modularization/abstraction.html#dt_LinkTypes -->
		<xsl:if test="@author ne ''">
			<!-- if the user configured a link to a "author" document, include a link to it. -->
			<link rel="author" href="{@author}"/>
		</xsl:if>
		<xsl:if test="@contents ne ''">
			<!-- if the user configured a link to a "contents" document, include a link to it. -->
			<link rel="contents" href="{@contents}" title="{hotspot:expand-shortcut($shortcut-stack[1], 'title', 'short')}"/>
		</xsl:if>
		<xsl:if test="@glossary ne ''">
			<!-- if the user configured a link to a "glossary" document, include a link to it. -->
			<link rel="glossary" href="{@glossary}"/>
		</xsl:if>
		<xsl:if test="@index ne ''">
			<!-- if the user configured a link to a "index" document, include a link to it. -->
			<link rel="index" href="{@index}"/>
		</xsl:if>
		<xsl:if test="@home ne ''">
			<!-- if the user configured a link to a "home" document, include a link to it. -->
			<link rel="home" href="{@home}" title="{hotspot:expand-shortcut($shortcut-stack[1], 'title', 'short')}"/>
		</xsl:if>
		<xsl:variable name="next" select="$context/following-sibling::presentation[1]"/>
		<!-- if there is a "next" presentation, include a link to it. -->
		<xsl:if test="exists($next)">
			<link rel="next" href="{ if ( exists($next/@external) ) then $next/@external else hotspot:presentationlinkname($next, $configuration) }" title="{hotspot:expand-shortcut(hotspot:push-shortcuts($shortcut-stack[position() ne last()], $next), 'title', 'short')}"/>
		</xsl:if>
		<xsl:variable name="last" select="$context/following-sibling::presentation[last()]"/>
		<!-- if there is a "last" presentation, include a link to it. -->
		<xsl:if test="exists($last)">
			<link rel="last" href="{ if ( exists($last/@external) ) then $last/@external else hotspot:presentationlinkname($last, $configuration) }" title="{hotspot:expand-shortcut(hotspot:push-shortcuts($shortcut-stack[position() ne last()], $last), 'title', 'short')}"/>
		</xsl:if>
		<xsl:variable name="prev" select="$context/preceding-sibling::presentation[1]"/>
		<!-- if there is a "previous" presentation, include a link to it. -->
		<xsl:if test="exists($prev)">
			<link rel="prev" href="{ if ( exists($prev/@external) ) then $prev/@external else hotspot:presentationlinkname($prev, $configuration) }" title="{hotspot:expand-shortcut(hotspot:push-shortcuts($shortcut-stack[position() ne last()], $prev), 'title', 'short')}"/>
		</xsl:if>
		<xsl:variable name="first" select="$context/preceding-sibling::presentation[last()]"/>
		<!-- if there is a "first" presentation, include a link to it. -->
		<xsl:if test="exists($first)">
			<link rel="start" href="{ if ( exists($first/@external) ) then $first/@external else hotspot:presentationlinkname($first, $configuration) }" title="{hotspot:expand-shortcut(hotspot:push-shortcuts($shortcut-stack[position() ne last()], $first),'title', 'short')}"/>
			<!-- officially, this is called "start", but opera does not recognize "start" and instead needs this to be called "first". -->
			<link rel="first" href="{ if ( exists($first/@external) ) then $first/@external else hotspot:presentationlinkname($first, $configuration) }" title="{hotspot:expand-shortcut(hotspot:push-shortcuts($shortcut-stack[position() ne last()], $first), 'title', 'short')}"/>
		</xsl:if>
		<!-- list all presentations as chapters, if demanded -->
		<xsl:if test="@chapters eq 'yes'">
			<xsl:for-each select="$context/root()/hotspot/presentation">
				<link rel="chapter" href="{ if ( exists(@external) ) then @external else hotspot:presentationlinkname(., $configuration) }" title="{hotspot:expand-shortcut(hotspot:push-shortcuts($shortcut-stack[position() ne last()], .), 'title', 'short')}"/>
			</xsl:for-each>
		</xsl:if>
		<!-- list all parts as sections, if desired -->
		<xsl:if test="@sections eq 'yes'">
			<xsl:for-each select="$context/part">
				<!-- this would be much nicer (and more resilient and cleaner and so on) if cmSSiteNavigation and the alike would support onclick -->
				<xsl:choose>
					<xsl:when test="@cmSiteNavigationCompatibility eq 'yes'">
						<link rel="section" href="javascript:Kilauea.instances[0].showSlide({hotspot:slidenumber(.) - 1})" title="{hotspot:expand-shortcut(hotspot:push-shortcuts($shortcut-stack, .), 'title', 'short')}"/>
					</xsl:when>
					<xsl:otherwise>
						<link rel="section" href="{hotspot:id(.)}" onclick="Kilauea.instances[0].showSlide({hotspot:slidenumber(.) - 1})" title="{hotspot:expand-shortcut(hotspot:push-shortcuts($shortcut-stack, .), 'title', 'short')}"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:for-each>
		</xsl:if>
		<!-- list all subparts as subsections, if desired -->
		<xsl:if test="@subsections eq 'yes'">
			<xsl:for-each select="$context/part/part">
				<!-- this would be much nicer (and more resilient and cleaner and so on) if cmSSiteNavigation and the alike would support onclick -->
				<xsl:choose>
					<xsl:when test="@cmSiteNavigationCompatibility eq 'yes'">
						<link rel="subsection" href="javascript:Kilauea.instances[0].showSlide({hotspot:slidenumber(.) - 1})" title="{hotspot:expand-shortcut(hotspot:push-shortcuts($shortcut-stack, parent::part), 'title', 'short')}: {hotspot:expand-shortcut(hotspot:push-shortcuts($shortcut-stack, .), 'title', 'short')}"/>
					</xsl:when>
					<xsl:otherwise>
						<link rel="subsection" href="{hotspot:id(.)}" onclick="javascript:Kilauea.instances[0].showSlide({hotspot:slidenumber(.) - 1})" title="{hotspot:expand-shortcut(hotspot:push-shortcuts($shortcut-stack, parent::part), 'title', 'short')}: {hotspot:expand-shortcut(hotspot:push-shortcuts($shortcut-stack, .), 'title', 'short')}"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:for-each>
		</xsl:if>
		<!-- list all slides as bookmarks, if desired -->
		<xsl:if test="@bookmarks eq 'yes'">
			<xsl:for-each select="$context//slide">
				<!-- this would be much nicer (and more resilient and cleaner and so on) if cmSSiteNavigation and the alike would support onclick -->
				<xsl:choose>
					<xsl:when test="@cmSiteNavigationCompatibility eq 'yes'">
						<link rel="bookmark" href="javascript:Kilauea.instances[0].showSlide({hotspot:slidenumber(.) - 1})" title="{hotspot:expand-shortcut(hotspot:push-shortcuts($shortcut-stack, .), 'title', 'short')}"/>
					</xsl:when>
					<xsl:otherwise>
						<link rel="bookmark" href="{hotspot:id(.)}" onclick="javascript:Kilauea.instances[0].showSlide({hotspot:slidenumber(.) - 1})" title="{hotspot:expand-shortcut(hotspot:push-shortcuts($shortcut-stack, .), 'title', 'short')}"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:for-each>
		</xsl:if>
		<!-- link to alternate versions, if indicated -->
		<xsl:if test="@versions">
			<xsl:variable name="versions" select="tokenize(@versions, '\s+')" as="xs:string*"/>
			<xsl:for-each select="$versions">
				<!-- take the file extension as the link's title -->
				<link rel="alternate" href="{.}" title="{upper-case(replace(., '^(.*\.)(\w+)$', '$2'))}"/>
			</xsl:for-each>
		</xsl:if>
		<!-- insert a help link -->
		<xsl:choose>
			<xsl:when test="@help eq 'online'">
				<link rel="help" title="Online Help" href="http://sharpeleven.net/kilauea/help/?r=hotspot"/>
			</xsl:when>
			<xsl:when test="@help eq 'quick'">
				<link rel="help" title="Quick Help" href="javascript:Kilauea.instances[0].help()"/>
			</xsl:when>
		</xsl:choose>
	</xsl:template>
	<!-- . . . . . . . . . . . . . . . . . . . . . . . . . . .-->
	<!--. . . . . . . . . . . . . . . . . . . . . . . . . . . -->
	<!-- '''''''''''''''''''''''''''''''''''''''''''''''''''' -->
	<!-- Hotspot elements within slides                       -->
	<!-- (e.g., title and author elements)                    -->
	<!-- .................................................... -->
	<!-- the title group elements are expanded when found within a slide and empty (apart from attributes as defined by the schema). -->
	<xsl:template match="slide//*[local-name() = $shortcuts][count(@* | node()) eq count(@level | @form)]">
		<xsl:param name="shortcut-stack" as="element(hotspot:shortcuts)+" tunnel="yes"/>
		<xsl:param name="editMode" select="false()" tunnel="yes"/>
		<xsl:apply-templates select="hotspot:expand-shortcut($shortcut-stack, local-name(), @form, 'nodes', @level)"/>
	</xsl:template>
	<!-- . . . . . . . . . . . . . . . . . . . . . . . . . . .-->
	<!--. . . . . . . . . . . . . . . . . . . . . . . . . . . -->
	<!-- '''''''''''''''''''''''''''''''''''''''''''''''''''' -->
	<!-- Hotspot elements within the cover slide              -->
	<!-- .................................................... -->
	<xsl:template match="cover//*[local-name() = $shortcuts][count(@* | node()) eq count(@level | @form)]">
		<xsl:param name="shortcut-stack" as="element(hotspot:shortcuts)+" tunnel="yes"/>
		<xsl:param name="position" tunnel="yes" select="1"/>
		<xsl:param name="form"/>
		<!-- for cover slides, the level must be either 'hotspot' or 'presentation', with the latter being the default level -->
		<xsl:variable name="level" select="if ( @level eq 'hotspot' ) then 'hotspot' else 'presentation'"/>
		<xsl:apply-templates select="hotspot:expand-shortcut($shortcut-stack, local-name(), @form, if (($form, @form) = ('text', 'short')) then 'string' else 'nodes', $level, $position)"/>
	</xsl:template>
	<!-- . . . . . . . . . . . . . . . . . . . . . . . . . . .-->
	<!--. . . . . . . . . . . . . . . . . . . . . . . . . . . -->
	<!-- '''''''''''''''''''''''''''''''''''''''''''''''''''' -->
	<!-- iterate over multiple authors              -->
	<!-- .......................................... -->
	<xsl:template match="for-each-author">
		<xsl:param name="shortcut-stack" as="element(hotspot:shortcuts)+" tunnel="yes"/>
		<!-- for cover slides, the level must be either 'hotspot' or 'presentation', with the latter being the default level -->
		<xsl:variable name="level" select="if (ancestor::toc[exists(@name)]) then 'hotspot' else if ( .//author/@level eq 'hotspot' ) then 'hotspot' else 'presentation'"/>
		<!-- collect all authors (the author information will be fetched a second time while applying the tempaltes below. therefore, we just fetch the raw entries form the $shortcut-stack) -->
		<xsl:variable name="authors" select="$shortcut-stack[@level eq $level]/author" as="element(author)*"/>
		<!-- store the current context, as "current()" wont work within the for-loop below -->
		<xsl:variable name="context" select="."/>
		<!-- process the content of hotspot:for-each-author for each author -->
		<xsl:for-each select="(1 to count($authors))">
			<xsl:apply-templates select="$context/node()">
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
		<xsl:param name="configuration" as="element(hotspot:configuration)" tunnel="yes"/>
		<xsl:param name="shortcut-stack" as="element(hotspot:shortcuts)+" tunnel="yes"/>
		<!-- allow the user to suppress microformatization -->
		<xsl:if test="not(parent::hotspot:author/@microformats = 'false')">
			<span class="vcard">
				<xsl:choose>
					<xsl:when test="self::text()">
						<span class="fn n">
							<xsl:sequence select="hotspot:microformat-name(., $configuration)"/>
						</span>
					</xsl:when>
					<xsl:when test="local-name() eq 'a'">
						<a>
							<xsl:attribute name="class" select="string-join((if (position() eq 1) then 'fn n' else '', if (starts-with(@href, 'mailto:')) then 'email' else 'url', @class), ' ')"/>
							<xsl:copy-of select="@*[local-name() ne 'class']"/>
							<xsl:sequence select="hotspot:microformat-name(node(), $configuration)"/>
						</a>
					</xsl:when>
					<xsl:otherwise>
						<span class="fn n">
							<xsl:sequence select="hotspot:microformat-name(node(), $configuration)"/>
						</span>
					</xsl:otherwise>
				</xsl:choose>
				<xsl:variable name="affiliation" select="($shortcut-stack//hotspot:affiliation[@short = current()/parent::hotspot:author/@affiliation])[last()]" as="element(hotspot:affiliation)?"/>
				<xsl:if test="exists($affiliation)">
					<span class="org" style="display: none">
						<xsl:apply-templates select="$affiliation/node()" mode="nested"/>
					</span>
				</xsl:if>
			</span>
		</xsl:if>
	</xsl:template>
	<!-- . . . . . . . . . . . . . . . . . . . . . . . . . . .-->
	<!--. . . . . . . . . . . . . . . . . . . . . . . . . . . -->
	<!-- '''''''''''''''''''''''''''''''''''''''''''''''''''' -->
	<!-- microformats! analyze names within hcards            -->
	<!-- .................................................... -->
	<xsl:function name="hotspot:microformat-name">
		<xsl:param name="content" as="item()*"/>
		<xsl:param name="configuration" as="element(hotspot:configuration)"/>
		<!-- TODO: make customizable one day. e.g., reverse name orders (japanese-style) should become available someday -->
		<!-- flatten the content (this isn't nice in case the author of the XML employed formatting; but it makes our job a lot easier) -->
		<xsl:variable name="string-content" select="hotspot:text($content)" as="xs:string"/>
		<!-- a word of precaution: we're only able to guess. however, we do so in a best-effort manner. some improvements are still possible, though -->
		<!-- for instance, the honorifics might be extracted using a list of common honorific titles -->
		<xsl:analyze-string regex="^\s*((\w+\.\s+)+)" select="$string-content">
			<xsl:matching-substring>
				<span class="honorific-prefix"><xsl:value-of select="regex-group(1)"/></span>
			</xsl:matching-substring>
			<xsl:non-matching-substring>
				<xsl:variable name="sliced-content" as="xs:string*" select="tokenize(., '\s+')"/>
				<xsl:choose>
					<xsl:when test="count($sliced-content) gt 2">
						<span class="given-name"><xsl:value-of select="$sliced-content[1]"/></span><xsl:text> </xsl:text>
						<span class="additional-name"><xsl:value-of select="string-join($sliced-content[position() ne 1][position() ne last()], ' ')"/></span><xsl:text> </xsl:text>
						<span class="family-name"><xsl:value-of select="$sliced-content[last()]"/></span>
					</xsl:when>
					<xsl:when test="count($sliced-content) eq 2">
						<span class="given-name"><xsl:value-of select="$sliced-content[1]"/></span><xsl:text> </xsl:text>
						<span class="family-name"><xsl:value-of select="$sliced-content[last()]"/></span>
					</xsl:when>
					<!-- if just one name is present, we assume this to be the given name. (is this standard-compliant? should it be the family name?) -->
					<xsl:otherwise>
						<span class="given-name"><xsl:value-of select="$sliced-content"/></span>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:non-matching-substring>
		</xsl:analyze-string>
	</xsl:function>
	<!-- . . . . . . . . . . . . . . . . . . . . . . . . . . .-->
	<!--. . . . . . . . . . . . . . . . . . . . . . . . . . . -->
	<!-- '''''''''''''''''''''''''''''''''''''''''''''''''''' -->
	<!-- microformats! turn affiliations into hcards          -->
	<!-- .................................................... -->
	<xsl:template match="affiliation/node()">
		<span class="vcard">
			<xsl:choose>
				<xsl:when test="self::text()">
					<span class="fn org">
						<xsl:value-of select="."/>
					</span>
				</xsl:when>
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
	<!-- basically the same, but for use within vcards -->
	<xsl:template match="affiliation/node()" mode="nested">
		<xsl:choose>
			<xsl:when test="self::text()">
				<xsl:value-of select="."/>
			</xsl:when>
			<xsl:when test="local-name() eq 'a'">
				<a>
					<xsl:attribute name="class" select="string-join((if (starts-with(@href, 'mailto:')) then 'email' else 'url', @class), ' ')"/>
					<xsl:copy-of select="@*[local-name() ne 'class']"/>
					<xsl:apply-templates select="node()"/>
				</a>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates select="node()"/>
			</xsl:otherwise>
		</xsl:choose>
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
				<div>
					<xsl:attribute name="class" select="concat('note', if ($configuration/notes/@draggable = 'yes') then ' draggable' else ' nodrag')"/>
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
	<!-- '''''''''''''''''''''''''''''''''''''''''''''''''''' -->
	<!-- HTML lists - shortcuts, alternative syntax fixing    -->
	<!-- .................................................... -->
	<!-- . . . . . . . . . . . . . . . . . . . . . . . . . . .-->
	<!--. . . . . . . . . . . . . . . . . . . . . . . . . . . -->
	<!-- lists in hotspot are simply there to enable nested lists without the mixed content structure imposed by html's lists. -->
	<xsl:template match="list">
		<xsl:element name="{ if ( @type eq 'ol' ) then 'ol' else 'ul' }" namespace="http://www.w3.org/1999/xhtml">
			<xsl:apply-templates select="@*[not(local-name() eq 'type')] | li"/>
		</xsl:element>
	</xsl:template>
	<!-- . . . . . . . . . . . . . . . . . . . . . . . . . . .-->
	<!--. . . . . . . . . . . . . . . . . . . . . . . . . . . -->
	<!-- hotspot attempts to "fix lists" by moving non-li elements into li elements (as required by xhtml). thus, non-li children are taken care of in the handling of li elements, and they must be ignored here. However, some hotspot elements that are processed further, and which cannot appear in the final html thus, have to be spared from this strategy: these are the $for-each-elements. -->
	<xsl:template match="ul | ol | html:ul | html:ol">
		<xsl:element name="{local-name()}" namespace="http://www.w3.org/1999/xhtml">
			<xsl:apply-templates select="@* | li | *[local-name() = $for-each-elements]"/>
		</xsl:element>
	</xsl:template>
	<!-- . . . . . . . . . . . . . . . . . . . . . . . . . . .-->
	<!--. . . . . . . . . . . . . . . . . . . . . . . . . . . -->
	<!-- list/li must be handled explicitly to move content from "between" li elements "into" (ul|ol)/li. this template also matches li elements for regular html lists (ul|ol) and therefore "fixes" illegally structured html lists. -->
	<xsl:template match="li | html:li">
		<xsl:element name="li" namespace="http://www.w3.org/1999/xhtml">
			<!-- the following xpath selects the li attributes, the li child nodes, and all elements following the li element up to the next li sibling. -->
			<xsl:apply-templates select="@* | node() | ( following-sibling::* intersect  ( if ( exists(following-sibling::*[local-name() eq 'li'][1]) ) then following-sibling::*[local-name() eq 'li'][1]/preceding-sibling::* else following-sibling::* ))"/>
		</xsl:element>
	</xsl:template>
	<!-- . . . . . . . . . . . . . . . . . . . . . . . . . . .-->
	<!--. . . . . . . . . . . . . . . . . . . . . . . . . . . -->
	<!-- '''''''''''''''''''''''''''''''''''''''''''''''''''' -->
	<!-- HTML images - linking, path fixing                   -->
	<!-- .................................................... -->
	<!-- . . . . . . . . . . . . . . . . . . . . . . . . . . .-->
	<!--. . . . . . . . . . . . . . . . . . . . . . . . . . . -->
	<!-- replaces an img's @src with a prefixed uri if requested by the img-src-prefix processing instruction. -->
	<xsl:template match="img/@src | html:img/@src">
		<xsl:param name="configuration" as="element(hotspot:configuration)" tunnel="yes"/>
		<xsl:attribute name="src">
			<xsl:value-of select="hotspot:prefixed-uri(., $configuration/paths/@img, string(.))"/>
		</xsl:attribute>
	</xsl:template>
	<!-- . . . . . . . . . . . . . . . . . . . . . . . . . . .-->
	<!--. . . . . . . . . . . . . . . . . . . . . . . . . . . -->
	<!-- if an image is not a link (i.e., has no @href attribute) and is not contained in a link, turn it into a link to its @src. -->
	<xsl:template match="img[empty(@href)][empty(ancestor::a | ancestor::html:a | ancestor::hotspot:class)] | html:img[empty(@href)][empty(ancestor::a | ancestor::html:a | ancestor::hotspot:class)]">
		<a class="img">
			<xsl:attribute name="href">
				<!-- the @src attribute must be processed (not copied!) because it may need to be prefixed with the img-src-prefix. -->
				<xsl:apply-templates select="@src"/>
			</xsl:attribute>
			<xsl:if test="empty(@title)">
				<!-- if the img does not specify a @title, provide a default text as the link's @title. -->
				<xsl:attribute name="title" select="'View Image'"/>
			</xsl:if>
			<img>
				<!-- this code is duplicated somewhere else, this should be fixed after fixing mantis issues 225 & 249. -->
				<xsl:apply-templates select="@*"/>
				<xsl:if test="empty(@alt) and exists(@title)">
					<!-- if there is no @alt attribute, but there is a @title attribute, reuse the @title attribute's value and create an @alt attribute. -->
					<xsl:attribute name="alt" select="@title"/>
				</xsl:if>
				<xsl:if test="empty(@alt) and empty(@title)">
					<!-- if there is no @alt attribute and there is no @title attribute, there is no good way to generate a meaningful @alt, so we just use @src. -->
					<xsl:attribute name="alt" select="@src"/>
				</xsl:if>
			</img>
		</a>
	</xsl:template>
	<!-- . . . . . . . . . . . . . . . . . . . . . . . . . . .-->
	<!--. . . . . . . . . . . . . . . . . . . . . . . . . . . -->
	<!-- '''''''''''''''''''''''''''''''''''''''''''''''''''' -->
	<!-- hotspot listings                                     -->
	<!-- .................................................... -->
	<!-- . . . . . . . . . . . . . . . . . . . . . . . . . . .-->
	<!--. . . . . . . . . . . . . . . . . . . . . . . . . . . -->
	<!-- the listing element includes text files (optionally only parts of them) and by default creates a link to the original file. -->
	<xsl:template match="listing">
		<xsl:param name="configuration" as="element(hotspot:configuration)" tunnel="yes"/>
		<xsl:variable name="filename" select="hotspot:prefixed-uri(., $configuration/paths/@listing, @src)"/>
		<xsl:variable name="fileuri" select="resolve-uri($filename, hotspot:base-uri(.))"/>
<!--		<xsl:variable name="listing">-->
			<pre class="{$configuration/listing/@class}{ if ( exists(@class) ) then concat(' ', @class) else '' }">
				<xsl:choose>
					<xsl:when test="if ( exists(@encoding) ) then unparsed-text-available($fileuri, @encoding) else unparsed-text-available($fileuri)">
						<xsl:choose>
							<xsl:when test="not(matches(@line, '\d+(\-\d+)?'))">
								<!-- tokenize the input file by lines and output them as newline-separated list of strings. -->
								<xsl:variable name="listing" select="string-join(tokenize( if ( exists(@encoding) ) then unparsed-text($fileuri, @encoding) else unparsed-text($fileuri), '\r?\n'), '&#xa;')"/>
								<xsl:value-of select="if (@tab eq 'retain' ) then $listing else replace($listing, '\t', ' ')"/>
							</xsl:when>
							<xsl:otherwise>
								<!-- tokenize the input file by lines, filter the specified lines by @lines, and output them as newline-separated list of strings. -->
								<xsl:variable name="listing" select="string-join(tokenize( if ( exists(@encoding) ) then unparsed-text($fileuri, @encoding) else unparsed-text($fileuri), '\r?\n')[(position() ge number(tokenize(current()/@line, '\-')[1])) and (position() le number(tokenize(current()/@line, '\-')[last()]))], '&#xa;')"/>
								<xsl:value-of select="if (@tab eq 'retain' ) then $listing else replace($listing, '\t', ' ')"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:when>
					<xsl:otherwise>
						<xsl:variable name="filenotfound" select="concat('Could not find listing file &quot;', $filename, '&quot;')"/>
						<xsl:value-of select="concat('[ ', $filenotfound, ' ]')"/>
						<xsl:call-template name="message">
							<xsl:with-param name="text" select="$filenotfound"/>
							<xsl:with-param name="level" select="'warning'"/>
						</xsl:call-template>
					</xsl:otherwise>
				</xsl:choose>
		<xsl:choose>
			<xsl:when test="exists(@href) and (@href eq '')">
				<!-- if there is an empty @href, do not generate a link. -->
			</xsl:when>
			<xsl:when test="exists(@href)">
				<!-- if the listing specifies a non-empty @href, a link to this URI is generated. -->
				<a href="{@href}" class="listing-sourceref" title="{ if ( exists(@title) ) then @title else @href }">
					<xsl:value-of select="if ( exists(@title) ) then @title else @href"/>
				</a>
			</xsl:when>
			<xsl:otherwise>
				<!-- if the listing specifies a valid line range, this is mapped to the correspondig text fragment identifier. -->
				<a href="{$filename}{ if ( matches(@line, '\d+(\-\d+)?') ) then concat('#line=', number(tokenize(@line, '\-')[1])-1, ',', number(tokenize(@line, '\-')[last()])) else '' }" class="listing-sourceref" title="{ if ( exists(@title) ) then @title else concat(@src, if ( matches(@line, '\d+(\-\d+)?') ) then concat(' (line ', @line, ')') else '' )}">
					<xsl:value-of select="if ( exists(@title) ) then @title else concat(@src, if ( matches(@line, '\d+(\-\d+)?') ) then concat(' (line ', @line, ')') else '' )"/>
				</a>
			</xsl:otherwise>
		</xsl:choose>
			</pre>
<!--		</xsl:variable>-->
<!--		<xsl:choose>-->
<!--			<xsl:when test="exists(@href) and (@href eq '')">-->
<!--				 if there is an empty @href, do not generate a link. -->
<!--				<xsl:copy-of select="$listing/html:pre"/>-->
<!--			</xsl:when>-->
<!--			<xsl:when test="exists(@href)">-->
<!--				 if the listing specifies a non-empty @href, a link to this URI is generated. -->
<!--				<a href="{@href}" class="listing-sourceref" title="{ if ( exists(@title) ) then @title else @href }">-->
<!--					<xsl:copy-of select="$listing/html:pre"/>-->
<!--				</a>-->
<!--			</xsl:when>-->
<!--			<xsl:otherwise>-->
<!--				 if the listing specifies a valid line range, this is mapped to the correspondig text fragment identifier. -->
<!--				<a href="{$filename}{ if ( matches(@line, '\d+(\-\d+)?') ) then concat('#line=', number(tokenize(@line, '\-')[1])-1, ',', number(tokenize(@line, '\-')[last()])) else '' }" class="listing-sourceref" title="{ if ( exists(@title) ) then @title else concat(@src, if ( matches(@line, '\d+(\-\d+)?') ) then concat(' (line ', @line, ')') else '' )}">-->
<!--					<xsl:copy-of select="$listing/html:pre"/>-->
<!--				</a>-->
<!--			</xsl:otherwise>-->
<!--		</xsl:choose>-->
	</xsl:template>
	<!-- . . . . . . . . . . . . . . . . . . . . . . . . . . .-->
	<!--. . . . . . . . . . . . . . . . . . . . . . . . . . . -->
	<!-- '''''''''''''''''''''''''''''''''''''''''''''''''''' -->
	<!-- hotspot / HTML links and hyperlinks                  -->
	<!-- .................................................... -->
	<!-- . . . . . . . . . . . . . . . . . . . . . . . . . . .-->
	<!--. . . . . . . . . . . . . . . . . . . . . . . . . . . -->
	<!-- links are mapped to html links, they may be used within or across presentations. -->
	<xsl:template match="link">
		<xsl:param name="configuration" as="element(hotspot:configuration)" tunnel="yes"/>
		<xsl:choose>
			<xsl:when test="empty(key('structureIdKey', @href))">
				<xsl:call-template name="message">
					<xsl:with-param name="text" select="concat('There is no ( presentation | part | slide ) with id=&quot;', @href, '&quot;')"/>
					<xsl:with-param name="level" select="'warning'"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="count(key('structureIdKey', @href)) > 1">
				<xsl:call-template name="message">
					<xsl:with-param name="text" select="concat('There is more than one ( presentation | part | slide ) with id=&quot;', @href, '&quot;')"/>
					<xsl:with-param name="level" select="'warning'"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:variable name="presentation-name" select="if ( ancestor::presentation is key('structureIdKey', @href)/ancestor-or-self::presentation ) then '' else hotspot:presentationlinkname(key('structureIdKey', @href)/ancestor-or-self::presentation, $configuration)"/>
				<a href="{ if ( string-length($presentation-name) eq 0 ) then '' else $presentation-name }{ if ( exists(key('structureIdKey', @href)/self::presentation) ) then '' else hotspot:id(key('structureIdKey', @href))}">
					<!-- if there the outlink-style specifies a class, add it to the @class attribute's values. -->
					<xsl:if test="$configuration/outlink/@mark = ('link', 'all') and matches($configuration/outlink/@style, 'class(.*)')">
						<xsl:attribute name="class" select="string-join((substring-before(substring-after($configuration/outlink/@style, 'class('), ')'), string(@class)), ' ')"/>
					</xsl:if>
					<!-- copy the style attributes, if present. -->
					<xsl:copy-of select="@style"/>
					<xsl:choose>
						<!-- if the link contains text, set the link target's title as the a element's tool tip. -->
						<xsl:when test="exists(node())">
							<xsl:attribute name="title" select="hotspot:title(key('structureIdKey', @href), 'long', 'string')"/>
						</xsl:when>
						<!-- if the link is empty but cross-presentation, set the target presentation's title as the a element's tool tip. -->
						<xsl:when test="not(ancestor::presentation is key('structureIdKey', @href)/ancestor-or-self::presentation)">
							<xsl:attribute name="title" select="hotspot:title(key('structureIdKey', @href)/ancestor-or-self::presentation, 'long', 'string')"/>
						</xsl:when>
					</xsl:choose>
					<!-- same test as after the link contents. -->
					<xsl:if test="(string-length($presentation-name) ne 0) and ($configuration/outlink/@mark = ('link', 'all')) and not(matches($configuration/outlink/@style, 'class(.*)'))">
						<xsl:copy-of select="substring-before($configuration/outlink/@style, '*')"/>
					</xsl:if>
					<xsl:choose>
						<xsl:when test="empty(node())">
							<xsl:apply-templates select="hotspot:title(key('structureIdKey', @href),'long', 'nodes')/node()"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:apply-templates/>
						</xsl:otherwise>
					</xsl:choose>
					<!-- same test as before the link contents. -->
					<xsl:if test="(string-length($presentation-name) ne 0) and ($configuration/outlink/@mark = ('link', 'all')) and not(matches($configuration/outlink/@style, 'class(.*)'))">
						<xsl:copy-of select="substring-after($configuration/outlink/@style, '*')"/>
					</xsl:if>
				</a>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!-- . . . . . . . . . . . . . . . . . . . . . . . . . . .-->
	<!--. . . . . . . . . . . . . . . . . . . . . . . . . . . -->
	<!-- links are mapped to html links, they may be used within or across presentations. -->
	<xsl:template match="a | html:a">
		<xsl:param name="configuration" as="element(hotspot:configuration)" tunnel="yes"/>
		<xsl:element name="a" namespace="http://www.w3.org/1999/xhtml">
			<!-- if there the outlink-style specifies a class and the link is absolute (roughly, the test is not 100% reliable), add it to the @class attribute's values using the outlink-style. -->
			<xsl:if test="$configuration/outlink/@mark = ('a', 'all') and ( starts-with(@href, 'http:') or starts-with(@href, 'https:') or starts-with(@href, 'ftp:') or starts-with(@href, 'mailto:') or starts-with(@href, 'file:') or not(contains(@href, ':')) )  and matches($configuration/outlink/@style, 'class(.*)') and empty(@class)">
				<xsl:attribute name="class" select="string-join((substring-before(substring-after($configuration/outlink/@style, 'class('), ')'), string(@class)), ' ')"/>
			</xsl:if>
			<!-- copy through all other attributes -->
			<xsl:apply-templates select="@*[local-name() ne 'class']"/>
			<!-- if the title attribute is not set by the user, add a title containing the link's target uri. -->
			<xsl:if test="empty(@title)">
				<xsl:attribute name="title" select="@href"/>
			</xsl:if>
			<!-- only insert the outlink-style text before and after the a element if the element contains non-whitespace text nodes, if required by the parameter setting, if either a relative uri or an explicit http link, and if the outlink-style is a text style. -->
			<xsl:if test="( normalize-space(string(.)) ne '' ) and $configuration/outlink/@mark = ('a', 'all') and ( starts-with(@href, 'http:') or not(contains(@href, ':'))  and not(matches($configuration/outlink/@style, 'class(.*)')))">
				<xsl:copy-of select="substring-before($configuration/outlink/@style, '*')"/>
			</xsl:if>
			<xsl:apply-templates select="node()"/>
			<xsl:if test="( normalize-space(string(.)) ne '' ) and $configuration/outlink/@mark = ('a', 'all') and ( starts-with(@href, 'http:') or not(contains(@href, ':'))  and not(matches($configuration/outlink/@style, 'class(.*)')))">
				<xsl:copy-of select="substring-after($configuration/outlink/@style, '*')"/>
			</xsl:if>
		</xsl:element>
	</xsl:template>
	<!-- if an element carries an @href attribute, the @href is moved to an a element which contains the original element. if there is a @title attribute, this is also moved. the list of element names in the template's match pattern is the list of html and hotspot elements which may carry an @href attribute. -->
	<xsl:template match="*[@href][not(local-name() = ('a', 'area', 'base', 'link', 'listing'))]">
		<a href="{@href}" class="{local-name()}">
			<xsl:if test="exists(@title)">
				<xsl:copy-of select="@title"/>
			</xsl:if>
			<xsl:element name="{local-name()}" namespace="http://www.w3.org/1999/xhtml">
				<!-- this code is duplicated somewhere else, this should be fixed after fixing mantis issues 225 & 249. -->
				<xsl:if test="local-name() eq 'img' and empty(@alt) and exists(@title)">
					<!-- if there is no @alt attribute, but there is a @title attribute, reuse the @title attribute's value and create an @alt attribute. -->
					<xsl:attribute name="alt" select="@title"/>
				</xsl:if>
				<xsl:if test="local-name() eq 'img' and empty(@alt) and empty(@title)">
					<!-- if there is no @alt attribute and there is no @title attribute, there is no good way to generate a meaningful @alt, so we just use @src. -->
					<xsl:attribute name="alt" select="@src"/>
				</xsl:if>
				<xsl:apply-templates select="@*[not(local-name() = ('href' , 'title'))] | node()"/>
			</xsl:element>
		</a>
	</xsl:template>
	<!-- . . . . . . . . . . . . . . . . . . . . . . . . . . .-->
	<!--. . . . . . . . . . . . . . . . . . . . . . . . . . . -->
	<!-- . . . . . . . . . . . . . . . . . . . . . . . . . . .-->
	<!-- '''''''''''''''''''''''''''''''''''''''''''''''''''' -->
	<!-- TOC and index elements                               -->
	<!-- .................................................... -->
	<!-- . . . . . . . . . . . . . . . . . . . . . . . . . . .-->
	<!--. . . . . . . . . . . . . . . . . . . . . . . . . . . -->
	<!-- generate files for each hotspot-level toc or index element that contains a @name -->
	<xsl:template match="hotspot/toc[exists(@name)] | hotspot/index[exists(@name)]">
		<xsl:call-template name="message">
			<xsl:with-param name="text" select="string(@name)"/>
		</xsl:call-template>
		<xsl:result-document format="toc" href="{@name}">
			<xsl:apply-templates select="node()">
				<xsl:with-param name="shortcut-stack" as="element(hotspot:shortcuts)+" tunnel="yes">
					<xsl:call-template name="push-shortcuts"/>
				</xsl:with-param>
			</xsl:apply-templates>
		</xsl:result-document>
	</xsl:template>
	<!-- . . . . . . . . . . . . . . . . . . . . . . . . . . .-->
	<!--. . . . . . . . . . . . . . . . . . . . . . . . . . . -->
	<!-- if embedded kilauea presentations are to be inserted, include and initialize the kilauea scripts and styles that are needed. -->
	<xsl:template match="toc/*/head[//embedded-presentation] | toc/*/html:head[//embedded-presentation]">
		<xsl:param name="configuration" as="element(hotspot:configuration)" tunnel="yes"/>
		<xsl:param name="layout" as="element(hotspot:layout)" tunnel="yes"/>
		<head>
			<!-- include the basic kilauea CSS styles which are functionally essential -->
			<link rel="stylesheet" type="text/css" media="screen, projection, print" href="{$kilauea-dir}kilauea.css"/>
			<!-- include all CSS stylesheet documents which are required by the layout -->
			<xsl:for-each select="$layout/css">
				<xsl:choose>
					<xsl:when test="@document">
						<link rel="stylesheet" type="text/css" media="{ if (@media) then @media else 'screen, projection'}" href="{ @document }"/>
					</xsl:when>
					<xsl:otherwise>
						<style type="text/css">
							<xsl:apply-templates select="node()"/>
						</style>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:for-each>
			<!-- include the kilauea javascript -->
			<script type="text/javascript" src="{$kilauea-dir}kilauea.js"/>
			<script type="text/javascript">
				<xsl:text>Kilauea.init({</xsl:text>
				<xsl:for-each select="/hotspot/presentation">
					<xsl:call-template name="kilauea-instance">
						<xsl:with-param name="instance">
							<xsl:value-of select="hotspot:presentationname(.)"/>
						</xsl:with-param>
						<xsl:with-param name="configuration" tunnel="yes" as="element(hotspot:configuration)">
							<xsl:call-template name="merge-configurations">
								<xsl:with-param name="existing" select="$configuration"/>
								<xsl:with-param name="refining" select="configuration"/>
							</xsl:call-template>
						</xsl:with-param>
					</xsl:call-template>
					<xsl:if test="position() ne last()">
						<xsl:text>, </xsl:text>
					</xsl:if>
				</xsl:for-each>
				<xsl:text>});</xsl:text>
			</script>
			<xsl:apply-templates select="node()"/>
		</head>
	</xsl:template>
	<!-- . . . . . . . . . . . . . . . . . . . . . . . . . . .-->
	<!--. . . . . . . . . . . . . . . . . . . . . . . . . . . -->
	<!-- for for-each-presentation elements in toc elements, loop over all presentation elements to generate the toc file. -->
	<xsl:template match="toc//for-each-presentation">
		<xsl:variable name="context" select="."/>
		<xsl:for-each select="/hotspot/presentation">
			<xsl:apply-templates select="$context/*">
				<xsl:with-param name="context" select="." tunnel="yes"/>
				<xsl:with-param name="shortcut-stack" as="element(hotspot:shortcuts)+" tunnel="yes">
					<xsl:call-template name="push-shortcuts"/>
				</xsl:with-param>
			</xsl:apply-templates>
		</xsl:for-each>
	</xsl:template>
	<!-- . . . . . . . . . . . . . . . . . . . . . . . . . . .-->
	<!--. . . . . . . . . . . . . . . . . . . . . . . . . . . -->
	<!-- for toc elements in toc elements, replace the toc element with the corresponding toc elements content from the presentation. -->
	<xsl:template match="toc//toc">
		<xsl:param name="context" tunnel="yes"/>
		<xsl:apply-templates select="$context/toc[@class eq current()/@class]/node()"/>
	</xsl:template>
	<!-- . . . . . . . . . . . . . . . . . . . . . . . . . . .-->
	<!--. . . . . . . . . . . . . . . . . . . . . . . . . . . -->
	<!-- this enables conditional processing in tocs, only generating the if-toc's content if the correspondig toc is present. -->
	<xsl:template match="toc//if-toc">
		<xsl:param name="context" tunnel="yes"/>
		<xsl:choose>
			<xsl:when test="exists($context/toc[@class eq current()/@class])">
				<xsl:apply-templates select="node()"/>
			</xsl:when>
		</xsl:choose>
	</xsl:template>
	<!-- . . . . . . . . . . . . . . . . . . . . . . . . . . .-->
	<!--. . . . . . . . . . . . . . . . . . . . . . . . . . . -->
	<!-- for toc elements in presentation content, replace the toc element with the corresponding toc elements content from the presentation. -->
	<xsl:template match="slide//toc | part//toc">
		<xsl:apply-templates select="ancestor::presentation/toc[@class eq current()/@class]/node()"/>
	</xsl:template>
	<!-- . . . . . . . . . . . . . . . . . . . . . . . . . . .-->
	<!--. . . . . . . . . . . . . . . . . . . . . . . . . . . -->
	<!-- when appearing in a toc or index element, the title group elements must be treated in a special way. -->
	<xsl:template match="toc//*[local-name() = $shortcuts][count(@* | node()) eq count(@level | @form)] | index//*[local-name() = $shortcuts][count(@* | node()) eq count(@level | @form)]">
		<xsl:param name="shortcut-stack" as="element(hotspot:shortcuts)+" tunnel="yes"/>
		<xsl:param name="position" tunnel="yes" select="1"/>
		<xsl:variable name="content" select="hotspot:expand-shortcut($shortcut-stack, local-name(), @form, 'nodes', @level, $position)"/>
		<!-- if a text-based form has been asked for, generate a string, otherwise copy the nodes of the result. -->
		<xsl:apply-templates select="$content"/>
	</xsl:template>
	<!-- . . . . . . . . . . . . . . . . . . . . . . . . . . .-->
	<!--. . . . . . . . . . . . . . . . . . . . . . . . . . . -->
	<!-- a presentation-link generates the link to the current presentation within a for-each-presentation structure (if the presentation is empty, it produces nothing). -->
	<xsl:template match="for-each-presentation//presentation-link">
		<xsl:param name="context" tunnel="yes"/>
		<xsl:param name="configuration" as="element(hotspot:configuration)" tunnel="yes"/>
		<!-- first, build the link URI -->
		<xsl:variable name="link-uri" select="concat( if ( exists(@prefix) and empty($context/ancestor-or-self::presentation/@external) ) then @prefix else '' , hotspot:presentationlinkname($context, $configuration))"/>
		<xsl:choose>
			<!-- do not produce a presentation-link if the presentation is empty and not external. -->
			<xsl:when test="empty($context/ancestor-or-self::presentation//(slide | part)) and empty($context/ancestor-or-self::presentation[@external])"/>
			<xsl:when test="exists(@element) and @element eq ''">
				<!-- if the presentation-link explicitly requests to not produce a link element, only the $link-uri is generated as text -->
				<xsl:value-of select="$link-uri"/>
			</xsl:when>
			<xsl:otherwise>
				<!-- if no @element or a non-empty @element has been specified, generate an element for the link. -->
				<xsl:element name="{ if ( exists(@element) ) then @element else 'a' }">
					<xsl:attribute name="{ if ( exists(@attribute) ) then @attribute else 'href' }" select="$link-uri"/>
					<!-- the contents of the presentation-link are processed as usual. -->
					<xsl:apply-templates select="@*[not(local-name() = ('element', 'attribute', 'prefix'))] | node()"/>
				</xsl:element>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!-- . . . . . . . . . . . . . . . . . . . . . . . . . . .-->
	<!--. . . . . . . . . . . . . . . . . . . . . . . . . . . -->
	<!-- the slides element generates the number of slides in a presentation within a toc element. -->
	<xsl:template match="toc//slides">
		<xsl:param name="context" tunnel="yes"/>
		<!-- get the expanded presentation fom $presentations and count the number of slide divs inside this presentation. -->
		<xsl:variable name="slides" select="count($context//*[local-name() = $slidish])"/>
		<!-- only produce a slide count if the presentation is not empty and not external. -->
		<xsl:if test="exists($context/ancestor-or-self::presentation[1]//(slide | part)) and not(exists($context/ancestor-or-self::presentation[1][@external]))">
			<!-- take the element content and replace the first asterisk with the slide count. -->
			<xsl:value-of select="replace(text(), '\*', string($slides))"/>
		</xsl:if>
	</xsl:template>
	<!-- . . . . . . . . . . . . . . . . . . . . . . . . . . .-->
	<!--. . . . . . . . . . . . . . . . . . . . . . . . . . . -->
	<!-- create embedded kilauea presentations -->
	<xsl:template match="for-each-presentation//embedded-presentation">
		<xsl:param name="context" tunnel="yes"/>
		<div id="{hotspot:presentationname($context)}">
			<xsl:attribute name="style" select="concat('width:', if (@width) then string(@width) else '300', 'px; height:', if (@height) then string(@height) else '230', 'px;')"/>
			<xsl:apply-templates select="@*[not(local-name() = ('width', 'height'))]"/>
			<xsl:if test="hotspot:lang(.) ne ''">
				<xsl:attribute name="lang" select="hotspot:lang(.)"/>
				<xsl:attribute name="xml:lang" select="hotspot:lang(.)"/>
			</xsl:if>
			<xsl:for-each select="$context">
				<xsl:call-template name="presentation">
					<xsl:with-param name="embedded" select="true()" tunnel="yes"/>
				</xsl:call-template>
			</xsl:for-each>
		</div>
	</xsl:template>
	<!-- . . . . . . . . . . . . . . . . . . . . . . . . . . .-->
	<!--. . . . . . . . . . . . . . . . . . . . . . . . . . . -->
	<!-- . . . . . . . . . . . . . . . . . . . . . . . . . . .-->
	<!-- '''''''''''''''''''''''''''''''''''''''''''''''''''' -->
	<!-- index elements                                       -->
	<!-- .................................................... -->
	<!-- . . . . . . . . . . . . . . . . . . . . . . . . . . .-->
	<!--. . . . . . . . . . . . . . . . . . . . . . . . . . . -->
	<!-- loop over all categories -->
	<xsl:template match="index//for-each-category">
		<xsl:variable name="context" select="."/>
		<xsl:for-each select="$index-elements">
			<xsl:apply-templates select="$context/node()">
				<xsl:with-param name="category" select="." tunnel="yes"/>
			</xsl:apply-templates>
		</xsl:for-each>
	</xsl:template>
	<!-- . . . . . . . . . . . . . . . . . . . . . . . . . . .-->
	<!--. . . . . . . . . . . . . . . . . . . . . . . . . . . -->
	<!-- print a category name -->
	<xsl:template match="index//category">
		<xsl:param name="category" tunnel="yes"/>
		<xsl:value-of select="$category"/>
	</xsl:template>
	<!-- . . . . . . . . . . . . . . . . . . . . . . . . . . .-->
	<!--. . . . . . . . . . . . . . . . . . . . . . . . . . . -->
	<!-- print a category description -->
	<xsl:template match="for-each-category//description">
		<xsl:param name="category" tunnel="yes"/>
		<xsl:apply-templates select="key('categoryKey', $category)/node()"/>
	</xsl:template>
	<!-- . . . . . . . . . . . . . . . . . . . . . . . . . . .-->
	<!--. . . . . . . . . . . . . . . . . . . . . . . . . . . -->
	<xsl:template match="for-each-category//for-each-term">
		<xsl:param name="category" tunnel="yes"/>
		<xsl:variable name="context" select="."/>
		<xsl:for-each-group select="key('indexKey', $category)" group-by="@index">
			<xsl:sort case-order="#default"/>
			<xsl:apply-templates select="$context/node()">
				<xsl:with-param name="term" select="@index" tunnel="yes"/>
				<xsl:with-param name="references" select="current-group()" tunnel="yes"/>
			</xsl:apply-templates>
		</xsl:for-each-group>
	</xsl:template>
	<!-- . . . . . . . . . . . . . . . . . . . . . . . . . . .-->
	<!--. . . . . . . . . . . . . . . . . . . . . . . . . . . -->
	<!-- loops over all terms, where no enclosing for-each-category is present -->
	<xsl:template match="for-each-term">
		<xsl:variable name="context" select="."/>
		<xsl:for-each-group select="key('indexKey', $index-elements)" group-by="@index">
			<xsl:sort case-order="#default"/>
			<xsl:apply-templates select="$context/node()">
				<xsl:with-param name="term" select="@index" tunnel="yes"/>
				<xsl:with-param name="references" select="current-group()" as="element()*" tunnel="yes"/>
				<!-- if the term is contained in more than one category, this value is inaccurate. however, note that within for-each-reference, the value is correct again. -->
				<xsl:with-param name="category" select="local-name()" tunnel="yes"/>
			</xsl:apply-templates>
		</xsl:for-each-group>
	</xsl:template>
	<!-- . . . . . . . . . . . . . . . . . . . . . . . . . . .-->
	<!--. . . . . . . . . . . . . . . . . . . . . . . . . . . -->
	<xsl:template match="term">
		<xsl:param name="term" tunnel="yes"/>
		<xsl:value-of select="$term"/>
	</xsl:template>
	<!-- . . . . . . . . . . . . . . . . . . . . . . . . . . .-->
	<!--. . . . . . . . . . . . . . . . . . . . . . . . . . . -->
	<!-- loop over all references within a category, where no for-each-term takes care of looping -->
	<xsl:template match="for-each-category[empty(.//for-each-term)]//for-each-reference">
		<xsl:param name="category" tunnel="yes"/>
		<xsl:variable name="context" select="."/>
		<xsl:for-each select="key('indexKey', $category)">
			<xsl:apply-templates select="$context/node()">
				<xsl:with-param name="reference" select="." tunnel="yes"/>
			</xsl:apply-templates>
		</xsl:for-each>
	</xsl:template>
	<!-- . . . . . . . . . . . . . . . . . . . . . . . . . . .-->
	<!--. . . . . . . . . . . . . . . . . . . . . . . . . . . -->
	<!-- loop over all references of a given term -->
	<xsl:template match="for-each-term//for-each-reference">
		<xsl:param name="references" as="element()*" tunnel="yes"/>
		<xsl:variable name="context" select="."/>
		<xsl:for-each select="$references">
			<xsl:apply-templates select="$context/node()">
				<xsl:with-param name="reference" select="." tunnel="yes"/>
				<xsl:with-param name="category" select="local-name()" tunnel="yes"/>
			</xsl:apply-templates>
		</xsl:for-each>
	</xsl:template>
	<!-- . . . . . . . . . . . . . . . . . . . . . . . . . . .-->
	<!--. . . . . . . . . . . . . . . . . . . . . . . . . . . -->
	<!-- loop over all references (without any enclosing for-each-category or for-each-term constructs. results in a document-order sequence of references) -->
	<xsl:template match="for-each-reference">
		<xsl:variable name="context" select="."/>
		<xsl:for-each select="$index-elements">
			<xsl:variable name="category" select="."/>
			<xsl:for-each select="$context/key('indexKey', $category)">
				<xsl:apply-templates select="$context/node()">
					<xsl:with-param name="reference" select="." tunnel="yes"/>
					<xsl:with-param name="category" select="$category" tunnel="yes"/>
				</xsl:apply-templates>
			</xsl:for-each>
		</xsl:for-each>
	</xsl:template>
	<!-- . . . . . . . . . . . . . . . . . . . . . . . . . . .-->
	<!--. . . . . . . . . . . . . . . . . . . . . . . . . . . -->
	<!-- print a category reference. returns a hyperlink to the reference location -->
	<xsl:template match="for-each-reference//reference">
		<xsl:param name="category" tunnel="yes"/>
		<xsl:param name="reference" tunnel="yes"/>
		<xsl:param name="configuration" as="element(hotspot:configuration)" tunnel="yes"/>
		<xsl:param name="shortcut-stack" as="element(hotspot:shortcuts)+" tunnel="yes"/>
		<a href="{hotspot:presentationlinkname($reference, $configuration)}#{generate-id($reference)}">
			<xsl:choose>
				<xsl:when test="empty(node())">
					<xsl:value-of select="hotspot:expand-shortcut(hotspot:push-shortcuts($shortcut-stack, $reference/ancestor::presentation[1]), 'title', 'short')"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:apply-templates select="node()"/>
				</xsl:otherwise>
			</xsl:choose>
		</a>
	</xsl:template>
	<!-- replace the wildcard character '*' by the presentation's name -->
	<xsl:template match="reference//text()">
		<xsl:param name="reference" tunnel="yes"/>
		<xsl:param name="configuration" as="element(hotspot:configuration)" tunnel="yes"/>
		<xsl:param name="shortcut-stack" as="element(hotspot:shortcuts)+" tunnel="yes"/>
		<xsl:value-of select="replace(., '\*', hotspot:expand-shortcut(hotspot:push-shortcuts($shortcut-stack, $reference/ancestor::presentation[1]), 'title', 'short'))"/>
	</xsl:template>
	<!-- . . . . . . . . . . . . . . . . . . . . . . . . . . .-->
	<!--. . . . . . . . . . . . . . . . . . . . . . . . . . . -->
	<!-- print the slide number a category reference occurs in -->
	<xsl:template match="for-each-reference//slide">
		<xsl:param name="reference" tunnel="yes"/>
		<xsl:value-of select="hotspot:slidenumber($reference)"/>
	</xsl:template>
	<!-- . . . . . . . . . . . . . . . . . . . . . . . . . . .-->
	<!--. . . . . . . . . . . . . . . . . . . . . . . . . . . -->
	<xsl:template match="for-each-reference//term">
		<xsl:param name="reference" tunnel="yes"/>
		<xsl:apply-templates select="$reference/node()"/>
	</xsl:template>
	<!-- . . . . . . . . . . . . . . . . . . . . . . . . . . .-->
	<!--. . . . . . . . . . . . . . . . . . . . . . . . . . . -->
	<!-- print context from around a term reference -->
	<!-- this is a shortcut for convenience, and its results are equivalent to calling "...<context-before/><em><term/></em><context-after/>..." -->
	<xsl:template match="for-each-reference//context">
		<xsl:param name="reference" tunnel="yes"/>
		<xsl:param name="category" tunnel="yes"/>
		<!-- 7 nodes around the reference seem to be a reasonable amount of information -->
		<xsl:text>...</xsl:text>
		<xsl:value-of select="hotspot:text($reference/preceding::node()[position() lt 7])"/>
		<em class="{key('categoryKey', $category)/@class}"><xsl:apply-templates select="$reference/node()"/></em>
		<xsl:value-of select="hotspot:text($reference/following::node()[position() lt 7])"/>
		<xsl:text>...</xsl:text>
	</xsl:template>
	<!-- . . . . . . . . . . . . . . . . . . . . . . . . . . .-->
	<!--. . . . . . . . . . . . . . . . . . . . . . . . . . . -->
	<!-- print context before a term reference -->
	<xsl:template match="for-each-reference//context-before">
		<xsl:param name="reference" tunnel="yes"/>
		<!-- 7 nodes around the reference seem to be a reasonable amount of information -->
		<xsl:value-of select="hotspot:text($reference/preceding::node()[position() lt 7])"/>
	</xsl:template>
	<!-- . . . . . . . . . . . . . . . . . . . . . . . . . . .-->
	<!--. . . . . . . . . . . . . . . . . . . . . . . . . . . -->
	<!-- print context after a term reference -->
	<xsl:template match="for-each-reference//context-after">
		<xsl:param name="reference" tunnel="yes"/>
		<xsl:value-of select="hotspot:text($reference/following::node()[position() lt 7])"/>
	</xsl:template>
	<!-- . . . . . . . . . . . . . . . . . . . . . . . . . . .-->
	<!--. . . . . . . . . . . . . . . . . . . . . . . . . . . -->
	<!-- . . . . . . . . . . . . . . . . . . . . . . . . . . .-->
	<!-- '''''''''''''''''''''''''''''''''''''''''''''''''''' -->
	<!-- hotspot counters                                     -->
	<!-- .................................................... -->
	<!-- . . . . . . . . . . . . . . . . . . . . . . . . . . .-->
	<!--. . . . . . . . . . . . . . . . . . . . . . . . . . . -->
	<!-- the counter element is used for setting counters (@id) as well as for referencing them (@ref). -->
	<xsl:template match="presentation//counter">
		<xsl:param name="configuration" as="element(hotspot:configuration)" tunnel="yes"/>
		<xsl:choose>
			<xsl:when test="exists(@ref) and exists(@id)">
				<xsl:call-template name="message">
					<xsl:with-param name="text" select="'@ref and @id are not allowed on the same &lt;counter>'"/>
					<xsl:with-param name="level" select="'error'"/>
				</xsl:call-template>
				<xsl:text>???</xsl:text>
			</xsl:when>
			<xsl:when test="count(key('counterKey', concat(@id, @ref))[@name eq current()/@name]) > 1">
				<!-- one of @id/@ref is empty, so the concat results in being either @id or @ref, whatever is present. -->
				<xsl:call-template name="message">
					<xsl:with-param name="text" select="concat('there is more than one &lt;counter name=&quot;', @name, '&quot; id=&quot;', concat(@id, @ref), '&quot;>')"/>
					<xsl:with-param name="level" select="'error'"/>
				</xsl:call-template>
				<xsl:text>???</xsl:text>
			</xsl:when>
			<xsl:when test="empty(@ref)">
				<!-- this branch handles counter/@id as well as counters without an @id (which cannot be referenced but should be numbered anyway). -->
				<span>
					<xsl:apply-templates select="@title | @id"/>
					<xsl:choose>
						<xsl:when test="exists(node()) and exists(@title)">
							<xsl:call-template name="message">
								<xsl:with-param name="text" select="'a &lt;counter> may have a @title or content, but not both'"/>
								<xsl:with-param name="level" select="'error'"/>
							</xsl:call-template>
							<xsl:text>???</xsl:text>
						</xsl:when>
						<xsl:when test="exists(node())">
							<xsl:value-of select="hotspot:print-counter(., @form, $configuration)"/>
							<xsl:value-of select="$configuration/counter/@separator"/>
							<xsl:copy-of select="node()"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="hotspot:print-counter(., @form, $configuration)"/>
						</xsl:otherwise>
					</xsl:choose>
				</span>
			</xsl:when>
			<xsl:when test="exists(@ref)">
				<xsl:variable name="ref-target" select="key('counterKey', @ref)[@name eq current()/@name]"/>
				<!-- find out whether the counter's @id has been set in another presentation.  -->
				<xsl:variable name="presentation-name" select="if ( ancestor::presentation is $ref-target/ancestor::presentation ) then '' else hotspot:presentationlinkname(key('counterKey', @ref)[@name eq current()/@name]/ancestor::presentation, $configuration)"/>
				<a href="{ if ( string-length($presentation-name) eq 0 ) then '' else $presentation-name }{ hotspot:id($ref-target)}">
					<xsl:if test="exists($ref-target/node() | $ref-target/@title)">
						<xsl:attribute name="title" select="if ( exists($ref-target/node()) ) then string($ref-target/node()) else $ref-target/@title"/>
					</xsl:if>
					<xsl:value-of select="hotspot:print-counter(., @form, $configuration)"/>
				</a>
			</xsl:when>
		</xsl:choose>
	</xsl:template>
	<!-- . . . . . . . . . . . . . . . . . . . . . . . . . . .-->
	<!--. . . . . . . . . . . . . . . . . . . . . . . . . . . -->
	<!-- this function outputs a counter value in the specified format, the context must be set to a counter element. -->
	<xsl:function name="hotspot:print-counter">
		<xsl:param name="context"/>
		<xsl:param name="form"/>
		<xsl:param name="configuration" as="element(hotspot:configuration)"/>
		<xsl:choose>
			<xsl:when test="empty($context/@ref)">
				<!-- this branch handles counter/@id as well as counters without an @id (whic cannot be referenced but should be numbered anyway). -->
				<xsl:value-of select="if ( not($form eq 'short') and $configuration/counter/@format eq 'full' ) then concat(count($context/preceding::presentation) + 1, '.') else ''"/>
				<xsl:value-of select="count($context/preceding::counter[empty(@ref)][string(@name) eq string($context/@name)][ancestor::presentation is $context/ancestor::presentation]) + 1"/>
			</xsl:when>
			<xsl:when test="exists($context/@ref)">
				<xsl:value-of select="hotspot:print-counter(key('counterKey', $context/@ref, $context/ancestor::node()[last()])[string(@name) eq string($context/@name)], $form, $configuration)"/>
			</xsl:when>
		</xsl:choose>
	</xsl:function>
	<!-- TODO: single out the counter functionalities required by formulatex -->
	<!-- . . . . . . . . . . . . . . . . . . . . . . . . . . .-->
	<!--. . . . . . . . . . . . . . . . . . . . . . . . . . . -->
	<!-- . . . . . . . . . . . . . . . . . . . . . . . . . . .-->
	<!--. . . . . . . . . . . . . . . . . . . . . . . . . . . -->
	<!-- . . . . . . . . . . . . . . . . . . . . . . . . . . .-->
	<!--. . . . . . . . . . . . . . . . . . . . . . . . . . . -->
	<!-- '''''''''''''''''''''''''''''''''''''''''''''''''''' -->
	<!-- configuration utilities                              -->
	<!-- .................................................... -->
	<xsl:template match="configuration" mode="merge">
		<xsl:param name="configuration" as="element(hotspot:configuration)?" tunnel="yes"/>
		<xsl:call-template name="merge-configurations">
			<xsl:with-param name="existing" select="$configuration"/>
			<xsl:with-param name="refining" select=".[@mode eq $configuration/@mode or empty(@mode) and empty($configuration/@mode)]"/>
		</xsl:call-template>
	</xsl:template>
	<!-- . . . . . . . . . . . . . . . . . . . . . . . . . . .-->
	<!--. . . . . . . . . . . . . . . . . . . . . . . . . . . -->
	<xsl:template name="merge-configurations" as="element(hotspot:configuration)">
		<xsl:param name="existing" as="element(hotspot:configuration)?"/>
		<xsl:param name="refining" as="element(hotspot:configuration)*"/>
		<!-- todo: filter the $refining ones using [@mode eq $configuration/@mode or empty(@mode) and empty($configuration/@mode)] -->
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
		<xsl:value-of select="resolve-uri(concat($layout-dir, $layout, '/layout.xml'), $base-uri)"/>
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
		<xsl:attribute name="{local-name()}" select="resolve-uri(., concat($layout-dir, $current-layout, '/layout.xml'))"/>
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
		<xsl:param name="append" as="xs:string?"/>
		<xsl:variable name="classes" as="xs:string*" select="distinct-values((tokenize(., '\s+'), tokenize($merge-with, '\s+'), tokenize($append, '\s+')))"/>
		<xsl:attribute name="class" select="string-join($classes, ' ')"/>
	</xsl:template>
	<!-- . . . . . . . . . . . . . . . . . . . . . . . . . . .-->
	<!--. . . . . . . . . . . . . . . . . . . . . . . . . . . -->
	<!-- '''''''''''''''''''''''''''''''''''''''''''''''''''' -->
	<!-- shorcuts-stack-pushing / -manipulating templates     -->
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
	<xsl:function name="hotspot:push-shortcuts" as="element(hotspot:shortcuts)+">
		<xsl:param name="shortcut-stack" as="element(hotspot:shortcuts)*"/>
		<xsl:param name="context" as="element()"/>
		<!-- merely a wrapper function to the above named template -->
		<xsl:for-each select="$context">
			<xsl:call-template name="push-shortcuts">
				<xsl:with-param name="shortcut-stack" as="element(hotspot:shortcuts)*" select="$shortcut-stack"/>
			</xsl:call-template>
		</xsl:for-each>
	</xsl:function>
	<!-- . . . . . . . . . . . . . . . . . . . . . . . . . . .-->
	<!--. . . . . . . . . . . . . . . . . . . . . . . . . . . -->
	<!-- '''''''''''''''''''''''''''''''''''''''''''''''''''' -->
	<!-- utility template for informative messages            -->
	<!--                                                      -->
	<!-- template parameters:                                 -->
	<!-- - text:  a sequence of xs:string*. the strings are   -->
	<!--          printed on separate lines.                  -->
	<!-- - level: the level of respective importance.         -->
	<!-- - message-indent: a tunnel parameter with the        -->
	<!--          obvious meaning.                            -->
	<!--                                                      -->
	<!-- messages may have different levels of importance,    -->
	<!-- which can be selected via the XSLT parameters        -->
	<!-- $message-level or $messages (for xslidy compliance): -->
	<!--                                                      -->
	<!-- * 'error': print message always, and prepend a '!! ' -->
	<!--              (this eases regexing of the output etc) -->
	<!-- * 'warning': print message only, if $message-level   -->
	<!--              is set to 'warning' or lower, and       -->
	<!--              prepend a '** '                         -->
	<!-- * 'informative': print only, if $message-level is    -->
	<!--              set to 'informative' or lower           -->
	<!-- * 'debug': print message only, if $message-level is  -->
	<!--              set to 'debug' or lower                 -->
	<!-- * default: print the message always, and plainly.    -->
	<!--              use scarcely! in fact, only the names   -->
	<!--              of the documents that are generated     -->
	<!--              should be output this way.              -->
	<!--                                                      -->
	<!-- Developer policies:                                  -->
	<!--                                                      -->
	<!-- error: real errors, which affect the outcome of the  -->
	<!--    transformation in a substantial way, possibly     -->
	<!--    connected to expected fatal XSLT errors.          -->
	<!-- warning: errors which will affect the presentations' -->
	<!--    functionality (e.g., linking behaviour), content  -->
	<!--    (e.g., included content), and consistency (e.g.,  -->
	<!--    of the TOCs).                                     -->
	<!-- informative: almost everything else.                 -->
	<!-- debug: only developer-relevant information, which    -->
	<!--    presumably is only temporarily needed.            -->
	<!-- .................................................... -->
	<xsl:template name="message">
		<xsl:param name="text" as="xs:string*"/>
		<!-- message level may be 'warning' or 'error' (default). -->
		<xsl:param name="level" as="xs:string?"/>
		<xsl:param name="message-indent" as="xs:string" select="''" tunnel="yes"/>
		<xsl:choose>
			<!-- always print errors -->
			<xsl:when test="$level eq 'error'">
				<xsl:message select="concat('!! ', string-join($text, '&#xA;!! '))"/>
			</xsl:when>
			<!-- print warnings, if $message-level >= 'warnings' -->
			<xsl:when test="$level eq 'warning'">
				<xsl:if test="$message-level = ('warnings', 'warning', 'informatives', 'informative', 'debugs', 'debug')">
					<xsl:message select="concat('** ', string-join($text, '&#xA;** '))"/>
				</xsl:if>
			</xsl:when>
			<!-- print informative messages, if $message-level >= 'informatives' -->
			<xsl:when test="$level eq 'informative'">
				<xsl:if test="$message-level = ('informatives', 'informative', 'debugs', 'debug')">
					<xsl:message select="concat($message-indent, '   ', string-join($text, concat('&#xA;   ', $message-indent)))"/>
				</xsl:if>
			</xsl:when>
			<!-- print debug messages, if $message-level >= 'debugs' -->
			<xsl:when test="$level eq 'debug'">
				<xsl:if test="$message-level = ('debugs', 'debug')">
					<xsl:message select="string-join($text, '&#xA;')"/>
				</xsl:if>
			</xsl:when>
			<!-- default: print the message plainly -->
			<xsl:otherwise>
				<xsl:message select="$text"/>
			</xsl:otherwise>
		</xsl:choose>
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
	<!--  -->
	<xsl:function name="hotspot:text" as="xs:string">
		<xsl:param name="context"/>
		<xsl:value-of select="string-join($context/descendant-or-self::text(),'')"/>
	</xsl:function>
	<!-- . . . . . . . . . . . . . . . . . . . . . . . . . . .-->
	<!--. . . . . . . . . . . . . . . . . . . . . . . . . . . -->
	<!-- returns the name of the presentation based on the context and the position. if there is a @name, take the @name, if not, take the @id, if there is no @id, generate a name. -->
	<xsl:function name="hotspot:presentationname">
		<xsl:param name="presentation"/>
		<xsl:value-of select="if ( exists($presentation/@name) ) then $presentation/@name else if ( exists($presentation/@id) ) then $presentation/@id else concat('presentation-', count($presentation/preceding::presentation)+1)"/>
	</xsl:function>
	<!-- . . . . . . . . . . . . . . . . . . . . . . . . . . .-->
	<!--. . . . . . . . . . . . . . . . . . . . . . . . . . . -->
	<!-- returns the name of the presentation based on the context and the position. -->
	<xsl:function name="hotspot:presentationfilename">
		<xsl:param name="context"/>
		<xsl:param name="configuration" as="element(hotspot:configuration)"/>
		<xsl:value-of select="concat(hotspot:presentationname($context/ancestor-or-self::presentation[1]), if ($configuration/extension/@file eq '' or starts-with($configuration/extension/@file, '.') ) then '' else '.', $configuration/extension/@file)"/>
	</xsl:function>
	<!-- . . . . . . . . . . . . . . . . . . . . . . . . . . .-->
	<!--. . . . . . . . . . . . . . . . . . . . . . . . . . . -->
	<!-- returns the name of the presentation based on the context and the position. -->
	<xsl:function name="hotspot:presentationlinkname">
		<xsl:param name="context"/>
		<xsl:param name="configuration" as="element(hotspot:configuration)"/>
		<xsl:variable name="presentation" select="$context/ancestor-or-self::presentation[1]"/>
		<!-- if no @external attribute is present for the presentation, the linkname is computed; otherwise it is the value of the @external attribute. -->
		<xsl:value-of select="if ( empty($presentation/@external) ) then concat(hotspot:presentationname($presentation), if ($configuration/extension/@link eq '' or starts-with($configuration/extension/@link, '.') ) then '' else '.', $configuration/extension/@link) else $presentation/@external"/>
	</xsl:function>
	<!-- . . . . . . . . . . . . . . . . . . . . . . . . . . .-->
	<!--. . . . . . . . . . . . . . . . . . . . . . . . . . . -->
	<!-- return the closest xml:lang attribute value (if valid) or an empty string. -->
	<xsl:function name="hotspot:lang">
		<xsl:param name="context"/>
		<xsl:variable name="lang" select="$context/ancestor-or-self::*[exists(@xml:lang)][1]/@xml:lang"/>
		<!-- the weird regex is the xs:language pattern from the schema for schemas. -->
		<xsl:value-of select="if ( matches($lang, '^[a-zA-Z]{1,8}(-[a-zA-Z0-9]{1,8})*$') ) then $lang else ''"/>
	</xsl:function>
	<!-- . . . . . . . . . . . . . . . . . . . . . . . . . . .-->
	<!--. . . . . . . . . . . . . . . . . . . . . . . . . . . -->
	<xsl:function name="hotspot:base-uri" as="xs:anyURI">
		<xsl:param name="node"/>
		<xsl:choose>
			<xsl:when test="$node/ancestor-or-self::*[@include]">
				<xsl:value-of select="$node/ancestor-or-self::*/@include cast as xs:anyURI"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$base-uri"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:function>
	<!-- . . . . . . . . . . . . . . . . . . . . . . . . . . .-->
	<!--. . . . . . . . . . . . . . . . . . . . . . . . . . . -->
	<!-- '''''''''''''''''''''''''''''''''''''''''''''''''''' -->
	<!-- expand the shortcuts (in a given context)            -->
	<!-- .................................................... -->
	<!-- . . . . . . . . . . . . . . . . . . . . . . . . . . .-->
	<!--. . . . . . . . . . . . . . . . . . . . . . . . . . . -->
	<!-- . . . . . . . . . . . . . . . . . . . . . . . . . . .-->
	<!-- '''''''''''''''''''''''''''''''''''''''''''''''''''' -->
	<!-- hotspot:expand-shortcut(data, name, [form, [value,   -->
	<!--                        [level, [position]]]])        -->
	<!-- data:     the stack of current shortcut data         -->
	<!-- name:     the name of the shortcut that is to be     -->
	<!--           expanded, e.g., 'title'                    -->
	<!-- form:     either 'short' or 'long' (an attribute can -->
	<!--           also be passed, or even an empty sequence, -->
	<!--           which is interpreted as 'long'). note that -->
	<!--           'short' implies value='string'             -->
	<!-- value:    either 'nodes' or 'string'; defaults to    -->
	<!--           'string'                                   -->
	<!-- level:    either 'hotspot', 'presentation', 'part',  -->
	<!--           'slide', or simply 'current', which is the -->
	<!--           default value                              -->
	<!-- position: either an integer or 'last' or 'all';      -->
	<!--           defaults to 1                              -->
	<!-- .................................................... -->
	<!-- these are only polymorphic aliases, so to speak      -->
	<xsl:function name="hotspot:expand-shortcut">
		<xsl:param name="data" as="element(hotspot:shortcuts)+"/>
		<xsl:param name="name" as="xs:string"/>
		<xsl:sequence select="hotspot:expand-shortcut($data, $name, 'long', 'string', 'current', 1)"/>
	</xsl:function>
	<xsl:function name="hotspot:expand-shortcut">
		<xsl:param name="data" as="element(hotspot:shortcuts)+"/>
		<xsl:param name="name" as="xs:string"/>
		<xsl:param name="form"/>
		<xsl:sequence select="hotspot:expand-shortcut($data, $name, $form, 'string', 'current', 1)"/>
	</xsl:function>
	<xsl:function name="hotspot:expand-shortcut">
		<xsl:param name="data" as="element(hotspot:shortcuts)+"/>
		<xsl:param name="name" as="xs:string"/>
		<xsl:param name="form"/>
		<xsl:param name="value" as="xs:string"/>
		<xsl:sequence select="hotspot:expand-shortcut($data, $name, $form, $value, 'current', 1)"/>
	</xsl:function>
	<xsl:function name="hotspot:expand-shortcut">
		<xsl:param name="data" as="element(hotspot:shortcuts)+"/>
		<xsl:param name="name" as="xs:string"/>
		<xsl:param name="form"/>
		<xsl:param name="value" as="xs:string"/>
		<xsl:param name="level"/>
		<xsl:sequence select="hotspot:expand-shortcut($data, $name, $form, $value, $level, 1)"/>
	</xsl:function>
	<xsl:function name="hotspot:expand-shortcut">
		<!-- data: the stack of current shortcut data -->
		<xsl:param name="data" as="element(hotspot:shortcuts)+"/>
		<!-- the name of the shortcut that is to be expanded, e.g., 'title' -->
		<xsl:param name="name" as="xs:string"/>
		<!-- form: either 'short' or 'long' (an attribute can also be passed, or even an empty sequence, which is interpreted as 'long') -->
		<xsl:param name="form"/>
		<!-- value: either 'nodes' or 'string', default is 'string' -->
		<xsl:param name="value" as="xs:string"/>
		<!-- level: either 'hotspot', 'presentation', 'part', or 'slide' - or simply 'current' -->
		<xsl:param name="level"/>
		<!-- position: either a number, 'all', or 'last' -->
		<xsl:param name="position"/>
		<!-- fetch the adequate entry from the shortcut-stack -->
		<xsl:variable name="content" as="element()*">
			<xsl:sequence select="$data[empty($level) or $level eq 'current' or @level eq $level][last()]/*[local-name() eq $name][if ($position castable as xs:decimal) then $position else if ($position eq 'all') then true() else if ($position eq 'last') then last() else 1]"/>
		</xsl:variable>
		<!-- retrieve the correct form and transform the results to strings, if desired -->
		<xsl:for-each select="$content">
			<xsl:sequence select="if ( ($form eq 'short') and exists(@short) ) then string(@short) else if ( $value eq 'nodes' ) then node() else normalize-space(hotspot:text(.))"/>
		</xsl:for-each>
	</xsl:function>
	<!-- . . . . . . . . . . . . . . . . . . . . . . . . . . .-->
	<!--. . . . . . . . . . . . . . . . . . . . . . . . . . . -->
	<!-- . . . . . . . . . . . . . . . . . . . . . . . . . . .-->
	<!--. . . . . . . . . . . . . . . . . . . . . . . . . . . -->
	<xsl:function name="hotspot:title">
		<xsl:param name="context"/>
		<xsl:param name="form"/>
		<xsl:param name="value"/>
		<xsl:variable name="title" as="element(hotspot:title)?">
			<xsl:sequence select="$context/ancestor-or-self::*[title][1]/title[last()]"/>
		</xsl:variable>
		<xsl:for-each select="$title">
			<xsl:copy-of select="if ( ($form eq 'short') and exists(@short) ) then string(@short) else if ( $value eq 'nodes' ) then . else normalize-space(hotspot:text(.))"/>
		</xsl:for-each>
	</xsl:function>
	<!-- . . . . . . . . . . . . . . . . . . . . . . . . . . .-->
	<!--. . . . . . . . . . . . . . . . . . . . . . . . . . . -->
	<!-- return a prefixed uri if the uri contains no slash and the prefix is not empty or '.' (the default). -->
	<xsl:function name="hotspot:prefixed-uri">
		<xsl:param name="context"/>
		<xsl:param name="prefix"/>
		<xsl:param name="uri"/>
		<xsl:variable name="return">
			<xsl:if test="not(contains($uri, '/')) and not($prefix = ('', '.'))">
				<xsl:value-of select="replace($prefix, '\*', hotspot:presentationname($context/ancestor-or-self::presentation[1]))"/>
				<xsl:if test="not(ends-with($prefix, '/'))">/</xsl:if>
			</xsl:if>
			<xsl:value-of select="$uri"/>
		</xsl:variable>
		<xsl:sequence select="string($return)"/>
	</xsl:function>
	<!-- . . . . . . . . . . . . . . . . . . . . . . . . . . .-->
	<!--. . . . . . . . . . . . . . . . . . . . . . . . . . . -->
	<!-- '''''''''''''''''''''''''''''''''''''''''''''''''''' -->
	<!-- get a slide's (or part's) anchor name / ID           -->
	<!-- .................................................... -->
	<xsl:function name="hotspot:id" as="xs:string">
		<xsl:param name="target" as="element()?"/>
		<xsl:choose>
			<xsl:when test="exists($target)">
				<xsl:choose>
					<xsl:when test="exists($target/@id)">
						<xsl:value-of select="concat('#', string($target/@id))"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="concat('#(', hotspot:slidenumber($target), ')')"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="message">
					<xsl:with-param name="text" select="'A hotspot:id for an undefined target has been requested. Hotspot created a link to the title slide, which is probably not want you wanted.'"/>
					<xsl:with-param name="level" select="'warning'"/>
				</xsl:call-template>
				<xsl:text>#(1)</xsl:text>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:function>
	<xsl:function name="hotspot:slidenumber" as="xs:decimal">
		<xsl:param name="target" as="element()?"/>
		<xsl:value-of select="count($target/preceding::*[local-name() = $slidish][ancestor::presentation[1] is $target/ancestor::presentation[1]]) + 1"/>
	</xsl:function>
	<!-- . . . . . . . . . . . . . . . . . . . . . . . . . . .-->
	<!--. . . . . . . . . . . . . . . . . . . . . . . . . . . -->
	<!-- '''''''''''''''''''''''''''''''''''''''''''''''''''' -->
	<!-- kilauea JS-specific templates and utilities          -->
	<!-- .................................................... -->
	<xsl:template name="kilauea-init">
		<xsl:param name="layout" as="element(hotspot:layout)" tunnel="yes"/>
		<xsl:param name="configuration" as="element(hotspot:configuration)" tunnel="yes"/>
		<script type="text/javascript">
			<xsl:text>Kilauea.init({</xsl:text>
				<xsl:call-template name="kilauea-instance">
					<xsl:with-param name="instance" select="'#body'"/>
				</xsl:call-template>
			<xsl:text>});</xsl:text>
		</script>
	</xsl:template>
	<xsl:template name="kilauea-instance">
		<xsl:param name="layout" as="element(hotspot:layout)" tunnel="yes"/>
		<xsl:param name="configuration" as="element(hotspot:configuration)" tunnel="yes"/>
		<xsl:param name="instance" as="xs:string"/>
		<!-- a sequence of unique plugin names -->
		<xsl:variable name="plugin-names" as="xs:string*">
			<xsl:sequence select="distinct-values($configuration/kilauea:kilauea/kilauea:plugins/*/local-name())"/>
		</xsl:variable>
		<xsl:value-of select="kilauea:param($instance)"/>
		<xsl:text>: {titleSeparator: </xsl:text>
			<xsl:value-of select="kilauea:param($configuration/misc/@title-separator)"/>
			<xsl:if test="exists($configuration/misc/@static-title)">
				<xsl:text>, title: </xsl:text>
				<xsl:value-of select="kilauea:param($configuration/misc/@static-title)"/>
			</xsl:if>
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
		<xsl:text>}}</xsl:text>
	</xsl:template>
	<!-- . . . . . . . . . . . . . . . . . . . . . . . . . . .-->
	<!--. . . . . . . . . . . . . . . . . . . . . . . . . . . -->
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
	<!-- . . . . . . . . . . . . . . . . . . . . . . . . . . .-->
	<!--. . . . . . . . . . . . . . . . . . . . . . . . . . . -->
	<!-- . . . . . . . . . . . . . . . . . . . . . . . . . . .-->
	<!--. . . . . . . . . . . . . . . . . . . . . . . . . . . -->
	<!-- . . . . . . . . . . . . . . . . . . . . . . . . . . .-->
	<!--. . . . . . . . . . . . . . . . . . . . . . . . . . . -->
	<!-- . . . . . . . . . . . . . . . . . . . . . . . . . . .-->
	<!--. . . . . . . . . . . . . . . . . . . . . . . . . . . -->
	<!-- . . . . . . . . . . . . . . . . . . . . . . . . . . .-->
	<!--. . . . . . . . . . . . . . . . . . . . . . . . . . . -->
	<!-- . . . . . . . . . . . . . . . . . . . . . . . . . . .-->
	<!--. . . . . . . . . . . . . . . . . . . . . . . . . . . -->
	<!-- . . . . . . . . . . . . . . . . . . . . . . . . . . .-->
	<!--. . . . . . . . . . . . . . . . . . . . . . . . . . . -->
	<!-- . . . . . . . . . . . . . . . . . . . . . . . . . . .-->
	<!--. . . . . . . . . . . . . . . . . . . . . . . . . . . -->
	<!-- . . . . . . . . . . . . . . . . . . . . . . . . . . .-->
	<!--. . . . . . . . . . . . . . . . . . . . . . . . . . . -->
</xsl:stylesheet>