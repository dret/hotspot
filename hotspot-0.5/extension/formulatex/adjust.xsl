<?xml version="1.0" encoding="UTF-8"?>
<!-- $Id$ -->
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns="http://www.w3.org/1999/xhtml" xmlns:html="http://www.w3.org/1999/xhtml" xmlns:hotspot="http://dret.net/xmlns/hotspot/1" xmlns:kilauea="http://xmlns.sharpeleven.net/kilauea" xpath-default-namespace="http://dret.net/xmlns/hotspot/1" exclude-result-prefixes="xs hotspot html kilauea">
	<!-- . . . . . . . . . . . . . . . . . . . . . . . . . . .-->
	<!--. . . . . . . . . . . . . . . . . . . . . . . . . . . -->
	<xsl:template match="/">
		<xsl:result-document method="html" encoding="UTF-8" href="{document-uri(.)}" indent="no">
			<xsl:apply-templates select="node()"/>
		</xsl:result-document>
	</xsl:template>
	<!-- . . . . . . . . . . . . . . . . . . . . . . . . . . .-->
	<!--. . . . . . . . . . . . . . . . . . . . . . . . . . . -->
	<xsl:template match="node() | @*">
		<xsl:copy>
			<xsl:apply-templates select="node() | @*"/>
		</xsl:copy>
	</xsl:template>
	<!-- . . . . . . . . . . . . . . . . . . . . . . . . . . .-->
	<!--. . . . . . . . . . . . . . . . . . . . . . . . . . . -->
	<xsl:template match="img['tex' = tokenize(@class, '\s+')]">
		<xsl:message>*</xsl:message>
		<xsl:copy>
			<xsl:variable name="sex" select="replace(string(@src), '\.\w+$', '.sex')"/>
			<!-- resolve-uri() is used to resolve the sex file name relative to the input file, not relative to the stylesheet file. -->
			<!-- (this may need to be dealt with again if hotspot allows includes, in which case the right base-uri to resolve against probably is the uri of the hotspot root document.) -->
			<xsl:variable name="sex-available" select="unparsed-text-available(resolve-uri($sex, @src))"/>
			<!-- the following code is used to set the scaling ex (sex) factor for the tex img. -->
			<xsl:variable name="sex">
				<xsl:choose>
					<xsl:when test="exists(@sex)">
						<!-- a @sex attribute has the highest priority. -->
						<xsl:value-of select="@sex"/>
					</xsl:when>
					<xsl:when test="$sex-available">
						<!-- if a .sex file exists, it will be read and used. the sex parameter is the first non-space token. -->
						<xsl:value-of select="tokenize(unparsed-text(resolve-uri($sex, @src)), '\s+')[1]"/>
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
						<xsl:value-of select="tokenize(unparsed-text(resolve-uri($sex, @src)), '\s+')[2]"/>
					</xsl:when>
					<xsl:otherwise>
						<!-- if there is no sex attribute or file, the default value is used. -->
						<xsl:text>0</xsl:text>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			<!-- set the positioning parameters, and if there is a @style attribute (containing additional css code), it will be appended. -->
			<xsl:attribute name="style" select="concat(' height : ', $sex, 'ex ; vertical-align : ', $pd, 'ex ; ', normalize-space(string(@style)))"/>
			<!-- all other attributes will be copied through. -->
			<xsl:apply-templates select="@*[not(local-name() = ('sex', 'pd', 'pkg', 'style'))]"/>
		</xsl:copy>
	</xsl:template>
	<!-- . . . . . . . . . . . . . . . . . . . . . . . . . . .-->
	<!--. . . . . . . . . . . . . . . . . . . . . . . . . . . -->
</xsl:stylesheet>