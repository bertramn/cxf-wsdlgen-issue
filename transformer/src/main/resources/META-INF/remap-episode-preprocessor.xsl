<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:jaxb="http://java.sun.com/xml/ns/jaxb">

  <xsl:output method="xml" encoding="utf-8" omit-xml-declaration="no" indent="yes"/>

  <xsl:strip-space elements="*"/>

  <!-- take out the map binding -->
  <xsl:template match="@map[parent::jaxb:schemaBindings]">
    <xsl:attribute name="map">
      <xsl:value-of select="'true'"/>
    </xsl:attribute>
  </xsl:template>

  <!-- Identity template for copying everything else -->
  <xsl:template match="@*[not(local-name() = 'map' and parent::jaxb:schemaBindings)] | node()[not(self::comment())]" name="identity">
    <xsl:copy>
      <xsl:apply-templates select="node() | @*"/>
    </xsl:copy>
  </xsl:template>

</xsl:stylesheet>
