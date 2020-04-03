<?xml version="1.0" encoding="gb2312"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="xml" version="1.0" omit-xml-declaration="yes"/>
	<xsl:variable name="MyNodes" select="//siteMapNode[@url='index.asp']"/>
	<xsl:template match="/">
		<xsl:apply-templates/>
	</xsl:template>
	<xsl:template match="*">
		<xsl:if test="$MyNodes[count(ancestor::*) = count(ancestor::* | current())] or
           count(.| $MyNodes) = count($MyNodes)">
			<xsl:copy>
				<xsl:copy-of select="@*"/>
				<xsl:apply-templates/>
			</xsl:copy>
		</xsl:if>
	</xsl:template>
	<xsl:template match="text() | comment() | processing-instruction()">
		<xsl:copy/>
	</xsl:template>
</xsl:stylesheet>
