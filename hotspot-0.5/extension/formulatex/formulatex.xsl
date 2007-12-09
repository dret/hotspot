<?xml version="1.0" encoding="UTF-8"?>
<!-- $Id$ -->
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns="http://www.w3.org/1999/xhtml" xmlns:html="http://www.w3.org/1999/xhtml" xmlns:hotspot="http://dret.net/xmlns/hotspot/1" xmlns:kilauea="http://xmlns.sharpeleven.net/kilauea" xpath-default-namespace="http://dret.net/xmlns/hotspot/1" exclude-result-prefixes="xs hotspot html kilauea">
	<!-- . . . . . . . . . . . . . . . . . . . . . . . . . . .-->
	<!--. . . . . . . . . . . . . . . . . . . . . . . . . . . -->
	<!-- '''''''''''''''''''''''''''''''''''''''''''''''''''' -->
	<!-- THE FORMULATEX EXTENSION FOR HOTSPOT                 -->
	<!-- .................................................... -->
	<!-- . . . . . . . . . . . . . . . . . . . . . . . . . . .-->
	<!--. . . . . . . . . . . . . . . . . . . . . . . . . . . -->
	<!-- . . . . . . . . . . . . . . . . . . . . . . . . . . .-->
	<!--. . . . . . . . . . . . . . . . . . . . . . . . . . . -->
	<!-- import the hotspot stylesheet                        -->
	<xsl:import href="../../hotspot.xsl"/>
	<!-- . . . . . . . . . . . . . . . . . . . . . . . . . . .-->
	<!--. . . . . . . . . . . . . . . . . . . . . . . . . . . -->
	<!-- prepare the output format for the .tex files         -->
	<xsl:output name="formulatex-txt" method="text" encoding="UTF-8"/>
	<!-- . . . . . . . . . . . . . . . . . . . . . . . . . . .-->
	<!--. . . . . . . . . . . . . . . . . . . . . . . . . . . -->
	<!-- . . . . . . . . . . . . . . . . . . . . . . . . . . .-->
	<!--. . . . . . . . . . . . . . . . . . . . . . . . . . . -->
	<!-- read in the format from hotspot's $params            -->
	<xsl:variable name="formulatex-format">
		<xsl:choose>
			<xsl:when test="exists($params/@formulatex-format)">
				<xsl:value-of select="string($params/@formulatex-format)"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="'png'"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<!-- . . . . . . . . . . . . . . . . . . . . . . . . . . .-->
	<!--. . . . . . . . . . . . . . . . . . . . . . . . . . . -->
	<!-- '''''''''''''''''''''''''''''''''''''''''''''''''''' -->
	<!-- .................................................... -->
	<!-- . . . . . . . . . . . . . . . . . . . . . . . . . . .-->
	<!--. . . . . . . . . . . . . . . . . . . . . . . . . . . -->
	<xsl:template match="/">
		<xsl:message select="$formulatex-format"></xsl:message>
		
		<xsl:next-match/>
	</xsl:template>
	<!-- . . . . . . . . . . . . . . . . . . . . . . . . . . .-->
	<!--. . . . . . . . . . . . . . . . . . . . . . . . . . . -->
	<!-- '''''''''''''''''''''''''''''''''''''''''''''''''''' -->
	<!-- .................................................... -->
	<!-- . . . . . . . . . . . . . . . . . . . . . . . . . . .-->
	<!--. . . . . . . . . . . . . . . . . . . . . . . . . . . -->
	<xsl:template match="hotspot">
		<xsl:result-document href="tex.txt" format="formulatex-txt">
			<!-- a presentation is processed only if it has at least one slide or part (the first step has already taken care of this), is not external, if all presentations are selected, or if it appears in the list of presentations to be generated. -->
			<xsl:for-each select="presentation[empty(@external)][$presentation = '*' or @id = tokenize($presentation, '\s*,\s*')]">
				<xsl:variable name="current-presentation" select="."/>
				<xsl:for-each select=".//tex">
					<xsl:if test="empty(preceding::hotspot:tex[ancestor::hotspot:presentation is $current-presentation][text() eq current()/text()])">
						<!-- the filename is set to the image type which should be created (gif, png, or svg). -->
						<xsl:value-of select="concat(hotspot:formulatexname(.),'.', $formulatex-format)"/>
						<xsl:if test="exists(@pkg)">
							<xsl:value-of select="concat(' [', @pkg, ']')"/>
						</xsl:if>
						<xsl:text>&#xa;</xsl:text>
					</xsl:if>
				</xsl:for-each>
			</xsl:for-each>
		</xsl:result-document>
		<xsl:next-match/>
	</xsl:template>
	<!-- . . . . . . . . . . . . . . . . . . . . . . . . . . .-->
	<!--. . . . . . . . . . . . . . . . . . . . . . . . . . . -->
	<xsl:template match="presentation">
		<xsl:next-match/>
	</xsl:template>
	<!-- . . . . . . . . . . . . . . . . . . . . . . . . . . .-->
	<!--. . . . . . . . . . . . . . . . . . . . . . . . . . . -->
	<!-- '''''''''''''''''''''''''''''''''''''''''''''''''''' -->
	<!-- the formulatex-specific elements: tex and texref     -->
	<!-- .................................................... -->
	<!-- . . . . . . . . . . . . . . . . . . . . . . . . . . .-->
	<!--. . . . . . . . . . . . . . . . . . . . . . . . . . . -->
	<xsl:template match="tex | html:tex" priority="2">
		<xsl:choose>
			<xsl:when test="exists(@id)">
				<table width="100%">
					<xsl:apply-templates select="@class"/>
					<tr>
						<td align="left">
							<xsl:next-match/>
						</td>
						<td align="right">
							<xsl:text>(</xsl:text>
							<xsl:element name="hotspot:counter">
								<xsl:attribute name="name" select="'EQ'"/>
								<xsl:if test="string(@id) ne ''">
									<xsl:attribute name="id" select="@id"/>
								</xsl:if>
							</xsl:element>
							<xsl:text>)</xsl:text>
						</td>
					</tr>
				</table>
			</xsl:when>
			<xsl:otherwise>
				<xsl:next-match/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!-- . . . . . . . . . . . . . . . . . . . . . . . . . . .-->
	<!--. . . . . . . . . . . . . . . . . . . . . . . . . . . -->
	<xsl:template match="tex | html:tex" priority="1">
		<xsl:variable name="name" select="hotspot:formulatexname(.)"/>
		<xsl:if test="empty(preceding::hotspot:tex[ancestor::hotspot:presentation is current()/ancestor::hotspot:presentation][text() eq current()/text()])">
			<xsl:result-document href="{$name}.tex" format="formulatex-txt">
				<xsl:value-of select="text()"/>
			</xsl:result-document>
		</xsl:if>
		<img src="{$name}.{$formulatex-format}" alt="{normalize-space(replace(text(),'\s*\$?(.+?)\$?\s*', '$1'))}">
			<!-- resolve-uri() is used to resolve the sex file name relative to the input file, not relative to the stylesheet file. -->
			<!-- (this may need to be dealt with again if hotspot allows includes, in which case the right base-uri to resolve against probably is the uri of the hotspot root document.) -->
			<xsl:variable name="sex-available" select="unparsed-text-available(resolve-uri(concat(hotspot:formulatexname(.),'.sex'), $base-uri))"/>
			<!-- the following code is used to set the scaling ex (sex) factor for the tex img. -->
			<xsl:variable name="sex">
				<xsl:choose>
					<xsl:when test="exists(@sex)">
						<!-- a @sex attribute has the highest priority. -->
						<xsl:value-of select="@sex"/>
					</xsl:when>
					<xsl:when test="$sex-available">
						<!-- if a .sex file exists, it will be read and used. the sex parameter is the first non-space token. -->
						<xsl:value-of select="tokenize(unparsed-text(resolve-uri(concat(hotspot:formulatexname(.),'.sex'), $base-uri)), '\s+')[1]"/>
					</xsl:when>
					<xsl:otherwise>
						<!-- if there is no sex attribute or file, the default value is used. -->
						<xsl:text>1</xsl:text>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			<!-- the following code is used to set the penetration depth (pd) factor for the tex img. -->
			<xsl:variable name="pd">
				<xsl:choose>
					<xsl:when test="exists(@pd)">
						<!-- a @sex attribute has the highest priority. -->
						<xsl:value-of select="@pd"/>
					</xsl:when>
					<xsl:when test="$sex-available">
						<!-- if a .sex file exists, it will be read and used. the pd parameter is the second non-space token. -->
						<xsl:value-of select="tokenize(unparsed-text(resolve-uri(concat(hotspot:formulatexname(.),'.sex'), $base-uri)), '\s+')[2]"/>
					</xsl:when>
					<xsl:otherwise>
						<!-- if there is no sex attribute or file, the default value is used. -->
						<xsl:text>0</xsl:text>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			<!-- set the positioning parameters, and if there is a @style attribute (containing additional css code), it will be appended. -->
			<xsl:attribute name="style" select="concat(' height : ', $sex, 'ex ; vertical-align : ', $pd, 'ex ; ', normalize-space(string(@style)))"/>
			<!-- push a 'tex' to the list of class names -->
			<xsl:attribute name="class" select="string-join(('tex', string(@class)), ' ')"/>
			<!-- all other attributes will be copied through. -->
			<xsl:apply-templates select="@*[not(local-name() = ('sex', 'pd', 'pkg', 'style', 'class'))]"/>
		</img>
	</xsl:template>
	<!-- . . . . . . . . . . . . . . . . . . . . . . . . . . .-->
	<!--. . . . . . . . . . . . . . . . . . . . . . . . . . . -->
	<xsl:template match="texref | html:texref">
		<hotspot:counter name="EQ" ref="{@id}">
			<xsl:if test="exists(@form)">
				<xsl:copy-of select="@form"/>
			</xsl:if>
		</hotspot:counter>
	</xsl:template>
	<!-- . . . . . . . . . . . . . . . . . . . . . . . . . . .-->
	<!--. . . . . . . . . . . . . . . . . . . . . . . . . . . -->
	<!-- '''''''''''''''''''''''''''''''''''''''''''''''''''' -->
	<!-- .................................................... -->
	<!-- . . . . . . . . . . . . . . . . . . . . . . . . . . .-->
	<!--. . . . . . . . . . . . . . . . . . . . . . . . . . . -->
	<xsl:function name="hotspot:formulatexname" as="xs:string">
		<xsl:param name="context"/>
		<xsl:variable name="name">
			<!-- the image goes to the '*-figs' directory. (this should be made configurable as soon as options for hotspot extensions are supported by hotspot.) -->
			<xsl:value-of select="concat(hotspot:presentationname($context/ancestor-or-self::hotspot:presentation[1]), '-figs', '/')"/>
			<!-- if the presentation contains a preceding tex element with the same content, then this image should be reused. -->
			<xsl:variable name="preceding" select="$context/preceding::hotspot:tex[ancestor::hotspot:presentation is $context/ancestor::hotspot:presentation][text() eq $context/text()]"/>
			<xsl:variable name="tex" select="if ( exists($preceding) ) then $preceding[1] else $context"/>
			<!-- calculates and formats the number of preceding tex elements. -->
			<xsl:number format="00000001" value="count($tex/preceding::hotspot:tex intersect $tex/ancestor::hotspot:presentation/descendant::hotspot:tex) + 1"/>
		</xsl:variable>
		<xsl:value-of select="string($name)"/>
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