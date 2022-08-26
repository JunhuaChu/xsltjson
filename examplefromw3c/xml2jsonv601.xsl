<xsl:stylesheet version="3.0" 
xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
xmlns="http://www.w3.org/2005/xpath-functions">
<xsl:output method="text" encoding="UTF-8"/>

<xsl:template match="/G_1">
    <!-- CONVERT INPUT TO XML FOR JSON
    Source:https://stackoverflow.com/questions/58104516/using-xslt-to-transform-xml-to-json -->
    <xsl:variable name="xml">
        <array>
            <xsl:for-each-group select="*" group-starting-with="map">
            
                <map>
                    <string key="Item_Number">
                    <!-- note-->
                        <xsl:value-of select="current-group()[self::ITEMNUMBER]"/>
                    </string>
                    <string key="Item_Description">
                    <!-- note-->
                        <xsl:value-of select="current-group()[self::ITEMDESCRIPTION]"/>
                    </string>
                </map>
            </xsl:for-each-group>
        </array>
    </xsl:variable>
    <!-- OUTPUT -->
    <xsl:value-of select="xml-to-json($xml)"/>
</xsl:template>

</xsl:stylesheet>