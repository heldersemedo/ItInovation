<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    version="1.0" xmlns:xs="http://www.w3.org/2001/XMLSchema">
    
    <xsl:variable name="className" select="/content/fields/@name"/>
    <xsl:variable name="httpServer" select="'http://localhost:8281/services'" />
    <xsl:variable name="httpsServer" select="'https://localhost:8244/services'" />    
    <xsl:template match="/">
        <wsdl:definitions targetNamespace="http://ucc_v2.tmais.cv" xmlns:http="http://schemas.xmlsoap.org/wsdl/http/" xmlns:mime="http://schemas.xmlsoap.org/wsdl/mime/" xmlns:ns="http://ucc_v2.tmais.cv" xmlns:ns1="http://org.apache.axis2/xsd" xmlns:soap="http://schemas.xmlsoap.org/wsdl/soap/" xmlns:soap12="http://schemas.xmlsoap.org/wsdl/soap12/" xmlns:wsaw="http://www.w3.org/2006/05/addressing/wsdl" xmlns:wsdl="http://schemas.xmlsoap.org/wsdl/" xmlns:xs="http://www.w3.org/2001/XMLSchema">
            <wsdl:documentation><xsl:value-of select="$className"/></wsdl:documentation>
            <wsdl:types>
                <!--CALL XSD TAMPLATE HERE-->
                <xsl:call-template name="generateSchema"/>
            </wsdl:types>           
            <xsl:for-each select="content/service/operation">
                <wsdl:message name="{@name}Request">
                    <wsdl:part element="ns:{@name}" name="parameters"/>
                </wsdl:message>
                <wsdl:message name="{@name}Response">
                    <wsdl:part element="ns:{@name}" name="parameters"/>
                </wsdl:message>
            </xsl:for-each>           
            <wsdl:portType name="{$className}ProxyPortType">
                <xsl:for-each select="content/service/operation">
                    <wsdl:operation name="{@name}">
                        <wsdl:input message="ns:{@name}Request" wsaw:Action="urn:{@name}"/>
                        <wsdl:output message="ns:{@name}Response" wsaw:Action="urn:{@name}Response"/>
                    </wsdl:operation>
                </xsl:for-each>
            </wsdl:portType>         
            <wsdl:binding name="{$className}ProxySoap11Binding" type="ns:{$className}ProxyPortType">
                <soap:binding style="document" transport="http://schemas.xmlsoap.org/soap/http"/>
                <xsl:for-each select="content/service/operation">
                    <wsdl:operation name="{@name}">
                        <soap:operation soapAction="urn:{@name}" style="document"/>
                        <wsdl:input>
                            <soap:body use="literal"/>
                        </wsdl:input>
                        <wsdl:output>
                            <soap:body use="literal"/>
                        </wsdl:output>
                    </wsdl:operation>
                </xsl:for-each>                              
            </wsdl:binding>           
            <wsdl:binding name="{$className}ProxySoap12Binding" type="ns:{$className}ProxyPortType">
                <soap12:binding style="document" transport="http://schemas.xmlsoap.org/soap/http"/>
                <xsl:for-each select="content/service/operation">
                    <wsdl:operation name="{@name}">
                        <soap12:operation soapAction="urn:{@name}" style="document"/>
                        <wsdl:input>
                            <soap12:body use="literal"/>
                        </wsdl:input>
                        <wsdl:output>
                            <soap12:body use="literal"/>
                        </wsdl:output>
                    </wsdl:operation>
                </xsl:for-each>               
            </wsdl:binding>
            <wsdl:service name="{$className}Proxy">
                <wsdl:port binding="ns:{$className}ProxySoap11Binding" name="{$className}ProxyHttpSoap11Endpoint">
                    <soap:address location="{$httpServer}/{$className}Proxy.{$className}ProxyHttpSoap11Endpoint/"/>
                </wsdl:port>
                <wsdl:port binding="ns:{$className}ProxySoap11Binding" name="{$className}ProxyHttpsSoap11Endpoint">
                    <soap:address location="{$httpsServer}/{$className}Proxy.{$className}ProxyHttpsSoap11Endpoint/"/>
                </wsdl:port>
                <wsdl:port binding="ns:{$className}ProxySoap12Binding" name="{$className}ProxyHttpSoap12Endpoint">
                    <soap12:address location="{$httpServer}/{$className}Proxy.{$className}ProxyHttpSoap12Endpoint/"/>
                </wsdl:port>
                <wsdl:port binding="ns:{$className}ProxySoap12Binding" name="{$className}ProxyHttpsSoap12Endpoint">
                    <soap12:address location="{$httpsServer}/{$className}Proxy.{$className}ProxyHttpsSoap12Endpoint/"/>
                </wsdl:port>
            </wsdl:service>
        </wsdl:definitions>
    </xsl:template>
    <!--XSD Tanplate-->
    <xsl:template name="generateSchema">
        <xs:schema attributeFormDefault="qualified" elementFormDefault="qualified" targetNamespace="http://ucc_v2.tmais.cv">
            <xs:complexType name="{$className}">
                <xs:sequence>
                    <xsl:for-each select="content/fields/field">
                        <xsl:choose>
                            <xsl:when test="@type='complextype'">
                                <xs:element name="{@name}Collection" type="ns:{@name}Collection" minOccurs="0" />
                            </xsl:when>
                            <xsl:otherwise>
                                <xs:element name="{@name}" type="xs:{@type}" minOccurs="0" />
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:for-each>
                </xs:sequence>
            </xs:complexType>            
            <!--CLASS-->
            <xsl:for-each select="content/fields/field[@type='complextype']">              
                <xs:complexType name="{@name}Collection">
                    <xs:sequence>
                        <xs:element maxOccurs="unbounded" minOccurs="0" name="{@name}" >
                            <xs:complexType>
                                <xs:sequence>
                                    <xsl:for-each select="./field">
                                        <xs:element name="{@name}" type="xs:{@type}" minOccurs="0" />
                                    </xsl:for-each>
                                </xs:sequence>
                            </xs:complexType>
                        </xs:element>
                    </xs:sequence>
                </xs:complexType>               
            </xsl:for-each>
            <!---->
            <xsl:for-each select="content/service/operation">
                <xs:element name="{@name}" type="ns:{@name}"/>
                <xs:complexType name="{@name}">
                    <xs:sequence>
                        <xs:element name="{$className}" type="ns:{$className}" minOccurs="0" />
                    </xs:sequence>
                </xs:complexType>
            </xsl:for-each>   
        </xs:schema>     
    </xsl:template>
</xsl:stylesheet>