<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
    xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xhtml="http://www.w3.org/1999/xhtml"
    version="2.0" exclude-result-prefixes="svrl xhtml">

  <xsl:output method="xml" indent="yes" encoding="UTF-8" omit-xml-declaration="no"/>
  

  <xsl:template match="svrl:schematron-output">
        
      <xsl:element name="validationreport"> 
        <xsl:attribute name="CreationDateTime"><xsl:value-of select="current-dateTime()"/></xsl:attribute> 
          
        <document><xsl:value-of select="svrl:active-pattern[1]/@document"/><xsl:value-of select="svrl:active-pattern[1]/@documents"/></document>
        
        <active-patterns>
          <xsl:apply-templates select="svrl:active-pattern"/>
        </active-patterns>
        
        <xsl:element name="issues">
  
          <xsl:variable name='problems' select='svrl:failed-assert|svrl:successful-report'/>
          <xsl:choose>
            <xsl:when test="$problems">
                  <xsl:for-each select="$problems">
                    <xsl:call-template name='problem-report'/>
                  </xsl:for-each>
            </xsl:when>
            <xsl:otherwise>
            </xsl:otherwise>
          </xsl:choose>
          
        </xsl:element>
      </xsl:element>


  </xsl:template>

  <xsl:template match="svrl:active-pattern">

      <xsl:element name="active-pattern">
        <xsl:attribute name="id"><xsl:value-of select="@id"/></xsl:attribute>
        <xsl:value-of select="@name"/>
      </xsl:element>

  </xsl:template>
  

  <xsl:template name='problem-report'>
    <xsl:variable name='active-pattern-id' 
      select='preceding-sibling::svrl:active-pattern[1]/@id'/>
    <xsl:variable name='active-pattern-name' 
      select='preceding-sibling::svrl:active-pattern[1]/@name'/>
    
      <xsl:element name="issue">

        <xsl:attribute name="checkid"> <xsl:value-of select="$active-pattern-id"/></xsl:attribute>
        <xsl:attribute name="flag"> <xsl:value-of select="@flag"/></xsl:attribute>
        <xsl:attribute name="see"> <xsl:value-of select="@see"/></xsl:attribute>
        
        <xsl:element name="description">
          <xsl:value-of select="$active-pattern-name"/>
        </xsl:element>
        
        <xsl:element name="location">
          <xsl:value-of select="@location"/>
        </xsl:element>
        
        <xsl:element name="message">
          <xsl:value-of select="normalize-space(svrl:text/text())"/>
        </xsl:element>
        
      </xsl:element>


  </xsl:template>
  
  
</xsl:stylesheet>
