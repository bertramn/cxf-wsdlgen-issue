<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xsd="http://www.w3.org/2001/XMLSchema"
  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
  xmlns:jaxb="http://java.sun.com/xml/ns/jaxb"
  xmlns:xjc="http://java.sun.com/xml/ns/jaxb/xjc"
  xmlns:annox="http://annox.dev.java.net"
  xmlns:inheritance="http://jaxb2-commons.dev.java.net/basic/inheritance"
  xmlns:namespace="http://jaxb2-commons.dev.java.net/namespace-prefix"
  version="1.0">

  <xsl:output method="xml" encoding="utf-8" omit-xml-declaration="no" indent="yes"/>

  <xsl:template match="/xsd:schema">
    <jaxb:bindings jaxb:version="2.1" jaxb:extensionBindingPrefixes="xjc annox namespace">
      <jaxb:bindings node="/xsd:schema" schemaLocation="FILE.xsd">
        <xsl:apply-templates select="child::node()"/>
      </jaxb:bindings>
    </jaxb:bindings>
  </xsl:template>

  <xsl:template match="xsd:complexType">
    <jaxb:bindings>
      <xsl:attribute name="node">
        <xsl:variable name="apos">'</xsl:variable>
        <xsl:value-of select="concat(name(.), '[@name=', $apos, @name, $apos, ']')"/>
      </xsl:attribute>
      <jaxb:class>
        <xsl:attribute name="name">
          <xsl:value-of select="substring-before(@name, 'Type')"/>
        </xsl:attribute>
      </jaxb:class>
    </jaxb:bindings>
  </xsl:template>

  <xsl:template match="xsd:simpleType[xsd:restriction/xsd:enumeration and not(starts-with(@name, 'Type'))]">
    <jaxb:bindings>
      <xsl:attribute name="node">
        <xsl:variable name="apos">'</xsl:variable>
        <xsl:value-of select="concat(name(.), '[@name=', $apos, @name, $apos, ']')"/>
      </xsl:attribute>
      <jaxb:typesafeEnumClass>
        <xsl:attribute name="name">
          <xsl:value-of select="concat(substring-before(@name, 'Type'), 'Type')"/>
        </xsl:attribute>
      </jaxb:typesafeEnumClass>
    </jaxb:bindings>
  </xsl:template>

  <xsl:template match="@* | node()"/>



</xsl:stylesheet>
