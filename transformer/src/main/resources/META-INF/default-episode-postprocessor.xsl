<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:jaxb="http://java.sun.com/xml/ns/jaxb" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:output method="xml" encoding="utf-8" omit-xml-declaration="no" indent="yes"/>

  <xsl:strip-space elements="*"/>

  <!-- process the schemaLocation and flatten the file using a custom extension -->
  <xsl:template match="//jaxb:bindings[@scd and not(@if-exists)]">
    <xsl:copy>
      <xsl:attribute name="if-exists">true</xsl:attribute>
      <xsl:apply-templates select="node() | @*"/>
    </xsl:copy>
  </xsl:template>

  <!-- BUG filter out any type bindings that have a null type and set it to the value of the class name -->
  <xsl:template match="//jaxb:bindings[@scd = '~tns:null']/@scd">
    <xsl:attribute name="scd">
      <xsl:call-template name="stripPackageFromClassName">
        <xsl:with-param name="className" select="ancestor::node()/jaxb:class/@ref"/>
      </xsl:call-template>
    </xsl:attribute>
    <xsl:text>&#10;</xsl:text>
    <xsl:comment>
      <xsl:value-of select="'found ~tns:null in generated episode.'"/>
    </xsl:comment>
  </xsl:template>

  <!-- template for copying everything else but comments -->
  <xsl:template match="@* | node()[not(self::comment())]" name="identity">
    <xsl:copy>
      <xsl:apply-templates select="node() | @*"/>
    </xsl:copy>
  </xsl:template>

  <!-- cleanup functions -->
  <xsl:template name="stripPackageFromClassName">
    <xsl:param name="className"/>
    <!-- we assume its always a type -->
    <xsl:param name="xsdType" select="'~tns'"/>
    <!-- delim for package separation is always . -->
    <xsl:param name="delimiter" select="'.'"/>
    <xsl:choose>
      <xsl:when test="contains($className, $delimiter)">
        <!-- need to strip further -->
        <xsl:call-template name="stripPackageFromClassName">
          <xsl:with-param name="className" select="substring-after($className, $delimiter)"/>
          <xsl:with-param name="xsdType" select="$xsdType"/>
          <xsl:with-param name="delimiter" select="$delimiter"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <!-- stripped all package names -->
        <xsl:value-of select="concat($xsdType, ':', $className)"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

</xsl:stylesheet>
