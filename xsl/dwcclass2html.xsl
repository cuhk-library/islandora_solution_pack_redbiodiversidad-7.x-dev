<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:oai_dc="http://www.openarchives.org/OAI/2.0/oai_dc/"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" 
    xmlns:dcterms="http://purl.org/dc/terms/"
    xmlns:dc="http://purl.org/dc/elements/1.1/"
    xmlns:dwr="http://rs.tdwg.org/dwc/dwcrecord/"
    xmlns:dwc="http://rs.tdwg.org/dwc/terms/" 
    xmlns:dwrs="http://rs.tdwg.org/dwc/xsd/simpledarwincore/"
    xmlns="http://www.w3.org/1999/xhtml">

    <xsl:output method="html" encoding="UTF-8" indent="yes"/>

    <xsl:template match="/">
        <article>
            <dl>
            <xsl:apply-templates/>
            </dl>
        </article>

    </xsl:template>
     
    <xsl:template name="taxonterms" match="/dwr:DarwinRecordSet/dwc:*/*">
        <xsl:if test="normalize-space(.)">
            <dt class="term">  
                <xsl:value-of select="local-name()"/>
            </dt>
            <dd class="termvalue">
                <xsl:choose>
                    <xsl:when test="@type='uri' or substring(normalize-space(text()), 0, 5) = 'http'">
                        <a href="{text()}" target="_blank">
                            <xsl:value-of select="text()"/>
                        </a>
                    </xsl:when>
                <xsl:when test="name()='dwc:dynamicProperties'">
                    <xsl:call-template name="split">
  					  <xsl:with-param name="pText" select="."/>
   					</xsl:call-template>
                </xsl:when>                       
                    <xsl:otherwise>     
                        <a href="../search/{text()}?type=dismax" target="_self">
                <xsl:value-of select="."/>
                        </a>
                    </xsl:otherwise>
                </xsl:choose>
            </dd>
            <xsl:text> </xsl:text>

        </xsl:if>
    </xsl:template>
    
<xsl:template name="split">
  <xsl:param name="pText" select="."/>
  <xsl:if test="string-length($pText)">
   <xsl:if test="not($pText=.)">
      <br/>
      <a href="../search/{substring-before(concat($pText,','),',')}?type=dismax" target="_self">
   <xsl:value-of select="substring-before(concat($pText,','),',')"/>
      </a>
       </xsl:if>
   <xsl:call-template name="split">
    <xsl:with-param name="pText" select="substring-after($pText, ',')"/>
   </xsl:call-template>
  </xsl:if>
 </xsl:template>  
   
  
    
    
    <xsl:template name="dcterms" match="/dwr:DarwinRecordSet/dcterms:*/*">
        <xsl:if test="normalize-space(.)">
            <dt class="term">
                
                <xsl:value-of select="local-name()"/>
            </dt>
            <dd class="termvalue">
                <xsl:choose>
                    <xsl:when test="@type='uri' or substring(normalize-space(text()), 0, 5) = 'http'">
                        <a href="{text()}" target="_blank">
                            <xsl:value-of select="text()"/>
                        </a>
                    </xsl:when>
                    <xsl:otherwise>
                        
                        <a href="../search/{text()}?type=dismax" target="_self">
                            <xsl:value-of select="."/>
                        </a>
                    </xsl:otherwise>
                </xsl:choose>
            </dd>
            <xsl:text> </xsl:text>
            
        </xsl:if>
    </xsl:template>
      <xsl:template match="dwrs:SimpleDarwinRecord/*">       
<xsl:if test="normalize-space(.)">
            <dt class="term">
                <xsl:value-of select="local-name()"/>
            </dt>
            <dd class="termvalue">
                <xsl:choose>
                    <xsl:when test="@type='uri' or substring(normalize-space(text()), 0, 5) = 'http'">
                        <a href="{text()}" target="_blank">
                            <xsl:value-of select="text()"/>
                        </a>
                    </xsl:when>
                    <xsl:otherwise>
                        
                        <a href="../search/{text()}?type=dismax" target="_self">
                <xsl:value-of select="."/>
                        </a>
                    </xsl:otherwise>
                </xsl:choose>
            </dd>
        </xsl:if>
    </xsl:template>
</xsl:stylesheet>
