<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xhtml="http://www.w3.org/1999/xhtml"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    version="2.0" exclude-result-prefixes="xhtml">

  <xsl:output method="xhtml" indent="yes" encoding="UTF-8"
    omit-xml-declaration="yes"
    doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd" 
    doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN" version="1.0"/>
  
    <xsl:param name="input-uri" />

  <xsl:template match="validationreport">
    <html>
      <head>
        <title>Validation Report</title>
        <xsl:call-template name="GenerateCSS"/>
      </head>
      <body>
        
        <xsl:call-template name="generateMenu"/>
        
        <div id="main">
        <h1>Validation Results - <xsl:value-of select="substring(@CreationDateTime, 1, 19)"/></h1>
        <h3><xsl:value-of select="document/text()"/></h3> 
        <br />
        
        <h2>Validation Report</h2>

          <h2 id="active-patterns">Schematron Rules Checked</h2>
          <table class='results'>
            <thead>
              <tr>
                <th>Rule ID</th>
                <th>Description</th>
                <th>Issues?</th>
              </tr>
            </thead>
            <tbody>
              <xsl:call-template name="active-patterns"/>
            </tbody>
          </table>

          <h2 id="issue-summary">Schematron Issue Summary</h2>
          <table class='results'>
            <thead>
              <tr>
                <th>Rule ID</th>
                <th>Description</th>
                <th># Issues</th>
              </tr>
            </thead>
            <tbody>
              <xsl:call-template name="issue-summary"/>
            </tbody>
          </table>
          <xsl:if test="count(//issue) = 0">
            <p>No problems were found.</p>
          </xsl:if>        
          
        <h2 id="issue-details">Schematron Issue Details</h2>
        <table class='results'>
          <thead>
            <tr>
              <th>Rule ID</th>
              <th>Severity</th>
              <th>Reference</th>
              <th>Message</th>
            </tr>
          </thead>
          <tbody>
            <xsl:for-each select="//issue">
              <xsl:call-template name='issue-details'/>
            </xsl:for-each>
          </tbody>
        </table>
 
        <xsl:if test="count(//issue) = 0">
          <p>No problems were found.</p>
        </xsl:if>
       
        <xsl:if test="$input-uri">
          <xsl:variable name="in" select="unparsed-text($input-uri)"/>
          <h2 id="xml-schema-issues">XML Schema Validation Report</h2>
          <table>
          <thead>
            <tr>
              <th>Row</th>
              <th>Column</th>
              <th>XML Schema Rule</th>
              <th>Description</th>
            </tr>  
          </thead>
            <xsl:analyze-string select="$in" regex="\n">
              <xsl:non-matching-substring>
                <tr>
                  <xsl:analyze-string select="." regex='((\[schemavalidate\])(.*):(\d*):(\d*): (.*?):(.*))'>
                    <xsl:matching-substring>
                        
                        <td><xsl:value-of select="regex-group(4)"/></td>
                        <td><xsl:value-of select="regex-group(5)"/></td>
                        <td>
                          <xsl:element name="a">
                            <xsl:attribute name="href">
                              <xsl:text>https://www.w3.org/TR/xmlschema-1/#validation_failures</xsl:text>
                              <!-- <xsl:value-of select="substring-before(concat(regex-group(6), '.'), '.')"/> -->
                            </xsl:attribute>
                            <xsl:value-of select="regex-group(6)"/>
                          </xsl:element>
                        </td>
                        <td><xsl:value-of select="regex-group(7)"/></td>
                    </xsl:matching-substring>
                    
                  </xsl:analyze-string>
                </tr>
              </xsl:non-matching-substring>
            </xsl:analyze-string>
          </table>
        </xsl:if>         

        </div>
      </body>
    </html>

  </xsl:template>


  <xsl:template name="generateMenu">
    <div id="menu">
      <ul class="hmenu">
        <li class="hmenu-item"><a href="#active-patterns">Rules Checked</a></li>
        <li class="hmenu-item"><a href="#issue-summary">Schematron Issue Summary</a></li>
        <li class="hmenu-item"><a href="#issue-details">Schematron Issue Details</a></li>
        <xsl:if test="$input-uri">
          <li class="hmenu-item"><a href="#xml-schema-issues">XML Schema Issue Details</a></li>
        </xsl:if>  
      </ul>
    </div>
  </xsl:template>

  <xsl:template name="issue-summary">
    <xsl:for-each select="/validationreport/active-patterns/active-pattern">
      <xsl:variable name="id" select="@id"/>
      <xsl:variable name="count_issues" select="count(//issue[@checkid=$id])"/>
      
      <xsl:if test="$count_issues &gt; 0">
        <tr>
          <td><xsl:value-of select="$id"/></td>
          <td><xsl:value-of select="text()"/></td>
          <td><xsl:value-of select="$count_issues"/> </td>
        </tr>
      </xsl:if>
    </xsl:for-each> 
  </xsl:template>
  
  <xsl:template name="active-patterns">
    <xsl:for-each select="/validationreport/active-patterns/active-pattern">
      <xsl:variable name="id" select="@id"/>
      <xsl:variable name="count_issues" select="count(//issue[@checkid=$id])"/>
      
      <tr>
        <td><xsl:value-of select="@id"/></td>
        <td><xsl:value-of select="text()"/></td>
        <td><xsl:if test="$count_issues &gt; 0"><xsl:text>Yes</xsl:text></xsl:if></td>
      </tr>
    </xsl:for-each> 
  </xsl:template>
  
  <xsl:template name='issue-details'>
    
    <xsl:variable name="SeverityClass">
      <xsl:choose>
        <xsl:when test="lower-case(@flag) = 'error' or not(@flag)">severity-error</xsl:when>
        <xsl:when test="lower-case(@flag) = 'warning'">severity-warning</xsl:when>
        <xsl:when test="lower-case(@flag) = 'reject'">severity-reject</xsl:when>
        <xsl:when test="lower-case(@flag) = 'info'">severity-info</xsl:when>
      </xsl:choose>
    </xsl:variable>

    <tr>
      
      <td class='checkid'>
        <xsl:value-of select="@checkid"/> 
      </td>
      
      <xsl:element name="td">
        <xsl:attribute name="class"><xsl:value-of select="$SeverityClass"/></xsl:attribute>
        <xsl:value-of select="@flag"/>
      </xsl:element>

      <td class='see'>
        <xsl:analyze-string select="@see" regex='\[(.*)\]\((.*)\)(.*)'>
        <xsl:matching-substring>
          <xsl:element name="a">
            <xsl:attribute name="href">
              <xsl:value-of select="regex-group(2)"/>
            </xsl:attribute>
            <xsl:value-of select="regex-group(1)"/>
          </xsl:element>
          <xsl:value-of select="regex-group(3)"/>          
        </xsl:matching-substring>
        <xsl:non-matching-substring>
            <xsl:value-of select="."/>
        </xsl:non-matching-substring>
      </xsl:analyze-string>
      </td>
      
      <td class='message'>
        <xsl:value-of select="normalize-space(message/text())"/>
      </td>
      
    </tr>
      
  </xsl:template>
  
  <xsl:template name="GenerateCSS">
    
    <xsl:variable name="COLOR_MENU_BODY_BACKGROUND">#FFFFFF</xsl:variable>
    <xsl:variable name="COLOR_MENU_BODY_FOREGROUND">#000000</xsl:variable>
    <xsl:variable name="COLOR_HMENU_TEXT">#004A95</xsl:variable>  
    <xsl:variable name="COLOR_HMENU_BULLET">#AAAAAA</xsl:variable>  
    
    <style type="text/css">
      
      body{
        background-color:#FFFFFF;
        font-family:Verdana, Arial, Helvetica, sans-serif;        
        font-size:62.5%;
        margin:0;
        padding:30px;        
      }

      #menu{
        position: fixed;
        left: 0px;
        top: 10px;
        width: 15%;
        height: 96%;
        bottom: 0px;
        overflow: auto;
        background-color: <xsl:value-of select="$COLOR_MENU_BODY_BACKGROUND" />;
        color: <xsl:value-of select="$COLOR_MENU_BODY_FOREGROUND" />;
        border: 0px;
        text-align: left;
        white-space: nowrap;
        font-size:1.3em;
      }
      
      .hmenu ul{
        padding-left: 14px;
        margin-left: 0;
      }
      .hmenu li{
      list-style: none;
      line-height: 200%;
      padding-left: 0;
      }
      
      #main{
      position: absolute;
      left: 15%;
      top: 0px;
      bottom: 20px;
      overflow: auto;
      background-color: <xsl:value-of select="$COLOR_MENU_BODY_BACKGROUND" />;
      color: <xsl:value-of select="$COLOR_MENU_BODY_FOREGROUND" />;
      float: none !important;
      }
      
      h1{
      font-size:1.6em;
      font-weight:bolder;
      text-align:center;
      }
      h2{
      font-size:1.4em;
      font-weight:bolder;
      color:#800000;
      text-align:center;
      }
      h3{
      font-size:1.2em;
      font-weight:bolder;
      color:#800000;
      text-align:center;
      }
      p{
      font-size:1.4em;
      }
      table{
      width:95%;
      border-spacing:4px;
      border:1px solid #000000;
      background-color:#EEEEEE;
      margin-top:5px;
      border-collapse:collapse;
      padding:5px;
      empty-cells:show;
      }
      
      table tr{
      border:1px solid #000000;
      }
      thead tr{
      background-color:#6699CC;
      color:#FFFFFF;
      font-weight:bold;
      }
      table th{
      font-weight:bold;
      vertical-align:top;
      text-align:left;
      padding:5px;
      border:1px solid #000000;
      font-size:1.5em;
      }
      
      table td{
      vertical-align:top;
      padding:5px;
      border:1px solid #000000;
      font-size:1.3em;
      line-height:150%;
      }
      
      .severity-error,  .severity-reject{
      color:#FF0000;
      }
      
      .xml-validate {
      font-size:200%;
      }
      
    </style>
  </xsl:template> 
  
</xsl:stylesheet>
