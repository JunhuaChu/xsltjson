<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="text" encoding="utf-8"/>
	
	<xsl:template match="*">
		<xsl:param name="indents"/><xsl:param name="inArray"/>
		<xsl:choose>
			<xsl:when test="$inArray = 1 and not(@*[not(starts-with(name(), &apos;json..&apos;)) and not(starts-with(name(), &apos;json:&apos;))]) and not(text()) and not(*[name()!=name(..)][1]) and (*[1]/@json..Array or @*[name()=&apos;json:Array&apos;] or *[2])">
				<xsl:text>[</xsl:text>
				<xsl:for-each select="*">
					<xsl:if test="position() &gt; 1">,</xsl:if>
					<xsl:value-of select="concat(&apos;&#x0D;&#x0A;&apos;, $indents, &apos;&#x09;&apos;)"/>
					<xsl:apply-templates select="."><xsl:with-param name="indents" select="concat($indents, &apos;&#x09;&apos;)"/><xsl:with-param name="inArray" select="1"/></xsl:apply-templates>
				</xsl:for-each>
				<xsl:value-of select="concat(&apos;&#x0D;&#x0A;&apos;, $indents)"/><xsl:text>]</xsl:text>
			</xsl:when>
			<xsl:when test="* or @*[not(starts-with(name(), &apos;json..&apos;)) and not(starts-with(name(), &apos;json:&apos;))]">
				<xsl:text>{</xsl:text>
				<xsl:for-each select="@*[not(starts-with(name(), &apos;json..&apos;)) and not(starts-with(name(), &apos;json:&apos;))]">
					<xsl:if test="position() &gt; 1">,</xsl:if>
					<xsl:value-of select="concat(&apos;&#x0D;&#x0A;&apos;, $indents, &apos;&#x09;&apos;)"/>"@<xsl:value-of select="name()"/><xsl:text>":"</xsl:text>
					<xsl:call-template name="output-string"><xsl:with-param name="string" select="."/></xsl:call-template>
					<xsl:text>"</xsl:text>
					<xsl:if test="position() = last()"><xsl:if test="../node()">,</xsl:if></xsl:if>
				</xsl:for-each>
				<xsl:for-each select="text()">
					<xsl:if test="position() = 1">
						<xsl:value-of select="concat(&apos;&#x0D;&#x0A;&apos;, $indents, &apos;&#x09;&apos;)"/>
						<xsl:text>"#text":</xsl:text>
						<xsl:if test="last() &gt; 1">[</xsl:if>
					</xsl:if>
					<xsl:if test="position() > 1">,</xsl:if>
					<xsl:if test="last() &gt; 1">						
						<xsl:value-of select="concat(&apos;&#x0D;&#x0A;&apos;, $indents, &apos;&#x09;&#x09;&apos;)"/>
					</xsl:if>
					<xsl:text>"</xsl:text>
					<xsl:call-template name="output-string"><xsl:with-param name="string" select="."/></xsl:call-template>
					<xsl:text>"</xsl:text>					
					<xsl:if test="position() = last()">
						<xsl:if test="last() &gt; 1"><xsl:value-of select="concat(&apos;&#x0D;&#x0A;&apos;, $indents, &apos;&#x09;&apos;)"/>]</xsl:if>
						<xsl:if test="../*">,</xsl:if>
					</xsl:if>
				</xsl:for-each>
				<xsl:for-each select="*">
					<xsl:variable name="eleName" select="name()"/>
					<xsl:choose>
						<xsl:when test="preceding-sibling::*[name()=$eleName]" />
						<xsl:otherwise>
							<xsl:if test="position() &gt; 1" >,</xsl:if>
							<xsl:value-of select="concat(&apos;&#x0D;&#x0A;&apos;, $indents, &apos;&#x09;&apos;)"/>"<xsl:value-of select="name()"/><xsl:text>":</xsl:text>
							<xsl:choose>
								<xsl:when test="@json..Array or @*[name()=&apos;json:Array&apos;] or following-sibling::*[name()=$eleName]">
									<xsl:text>[</xsl:text>
									<xsl:value-of select="concat(&apos;&#x0D;&#x0A;&apos;, $indents, &apos;&#x09;&#x09;&apos;)"/>
									<xsl:apply-templates select="."><xsl:with-param name="indents" select="concat($indents, &apos;&#x09;&#x09;&apos;)"/><xsl:with-param name="inArray" select="1"/></xsl:apply-templates>
									<xsl:for-each select="following-sibling::*[name()=$eleName]">
										<xsl:text>,</xsl:text>
										<xsl:value-of select="concat(&apos;&#x0D;&#x0A;&apos;, $indents, &apos;&#x09;&#x09;&apos;)"/>
										<xsl:apply-templates select="."><xsl:with-param name="indents" select="concat($indents, &apos;&#x09;&#x09;&apos;)"/><xsl:with-param name="inArray" select="1"/></xsl:apply-templates>
									</xsl:for-each>
									<xsl:value-of select="concat(&apos;&#x0D;&#x0A;&apos;, $indents, &apos;&#x09;&apos;)"/>
									<xsl:text>]</xsl:text>
								</xsl:when>
								<xsl:otherwise>
									<xsl:apply-templates select="."><xsl:with-param name="indents" select="concat($indents, &apos;&#x09;&apos;)"/></xsl:apply-templates>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:for-each>
				<xsl:value-of select="concat(&apos;&#x0D;&#x0A;&apos;, $indents)"/><xsl:text>}</xsl:text>
			</xsl:when>
			<xsl:otherwise>
				<xsl:choose>
					<xsl:when test="@json..Type or @*[name()=&apos;json:Type&apos;]">
						<xsl:choose>
							<xsl:when test="text()"><xsl:value-of select="text()"/></xsl:when>
							<xsl:otherwise>null</xsl:otherwise>
						</xsl:choose>
					</xsl:when>
					<xsl:otherwise>
						<xsl:choose>
							<xsl:when test="text()">
								<xsl:text>"</xsl:text>
								<xsl:call-template name="output-string"><xsl:with-param name="string" select="text()"/></xsl:call-template>
								<xsl:text>"</xsl:text>
							</xsl:when>
							<xsl:otherwise>""</xsl:otherwise>
						</xsl:choose>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template name="output-string">
		<xsl:param name="string" />
		<xsl:if test="$string != &apos;&apos;">
			<xsl:choose>
				<xsl:when test="contains($string, &apos;&#x09;&apos;) or contains($string, &apos;&#x0A;&apos;) or contains($string, &apos;&#x0D;&apos;) or contains($string, &apos;&quot;&apos;) or contains($string, &apos;\&apos;)">
					<xsl:choose>
						<xsl:when test="starts-with($string, &apos;&#x09;&apos;)">\t</xsl:when>
						<xsl:when test="starts-with($string, &apos;&#x0A;&apos;)">\n</xsl:when>
						<xsl:when test="starts-with($string, &apos;&#x0D;&apos;)">\r</xsl:when>
						<xsl:when test="starts-with($string, &apos;&quot;&apos;)">\"</xsl:when>
						<xsl:when test="starts-with($string, &apos;\&apos;)">\\</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="substring($string, 1, 1)"/>
						</xsl:otherwise>
					</xsl:choose>
					<xsl:call-template name="output-string"><xsl:with-param name="string" select="substring($string, 2)"/></xsl:call-template>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$string"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:if>
	</xsl:template>

</xsl:stylesheet>
