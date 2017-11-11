<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:jaxb="http://java.sun.com/xml/ns/jaxb">

  <xsl:output encoding="utf-8" indent="yes" method="xml" omit-xml-declaration="no"/>

  <xsl:strip-space elements="*"/>

  <!--
    Set the map attribute on the schemaBindings element to true to allow the
    JAXB compiler to include the episode into the compilation context. It will not
    generate any of the types in the schema package but allows for inclusion of
    already generated types in the binding context. Nasty bug in XJC where it looses
    track of types in compilation episodes.
  -->

  <!-- take out the map binding -->
  <xsl:template priority="10" match="@map[parent::jaxb:schemaBindings]">
    <xsl:attribute name="map">
      <xsl:value-of select="'true'"/>
    </xsl:attribute>
  </xsl:template>

  <!-- Identity template for copying everything else -->
  <xsl:template name="identity" match="node() | @*">
    <xsl:copy>
      <xsl:apply-templates select="node() | @*"/>
    </xsl:copy>
  </xsl:template>

</xsl:stylesheet>
