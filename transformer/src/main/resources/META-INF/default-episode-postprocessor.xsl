<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:jaxb="http://java.sun.com/xml/ns/jaxb">

  <xsl:output encoding="utf-8" indent="yes" method="xml" omit-xml-declaration="no"/>

  <xsl:strip-space elements="*"/>

  <!--
    This template will set the @if-exists value of a scd binding to true if it is not set or set to false.
    It will also try to map a null type back to a proper type name. The comment left behind can be used in
    an enforcer rule to fail if the XJC parser generated rubbish.
  -->

  <!-- remap any @if-exists to true if they are not -->
  <xsl:template priority="11" match="@if-exists[parent::jaxb:bindings[@if-exists = 'false' ]]">
    <xsl:attribute name="if-exists">
      <xsl:value-of select="'true'"/>
    </xsl:attribute>
  </xsl:template>

  <!-- process the schemaLocation and flatten the file using a custom extension -->
  <xsl:template priority="10" match="//jaxb:bindings[@scd and not(@if-exists)]">
    <xsl:copy>
      <xsl:attribute name="if-exists">true</xsl:attribute>
      <xsl:apply-templates select="node() | @*"/>
    </xsl:copy>
  </xsl:template>

  <!-- BUG filter out any type bindings that have a null type and set it to the value of the class name -->
  <xsl:template priority="10" match="//jaxb:bindings[@scd = '~tns:null']/@scd">
    <xsl:attribute name="scd">
      <xsl:call-template name="stripPackageFromClassName">
        <xsl:with-param name="className" select="ancestor::node()/jaxb:class/@ref"/>
      </xsl:call-template>
    </xsl:attribute>
    <xsl:text>&#10;         </xsl:text>
    <xsl:comment>
      <xsl:value-of select="'found ~tns:null in generated episode'"/>
    </xsl:comment>
    <xsl:text>&#10;</xsl:text>
  </xsl:template>

  <!-- template for copying everything else but comments -->
  <xsl:template name="identity" match="@* | node()[not(self::comment())]">
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
