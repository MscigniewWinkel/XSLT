<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:saxon="http://icl.com/saxon" extension-element-prefixes="saxon" version="3.0" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:cac="urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2" xmlns:cbc="urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2" xmlns:cancac="urn:oasis:names:specification:ubl:schema:xsd:CanonicalAggregateComponents-2" xmlns:cancbc="urn:oasis:names:specification:ubl:schema:xsd:CanonicalBasicComponents-2" xmlns:exsl="http://exslt.org/common">
    
    <!-- This is basic visualization, made for demonstrational purposes. 
    Owner: Mścigniew Winkel -->
    
        
    <xsl:param name="language" />
        
    <xsl:variable name="lang" select="document($language)/*" />
    
    <xsl:decimal-format name="comma_space" decimal-separator="," grouping-separator="&#160;" />
    
    <xsl:attribute-set name="font-regular">
        <xsl:attribute name="font-size">8px</xsl:attribute>
    </xsl:attribute-set>
    
    <xsl:attribute-set name="font-header">
        <xsl:attribute name="font-size">10px</xsl:attribute>
    </xsl:attribute-set>
    
    <xsl:attribute-set name="font-title">
        <xsl:attribute name="font-size">11px</xsl:attribute>
        <xsl:attribute name="font-weight">bold</xsl:attribute>
    </xsl:attribute-set>
    
    <xsl:template match="/">
        <fo:root xmlns:fo="http://www.w3.org/1999/XSL/Format">
            <fo:layout-master-set>
                <!-- page master for the first page-->
                <fo:simple-page-master master-name="first-page" page-width="21cm" page-height="29.7cm" margin-left="14mm" margin-right="6mm" >
                    <fo:region-body margin-top="100mm"  margin-bottom="30mm"/>    
                    <fo:region-before region-name="first-page-header" margin-top="17mm" />
                    <fo:region-after region-name="first-page-footer" extent="25mm"/>
                </fo:simple-page-master>
                <!--page master for all others pages-->
                <fo:simple-page-master master-name="other-page" page-width="21cm" page-height="29.7cm" margin-left="14mm" margin-right="6mm">
                    <fo:region-body margin-top="30mm" margin-bottom="30mm"/>
                    <fo:region-before region-name="rest-page-header" margin-top="17mm" />
                    <fo:region-after region-name="rest-page-footer" extent="25mm" />
                </fo:simple-page-master>
                <fo:page-sequence-master master-name="pages">
                    <fo:single-page-master-reference page-position="first" master-reference="first-page" />
                    <fo:repeatable-page-master-alternatives>
                        <fo:conditional-page-master-reference page-position="rest" master-reference="other-page" />
                    </fo:repeatable-page-master-alternatives>
                </fo:page-sequence-master>
            </fo:layout-master-set>
            
            
            <fo:page-sequence master-reference="pages" font-family="Arial">                
                
                <!-- FIRST PAGE HEADER -->
                <fo:static-content flow-name="first-page-header" xsl:use-attribute-sets="font-header" >
                    <xsl:call-template name="header_template"/>
                </fo:static-content>
                
                
                <!-- REST PAGE HEADER -->
                <fo:static-content flow-name="rest-page-header">
                    
                    <xsl:call-template name="document-type-and-page-number" />
                    
                    <!-- INVOICE DATE AND NUMBER -->
                    <fo:block-container position="absolute" top="15mm"  font-size="7.5px" >
                        <fo:table table-layout="fixed" width="60mm">
                            <fo:table-body>
                                <fo:table-row>
                                    <fo:table-cell margin-left="1mm">
                                        <fo:block>
                                            <xsl:value-of select="$lang/e[@name='IssueDate']" />
                                        </fo:block>
                                        <fo:block>
                                            <xsl:apply-templates select="/*/cbc:IssueDate"/>
                                        </fo:block>
                                    </fo:table-cell>
                                    <fo:table-cell margin-left="1mm">
                                        <fo:block>
                                            <xsl:value-of select="$lang/e[@name='AccountingSupplierInv']" />
                                        </fo:block>
                                        <fo:block>
                                            <xsl:value-of select="/*/cac:AccountingSupplierParty/cac:Party/cac:PartyName/cbc:Name" />
                                        </fo:block>
                                    </fo:table-cell>                                      
                                </fo:table-row>
                            </fo:table-body>
                        </fo:table>
                    </fo:block-container>
                </fo:static-content>
                
                
                <!-- FIRST PAGE FOOTER -->
                <fo:static-content flow-name="first-page-footer" xsl:use-attribute-sets="font-regular">
                    <xsl:call-template name="footer" />
                </fo:static-content>
                
                
                <!-- REST PAGE FOOTER -->
                <fo:static-content flow-name="rest-page-footer" xsl:use-attribute-sets="font-regular">
                    <xsl:call-template name="footer" />
                </fo:static-content>
                
                <!--INVOICE BODY-->
                <fo:flow flow-name="xsl-region-body">
                    
                    <!-- CONTRACT AND INVOICING PERIOD INFORMATION -->
                    <xsl:if test="/*/cac:ContractDocumentReference">
                        <fo:block-container font-size="8px" margin-bottom="2mm">
                            <fo:table>
                                <fo:table-column column-width="60mm" column-number="1"/>
                                <fo:table-column column-number="2"/>                                
                                <fo:table-body>
                                    <fo:table-row>
                                        <fo:table-cell>
                                            <fo:block font-weight="bold"><xsl:value-of select="$lang/e[@name='ContractNumber']" /></fo:block>
                                        </fo:table-cell>
                                        <fo:table-cell>
                                            <fo:block><xsl:value-of select="/*/cac:ContractDocumentReference/cbc:ID"/></fo:block>
                                        </fo:table-cell>
                                    </fo:table-row>
                                    <fo:table-row>
                                        <fo:table-cell>
                                            <fo:block font-weight="bold"><xsl:value-of select="$lang/e[@name='ContractStartDate']" /></fo:block>
                                        </fo:table-cell>
                                        <fo:table-cell>
                                            <fo:block><xsl:apply-templates select="/*/cac:ContractDocumentReference/cac:ValidityPeriod/cbc:StartDate"/></fo:block>
                                        </fo:table-cell>
                                    </fo:table-row>
                                    <fo:table-row>
                                        <fo:table-cell>
                                            <fo:block font-weight="bold"><xsl:value-of select="$lang/e[@name='ClosingDate']" /></fo:block>
                                        </fo:table-cell>
                                        <fo:table-cell>
                                            <fo:block><xsl:apply-templates select="/*/cac:ContractDocumentReference/cac:ValidityPeriod/cbc:EndDate"/></fo:block>
                                        </fo:table-cell>
                                    </fo:table-row>
                                    <fo:table-row>
                                        <fo:table-cell>
                                            <fo:block font-weight="bold"><xsl:value-of select="$lang/e[@name='BillingPeriodStartDate']" /></fo:block>
                                        </fo:table-cell>
                                        <fo:table-cell>
                                            <fo:block><xsl:apply-templates select="/*/cac:InvoicePeriod/cbc:StartDate"/></fo:block>
                                        </fo:table-cell>
                                    </fo:table-row>
                                    <fo:table-row>
                                        <fo:table-cell>
                                            <fo:block font-weight="bold"><xsl:value-of select="$lang/e[@name='BillingPeriodExpirationDate']" /></fo:block>
                                        </fo:table-cell>
                                        <fo:table-cell>
                                            <fo:block><xsl:apply-templates select="/*/cac:InvoicePeriod/cbc:EndDate"/></fo:block>
                                        </fo:table-cell>
                                    </fo:table-row>
                                </fo:table-body>
                            </fo:table>
                        </fo:block-container>
                    </xsl:if>
                    
                    <!-- DOCUMENT NOTE -->
                    <fo:block-container font-size="8px" margin-bottom="2mm">
                        <xsl:if test="/*/cac:AdditionalDocumentReference">                            
                            <fo:table>
                                <fo:table-body>
                                    <xsl:for-each select="/*/cac:AdditionalDocumentReference">
                                        <fo:table-row>
                                            <fo:table-cell width="45mm" font-weight="bold">
                                                <fo:block>
                                                    <xsl:if test="position() = 1">
                                                        <xsl:value-of select="$lang/e[@name='AdditionalDocumentReferenceID']" />                                                        
                                                    </xsl:if>
                                                </fo:block>
                                            </fo:table-cell>
                                            <fo:table-cell width="25mm">
                                                <fo:block>
                                                    <xsl:value-of select="./cbc:ID/@schemeID" />
                                                </fo:block>
                                            </fo:table-cell>
                                            <fo:table-cell>
                                                <fo:block>
                                                    <xsl:value-of select="./cbc:ID" />
                                                </fo:block>
                                            </fo:table-cell>
                                        </fo:table-row>
                                    </xsl:for-each>
                                </fo:table-body>
                            </fo:table>
                        </xsl:if>
                        <xsl:if test="/*/cac:Delivery/cac:DeliveryTerms/cbc:SpecialTerms">                            
                            <fo:table>
                                <fo:table-body>
                                    <xsl:for-each select="/*/cac:Delivery/cac:DeliveryTerms/cbc:SpecialTerms">
                                        <fo:table-row>
                                            <fo:table-cell width="45mm" font-weight="bold">
                                                <fo:block>
                                                    <xsl:if test="position() = 1">
                                                        <xsl:value-of select="$lang/e[@name='DeliveryTerms']" />                                                        
                                                    </xsl:if>
                                                </fo:block>
                                            </fo:table-cell>
                                            <fo:table-cell>
                                                <fo:block>
                                                    <xsl:value-of select="." />
                                                </fo:block>
                                            </fo:table-cell>
                                        </fo:table-row>
                                    </xsl:for-each>
                                </fo:table-body>
                            </fo:table>
                        </xsl:if>
                        <xsl:if test="/*/cbc:Note">                            
                            <fo:table>
                                <fo:table-body>
                                    <xsl:for-each select="/*/cbc:Note">
                                        <fo:table-row>
                                            <fo:table-cell width="45mm" font-weight="bold">
                                                <fo:block>
                                                    <xsl:if test="position() = 1">
                                                        <xsl:value-of select="$lang/e[@name='HeaderNotes']" />                                                        
                                                    </xsl:if>
                                                </fo:block>                                            
                                            </fo:table-cell>
                                            <fo:table-cell>
                                                <fo:block>
                                                    <xsl:value-of select="." />
                                                </fo:block>
                                            </fo:table-cell>
                                        </fo:table-row>
                                    </xsl:for-each>
                                </fo:table-body>
                            </fo:table>
                        </xsl:if>
                        <xsl:if test="/*/cac:PaymentTerms">                            
                            <fo:table>
                                <fo:table-body>
                                    <xsl:for-each select="/*/cac:PaymentTerms">
                                        <fo:table-row>
                                            <fo:table-cell width="45mm" font-weight="bold">
                                                <fo:block>
                                                    <xsl:if test="position() = 1">
                                                        <xsl:value-of select="$lang/e[@name='PaymentTerms']" />                                                        
                                                    </xsl:if>
                                                </fo:block>                                            
                                            </fo:table-cell>
                                            <fo:table-cell>
                                                <fo:block>
                                                    <xsl:value-of select="cbc:Note" />
                                                </fo:block>                                        
                                            </fo:table-cell>
                                        </fo:table-row>
                                    </xsl:for-each>
                                </fo:table-body>
                            </fo:table>
                        </xsl:if>
                        <fo:block height="0px"></fo:block>
                    </fo:block-container>
                    
                    <fo:block-container>
                        <!-- TABLE HEADER -->
                        <fo:table table-layout="fixed" width="100%"  font-size="8px" >
                            <fo:table-header border-top="solid" border-bottom="solid" font-weight="bold">
                                <fo:table-row>
                                    <fo:table-cell padding="1mm" width="18mm">
                                        <fo:block>
                                            <xsl:value-of select="$lang/e[@name='LineID']" />
                                        </fo:block>
                                    </fo:table-cell>
                                    <fo:table-cell padding="1mm" width="23mm">
                                        <fo:block>
                                            <xsl:value-of select="$lang/e[@name='SellersItemIdentification']" />
                                        </fo:block>
                                    </fo:table-cell>                                   
                                    <fo:table-cell padding="1mm">
                                        <fo:block>
                                            <xsl:value-of select="$lang/e[@name='ItemName']" />
                                        </fo:block>
                                    </fo:table-cell>
                                    <fo:table-cell padding="1mm" width="20mm" text-align="center">
                                        <fo:block>
                                            <xsl:value-of select="$lang/e[@name='Quantity']" />
                                        </fo:block>
                                    </fo:table-cell>
                                    <fo:table-cell padding="1mm" width="23mm">
                                        <fo:block>
                                            <xsl:value-of select="$lang/e[@name='QuantityUnitCode']" />
                                        </fo:block>
                                    </fo:table-cell>
                                    <fo:table-cell padding="1mm" width="20.5mm" text-align="end">
                                        <fo:block>
                                            <xsl:value-of select="$lang/e[@name='PriceUnit']" />
                                        </fo:block>
                                    </fo:table-cell>
                                    <fo:table-cell padding="1mm" width="16mm" margin-left="1mm" text-align="end" >
                                        <fo:block>
                                            <xsl:value-of select="$lang/e[@name='LineTaxDetails']" />
                                        </fo:block>
                                    </fo:table-cell>
                                    <fo:table-cell padding="1mm" width="25mm" margin-left="1mm" text-align="end">
                                        <fo:block>
                                            <xsl:value-of select="$lang/e[@name='LineExtensionAmountLine']" />
                                        </fo:block>
                                    </fo:table-cell>
                                </fo:table-row>
                            </fo:table-header>
                            <!-- TABLE BODY -->
                            <!-- INVOICE OR CREDIT LINES -->
                            <fo:table-body>
                                <xsl:apply-templates select="/*/cac:InvoiceLine | /*/cac:CreditNoteLine"/>
                            </fo:table-body>
                        </fo:table>
                        
                        <!-- ALLOWANCES -->
                        <xsl:call-template name="AllowanceSummary"/>
                        
                        <!-- SUMMARY -->
                        <xsl:call-template name="InvoiceSummary"/>
                        
                    </fo:block-container>
                    <fo:block id="end" />
                </fo:flow>
                
            </fo:page-sequence>
        </fo:root>
    </xsl:template>
    
    <!-- TEMPLATES -->
    
    <xsl:template name="document-type-and-page-number">
        
        <!-- TITLE: "INVOICE" -->
        <fo:block-container position="absolute" top="17mm" margin-left="105mm" xsl:use-attribute-sets="font-title">
            <fo:block wrap-option="no-wrap">
                <xsl:choose>
                    <xsl:when test="name(/*) = 'Invoice'">
                        <xsl:value-of select="$lang/e[@name='InvoiceID']" /> &#160; <xsl:value-of select="/*/cbc:ID" />
                    </xsl:when>
                    <xsl:when test="name(/*) = 'CreditNote'">
                        <xsl:value-of select="$lang/e[@name='CreditNoteID']" /> &#160; <xsl:value-of select="/*/cbc:ID" />
                    </xsl:when>
                </xsl:choose>
            </fo:block>
        </fo:block-container>
        
        <!-- PAGE NUMBER -->
        <fo:block-container position="absolute" top="17mm" margin-left="185mm" xsl:use-attribute-sets="font-title">
            <fo:block text-align="right">
                <fo:page-number />&#160;/&#160;<fo:page-number-citation-last ref-id="end" />
            </fo:block>
        </fo:block-container>
        
    </xsl:template>
    
    <!-- HEADER TEMPLATES -->
    
    <xsl:template name="header_template">
        
        <!-- SENDERS INFORMATION -->
        <fo:block-container position="absolute" top="16mm" left="4mm" width="54mm">
            <fo:table>
                <fo:table-body>
                    <fo:table-row>
                        <fo:table-cell font-size="9px">
                            <fo:block>
                                <xsl:value-of select="/*/cac:AccountingSupplierParty/cac:Party/cac:PartyName/cbc:Name" />
                            </fo:block>
                            <fo:block>
                                <xsl:value-of select="/*/cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cbc:StreetName" />
                            </fo:block>
                            <fo:block>
                                <xsl:value-of select="/*/cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cbc:PostalZone" />&#160;
                                <xsl:value-of select="/*/cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cbc:CityName" />,&#160;
                                <xsl:value-of select="/*/cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode" />
                            </fo:block>
                        </fo:table-cell>
                    </fo:table-row>
                </fo:table-body>
            </fo:table>
        </fo:block-container>        
        
        <!-- RECIPIENT INFORMATION -->
        <fo:block-container position="absolute" top="42mm" left="108mm" font-size="10px">
            <fo:block font-weight="bold">
                <xsl:value-of select="$lang/e[@name='AccountingCustomerInv']" />
            </fo:block>
            <fo:block>
                <xsl:value-of select="/*/cac:AccountingCustomerParty/cac:Party/cac:PartyName/cbc:Name" />
            </fo:block>
            <fo:block>
                <xsl:value-of select="/*/cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:StreetName" />
            </fo:block>
            <fo:block>
                <xsl:if test="/*/cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:PostalZone">
                    <xsl:value-of select="/*/cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:PostalZone" />&#160;
                </xsl:if>
                <xsl:if test="/*/cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:CityName">
                    <xsl:value-of select="/*/cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:CityName" />,&#160;
                </xsl:if>
                <xsl:value-of select="/*/cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode" />
            </fo:block>
        </fo:block-container>
        
        <!-- DELIVERY ADDRESS -->
        <fo:block-container position="absolute" top="75mm" left="108mm" font-size="10px">
            <xsl:choose>
                <xsl:when test="/*/cac:Delivery/cac:DeliveryLocation">
                    <fo:block font-weight="bold">
                        <xsl:value-of select="$lang/e[@name='DeliveryLocation']" />
                    </fo:block>
                    <fo:block>
                        <xsl:value-of select="/*/cac:Delivery/cac:DeliveryLocation/cac:Address/cbc:Department" />
                    </fo:block>
                    <fo:block>
                        <xsl:value-of select="/*/cac:Delivery/cac:DeliveryParty/cac:PartyName/cbc:Name" />
                    </fo:block>
                    <fo:block>
                        <xsl:value-of select="/*/cac:Delivery/cac:DeliveryLocation/cbc:Name" />
                    </fo:block>
                    <fo:block>
                        <xsl:value-of select="/*/cac:Delivery/cac:DeliveryLocation/cac:Address/cbc:StreetName" />
                    </fo:block>
                    <fo:block>
                        <xsl:if test="/*/cac:Delivery/cac:DeliveryLocation/cac:Address/cbc:PostalZone">
                            <xsl:value-of select="/*/cac:Delivery/cac:DeliveryLocation/cac:Address/cbc:PostalZone" />&#160;
                        </xsl:if>
                        <xsl:if test="/*/cac:Delivery/cac:DeliveryLocation/cac:Address/cbc:CityName">
                            <xsl:value-of select="/*/cac:Delivery/cac:DeliveryLocation/cac:Address/cbc:CityName" />,&#160;
                        </xsl:if>
                        <xsl:value-of select="/*/cac:Delivery/cac:DeliveryLocation/cac:Address/cac:Country/cbc:IdentificationCode" />
                    </fo:block>
                </xsl:when>
                <xsl:otherwise>
                    <fo:block>&#160;</fo:block>
                </xsl:otherwise>
            </xsl:choose>
        </fo:block-container>
        
        
        <!-- DOCUMENT TYPE AND PAGE NUMBER -->
        <xsl:call-template name="document-type-and-page-number" />
        
        <!-- INVOICE DETAILED TABLE -->
        <xsl:call-template name="header_details_table_SE"/>
        
    </xsl:template>
    
    
    <!-- Header detailed table for Finland and Norway -->
    <xsl:template name="header_details_table">
        <fo:block-container position="absolute" top="25mm"  font-size="7.5px" >
            <fo:table table-layout="fixed" margin-left="106mm" width="84mm">
                <fo:table-body>
                    <!-- ROW-1 -->
                    <fo:table-row>
                        <fo:table-cell margin-left="1mm">
                            <fo:block font-weight="bold">
                                <xsl:value-of select="$lang/e[@name='IssueDate']" />&#160;
                            </fo:block>
                            <fo:block>
                                <xsl:apply-templates select="/*/cbc:IssueDate"/>&#160;
                            </fo:block>
                        </fo:table-cell>
                        <fo:table-cell margin-left="1mm">
                            <fo:block font-weight="bold">
                                <xsl:value-of select="$lang/e[@name='SalesOrderID']" />&#160;
                            </fo:block>
                            <fo:block>
                                <xsl:value-of select="/*/cac:OrderReference/cbc:SalesOrderID" />&#160;
                            </fo:block>
                        </fo:table-cell>                                      
                    </fo:table-row>
                    <!-- ROW-2 -->
                    <fo:table-row border-top="1px solid lightgrey">
                        <fo:table-cell margin-left="1mm">
                            <fo:block font-weight="bold">
                                <xsl:value-of select="$lang/e[@name='ActualDeliveryDate']" />&#160;
                            </fo:block>
                            <fo:block>
                                <xsl:apply-templates select="/*/cac:Delivery/cbc:ActualDeliveryDate" />&#160;
                            </fo:block>
                        </fo:table-cell>                                      
                        <fo:table-cell margin-left="1mm">
                            <fo:block font-weight="bold">
                                <xsl:value-of select="$lang/e[@name='OrderReferenceID']" />&#160;
                            </fo:block>
                            <fo:block>
                                <xsl:value-of select="/*/cac:OrderReference/cbc:ID" />&#160;
                            </fo:block>
                        </fo:table-cell>
                    </fo:table-row>
                    <!-- ROW-3 -->
                    <fo:table-row border-top="1px solid lightgrey">
                        <fo:table-cell margin-left="1mm">
                            <fo:block font-weight="bold">
                                <xsl:value-of select="$lang/e[@name='PaymentDueDate']" />&#160;
                            </fo:block>
                            <fo:block>
                                <xsl:apply-templates select="/*/cbc:DueDate" />&#160;
                            </fo:block>
                        </fo:table-cell>
                        <fo:table-cell margin-left="1mm">
                            <fo:block font-weight="bold">
                                <xsl:value-of select="$lang/e[@name='BuyerReference']" />&#160;
                            </fo:block>
                            <fo:block>
                                <xsl:value-of select="/*/cbc:BuyerReference"/>&#160;
                            </fo:block>
                        </fo:table-cell>                                      
                    </fo:table-row>
                    <!-- ROW-4 -->
                    <fo:table-row border-top="1px solid lightgrey">
                        <fo:table-cell margin-left="1mm">
                            <fo:block font-weight="bold">
                                <xsl:value-of select="$lang/e[@name='AccSupContact']" />&#160;
                            </fo:block>
                            <fo:block>
                                <xsl:value-of select="/*/cac:AccountingSupplierParty/cac:Party/cac:Contact/cbc:Name" />&#160;
                            </fo:block>
                        </fo:table-cell>
                        <fo:table-cell margin-left="1mm">
                            <fo:block font-weight="bold">
                                <xsl:value-of select="$lang/e[@name='ElectronicMail']" />&#160;
                            </fo:block>
                            <fo:block>
                                <xsl:call-template name="zero_width_space_1">
                                    <xsl:with-param name="data" select="/*/cac:AccountingSupplierParty/cac:Party/cac:Contact/cbc:ElectronicMail"/>
                                </xsl:call-template>
                            </fo:block>
                        </fo:table-cell>
                    </fo:table-row>
                </fo:table-body>
            </fo:table>
        </fo:block-container>
    </xsl:template>
    
    <xsl:template name="header_details_table_SE">
        <fo:block-container position="absolute" top="55mm"  font-size="7.5px" >
            <fo:table table-layout="fixed" margin-left="4mm" width="84mm">
                <fo:table-body>
                    <!-- ROW-1 -->
                    <fo:table-row>
                        <fo:table-cell margin-left="1mm">
                            <fo:block font-weight="bold">
                                <xsl:value-of select="$lang/e[@name='IssueDate']" />&#160;
                            </fo:block>
                        </fo:table-cell>
                        <fo:table-cell>
                            <fo:block>
                                <xsl:apply-templates select="/*/cbc:IssueDate"/>&#160;
                            </fo:block>
                        </fo:table-cell>
                    </fo:table-row>
                    <!-- ROW-2 -->
                    <fo:table-row>
                        <fo:table-cell margin-left="1mm">
                            <fo:block font-weight="bold">
                                <xsl:value-of select="$lang/e[@name='SalesOrderID']" />&#160;
                            </fo:block>
                        </fo:table-cell>
                        <fo:table-cell>
                            <fo:block>
                                <xsl:value-of select="/*/cac:OrderReference/cbc:SalesOrderID" />&#160;
                            </fo:block>
                        </fo:table-cell>                                      
                    </fo:table-row>
                    <!-- ROW-3 -->
                    <fo:table-row>
                        <fo:table-cell margin-left="1mm">
                            <fo:block font-weight="bold">
                                <xsl:value-of select="$lang/e[@name='ActualDeliveryDate']" />&#160;
                            </fo:block>
                        </fo:table-cell>
                        <fo:table-cell>
                            <fo:block>
                                <xsl:apply-templates select="/*/cac:Delivery/cbc:ActualDeliveryDate" />&#160;
                            </fo:block>
                        </fo:table-cell>
                    </fo:table-row>
                    <!-- ROW-4 -->
                    <fo:table-row>
                        <fo:table-cell margin-left="1mm">
                            <fo:block font-weight="bold">
                                <xsl:value-of select="$lang/e[@name='OrderReferenceID']" />&#160;
                            </fo:block>
                        </fo:table-cell>
                        <fo:table-cell>
                            <fo:block>
                                <xsl:value-of select="/*/cac:OrderReference/cbc:ID" />&#160;
                            </fo:block>
                        </fo:table-cell>
                    </fo:table-row>
                    <!-- ROW-5 -->
                    <fo:table-row>
                        <fo:table-cell margin-left="1mm">
                            <fo:block font-weight="bold">
                                <xsl:value-of select="$lang/e[@name='PaymentDueDate']" />&#160;
                            </fo:block>
                        </fo:table-cell>
                        <fo:table-cell>
                            <fo:block>
                                <xsl:apply-templates select="/*/cbc:DueDate" />&#160;
                            </fo:block>
                        </fo:table-cell>
                    </fo:table-row>
                    <!-- ROW-6 -->
                    <fo:table-row>
                        <fo:table-cell margin-left="1mm">
                            <fo:block font-weight="bold">
                                <xsl:value-of select="$lang/e[@name='BuyerReference']" />&#160;
                            </fo:block>
                        </fo:table-cell>
                        <fo:table-cell>
                            <fo:block>
                                <xsl:value-of select="/*/cbc:BuyerReference"/>&#160;
                            </fo:block>
                        </fo:table-cell>                                      
                    </fo:table-row>
                    <!-- ROW-7 -->
                    <fo:table-row>
                        <fo:table-cell margin-left="1mm">
                            <fo:block font-weight="bold">
                                <xsl:value-of select="$lang/e[@name='AccSupContact']" />&#160;
                            </fo:block>
                        </fo:table-cell>
                        <fo:table-cell>
                            <fo:block>
                                <xsl:value-of select="/*/cac:AccountingSupplierParty/cac:Party/cac:Contact/cbc:Name" />&#160;
                            </fo:block>
                        </fo:table-cell>
                    </fo:table-row>
                    <!-- ROW-8 -->
                    <fo:table-row>
                        <fo:table-cell margin-left="1mm">
                            <fo:block font-weight="bold">
                                <xsl:value-of select="$lang/e[@name='ElectronicMail']" />&#160;
                            </fo:block>
                        </fo:table-cell>
                        <fo:table-cell>
                            <fo:block>
                                <xsl:call-template name="zero_width_space_1">
                                    <xsl:with-param name="data" select="/*/cac:AccountingSupplierParty/cac:Party/cac:Contact/cbc:ElectronicMail"/>
                                </xsl:call-template>
                            </fo:block>
                        </fo:table-cell>
                    </fo:table-row>
                </fo:table-body>
            </fo:table>
        </fo:block-container>
    </xsl:template>
    
    <!-- FOOTER TEMPLATES -->
    <xsl:template name="footer">
        <fo:block-container font-size="7px">
            <fo:table>
                <fo:table-body text-align="center" >
                    <fo:table-row border-top="solid" text-align="left" width="40mm">
                        <fo:table-cell>
                            <fo:block padding-top="1mm">
                                <xsl:value-of select="/*/cac:AccountingSupplierParty/cac:Party/cac:PartyName/cbc:Name" />
                            </fo:block>
                            <fo:block padding-top="1mm">
                                <xsl:value-of select="/*/cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cbc:StreetName" />
                            </fo:block>
                            <fo:block padding-top="1mm">
                                <xsl:value-of select="/*/cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cbc:PostalZone" />
                                &#160;
                                <xsl:value-of select="/*/cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cbc:CityName" />,
                                &#160;
                                <xsl:value-of select="/*/cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode" />
                            </fo:block>
                        </fo:table-cell>
                        <fo:table-cell width="20mm">
                            <fo:block padding-top="1mm" font-weight="bold">
                                <xsl:value-of select="$lang/e[@name='PartyID']" />
                            </fo:block>
                            <fo:block padding-top="1mm" font-weight="bold">
                                <xsl:value-of select="$lang/e[@name='RegistrationName']" />
                            </fo:block>
                            <fo:block padding-top="1mm"  font-weight="bold">
                                <xsl:value-of select="/*/cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme/cac:TaxScheme/cbc:ID" />
                            </fo:block>
                        </fo:table-cell>
                        <fo:table-cell>
                            <fo:block padding-top="1mm">
                                <xsl:apply-templates select="/*/cac:AccountingSupplierParty/cac:Party/cac:PartyIdentification/cbc:ID/@schemeID"/><xsl:value-of select="/*/cac:AccountingSupplierParty/cac:Party/cac:PartyIdentification/cbc:ID"/>&#160;
                            </fo:block>
                            <fo:block padding-top="1mm">
                                <xsl:value-of select="/*/cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity/cbc:RegistrationName"/>&#160;
                            </fo:block>
                            <fo:block padding-top="1mm">
                                <xsl:apply-templates select="/*/cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme/cbc:CompanyID/@schemeID"/><xsl:value-of select="/*/cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme/cbc:CompanyID"/>&#160;
                            </fo:block>
                        </fo:table-cell>
                        <fo:table-cell font-weight="bold" width="40mm">
                            <fo:block padding-top="1mm" margin-left="1mm"><xsl:value-of select="$lang/e[@name='PayeeFinancialAccountID']" /></fo:block>
                            <fo:block padding-top="1mm" margin-left="1mm"><xsl:value-of select="$lang/e[@name='FinancialInstitutionID']" /></fo:block>
                            <fo:block padding-top="1mm" margin-left="1mm"><xsl:value-of select="$lang/e[@name='PaymentRef']" /></fo:block>
                        </fo:table-cell>
                        <fo:table-cell width="50mm">
                            <fo:block padding-top="1mm" margin-left="1mm"><xsl:value-of select="/*/cac:PaymentMeans[1]/cac:PayeeFinancialAccount/cbc:ID" /><xsl:apply-templates select="/*/cac:PaymentMeans[1]/cac:PayeeFinancialAccount/cbc:ID/@schemeID" />&#160;</fo:block>
                            <fo:block padding-top="1mm" margin-left="1mm">
                                <xsl:choose>
                                    <xsl:when test="/*/cac:PaymentMeans[1]/cac:PayeeFinancialAccount[1]/cac:FinancialInstitutionBranch[1]/cbc:ID[1] != ''">
                                        <xsl:value-of select="/*/cac:PaymentMeans[1]/cac:PayeeFinancialAccount[1]/cac:FinancialInstitutionBranch[1]/cbc:ID[1]"/>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:value-of select="/*/cac:PaymentMeans[1]/cac:PayeeFinancialAccount/cac:FinancialInstitutionBranch/cac:FinancialInstitution/cbc:ID" />
                                    </xsl:otherwise>
                                </xsl:choose>
                                <xsl:apply-templates select="/*/cac:PaymentMeans[1]/cac:PayeeFinancialAccount/cac:FinancialInstitutionBranch/cac:FinancialInstitution/cbc:ID/@schemeID" />&#160;</fo:block>
                            <fo:block padding-top="1mm" margin-left="1mm"><xsl:value-of select="/*/cac:PaymentMeans[1]/cbc:PaymentID" />&#160;</fo:block>
                        </fo:table-cell>
                    </fo:table-row>
                </fo:table-body>
            </fo:table>
        </fo:block-container>
    </xsl:template>
    
    <!-- INVOICE LINE / CREDIT LINE TEMPLATES -->
    
    <xsl:template match="/*/cac:InvoiceLine | /*/cac:CreditNoteLine">
        <fo:table-row>
            <!-- Line number/id -->
            <fo:table-cell padding="1mm" padding-top="2mm">
                <fo:block>
                    <xsl:call-template name="zero_width_space_1">
                        <xsl:with-param name="data" select="cbc:ID"/>
                    </xsl:call-template>
                </fo:block>
            </fo:table-cell>
            <!-- Item number -->
            <fo:table-cell padding="1mm" padding-top="2mm">
                <fo:block>
                    <xsl:call-template name="zero_width_space_1">
                        <xsl:with-param name="data" select="cac:Item/cac:SellersItemIdentification/cbc:ID"/>
                    </xsl:call-template>
                </fo:block>
            </fo:table-cell>
            <!-- Article name -->
            <fo:table-cell padding="1mm" padding-top="2mm">
                <fo:block>
                    <xsl:value-of select="cac:Item/cbc:Name" />
                </fo:block>
            </fo:table-cell>
            <!-- Quantity -->
            <fo:table-cell padding="1mm" padding-top="2mm" text-align="center" >
                <fo:block>
                    <xsl:apply-templates select="cbc:CreditedQuantity | cbc:InvoicedQuantity" />
                </fo:block>
            </fo:table-cell>
            <!-- Quantity Code -->
            <fo:table-cell padding="1mm" padding-top="2mm">
                <fo:block>
                    <xsl:value-of select="cbc:CreditedQuantity/@unitCode | cbc:InvoicedQuantity/@unitCode" /> &#160;
                    <!-- <fo:inline font-size="7px"><xsl:apply-templates select="cbc:CreditedQuantity/@unitCodeListID | cbc:InvoicedQuantity/@unitCodeListID"/></fo:inline> -->
                </fo:block>
            </fo:table-cell>
            <!-- Netto unit price -->
            <fo:table-cell padding="1mm" padding-top="2mm" text-align="end">
                <fo:block keep-together.within-line="always">
                    <xsl:apply-templates select="cac:Price/cbc:PriceAmount" />
                    <!-- &#160;<xsl:value-of select="cac:Price/cbc:PriceAmount/@currencyID"/> -->
                </fo:block>
                <fo:block font-size="7px">
                    <xsl:if test="cac:Price/cbc:BaseQuantity != ''">/</xsl:if>&#160;<xsl:apply-templates select="cac:Price/cbc:BaseQuantity"/>&#160;<xsl:value-of select="cac:Price/cbc:BaseQuantity/@unitCode"/>                    
                </fo:block>
            </fo:table-cell>
            <!-- Tax details -->
            <fo:table-cell padding="1mm" padding-top="2mm" text-align="end">
                <fo:block keep-together.within-line="always">
                    <xsl:value-of select="cac:Item/cac:ClassifiedTaxCategory/cbc:ID" />,&#160;<xsl:apply-templates select="cac:Item/cac:ClassifiedTaxCategory/cbc:Percent" />%
                </fo:block>
            </fo:table-cell>
            <!-- Line total amount -->
            <fo:table-cell padding="1mm" padding-top="2mm" text-align="end">
                <fo:block keep-together.within-line="always">
                    <xsl:apply-templates select="cbc:LineExtensionAmount"/>
                </fo:block>
                <!-- <fo:block><xsl:value-of select="cbc:LineExtensionAmount/@currencyID"/></fo:block> -->
            </fo:table-cell>
        </fo:table-row>
        <!-- LINE NOTES -->
        <xsl:for-each select="cbc:Note">
            <fo:table-row font-size="7px" keep-with-previous.within-page="always">
                <fo:table-cell number-columns-spanned="2">
                    <fo:block>&#160;</fo:block>
                </fo:table-cell>
                <fo:table-cell font-weight="bold">
                    <fo:block>
                        <xsl:if test="position() = 1">
                            <xsl:value-of select="$lang/e[@name='LineNotes']" />                            
                        </xsl:if>
                    </fo:block>
                </fo:table-cell>
                <fo:table-cell number-columns-spanned="5">
                    <fo:block>
                        <xsl:value-of select="."/>
                    </fo:block>
                </fo:table-cell>
            </fo:table-row>
        </xsl:for-each>
        <!-- ADDITIONAL ITEM INFORMATION -->
        <xsl:if test="cac:Item/cac:StandardItemIdentification/cbc:ID">
            <fo:table-row font-size="7px" keep-with-previous.within-page="always">
                <fo:table-cell number-columns-spanned="2">
                    <fo:block>&#160;</fo:block>
                </fo:table-cell>
                <fo:table-cell font-weight="bold">
                    <fo:block><xsl:value-of select="$lang/e[@name='StandardItemIdentification']" /></fo:block>
                </fo:table-cell>
                <fo:table-cell number-columns-spanned="5">
                    <fo:block>
                        <xsl:value-of select="cac:Item/cac:StandardItemIdentification/cbc:ID"/><xsl:apply-templates select="cac:Item/cac:StandardItemIdentification/cbc:ID/@schemeID"/>
                    </fo:block>
                </fo:table-cell>
            </fo:table-row>
        </xsl:if>
        <xsl:if test="cac:Item/cbc:Description != cac:Item/cbc:Name">
            <fo:table-row font-size="7px" keep-with-previous.within-page="always">
                <fo:table-cell number-columns-spanned="2">
                    <fo:block>&#160;</fo:block>    
                </fo:table-cell>
                <fo:table-cell font-weight="bold">
                    <fo:block><xsl:value-of select="$lang/e[@name='ItemDescription']" /></fo:block>
                </fo:table-cell>
                <fo:table-cell number-columns-spanned="5">
                    <fo:block>
                        <xsl:value-of select="cac:Item/cbc:Description"/>
                    </fo:block>
                </fo:table-cell>
            </fo:table-row>
        </xsl:if>
        <xsl:for-each select="cac:Price/cac:AllowanceCharge">
            <xsl:if test="number(./cbc:BaseAmount) != 0 and number(./cbc:Amount)">
                <fo:table-row font-size="7px" keep-with-previous.within-page="always">
                    <fo:table-cell number-columns-spanned="2">
                        <fo:block>&#160;</fo:block>    
                    </fo:table-cell>
                    <fo:table-cell font-weight="bold">
                        <fo:block>
                            <xsl:if test="position() = 1">
                                <xsl:value-of select="$lang/e[@name='UnitNetPriceIncl']" />
                            </xsl:if>
                        </fo:block>
                    </fo:table-cell>
                    <fo:table-cell number-columns-spanned="5">
                        <fo:block>
                            <xsl:choose>
                                <xsl:when test="cbc:ChargeIndicator = 'false'">
                                    <xsl:value-of select="$lang/e[@name='ChargeIndicatorFalse']" />
                                </xsl:when>
                                <xsl:when test="cbc:ChargeIndicator = 'true'">
                                    <xsl:value-of select="$lang/e[@name='ChargeIndicatorTrue']" />
                                </xsl:when>
                            </xsl:choose>&#160;
                            <xsl:apply-templates select="cbc:Amount"/>&#160;
                            <!-- <xsl:value-of select="cbc:Amount/@currencyID"/> -->
                        </fo:block>
                    </fo:table-cell>
                </fo:table-row>                
            </xsl:if>
        </xsl:for-each>
        <xsl:if test="cac:Delivery/cbc:ActualDeliveryDate">
            <fo:table-row font-size="7px" keep-with-previous.within-page="always">
                <fo:table-cell number-columns-spanned="2">
                    <fo:block>&#160;</fo:block>    
                </fo:table-cell>
                <fo:table-cell font-weight="bold">
                    <fo:block><xsl:value-of select="$lang/e[@name='ActualDeliveryDate']" /></fo:block>
                </fo:table-cell>
                <fo:table-cell>
                    <fo:block>
                        <xsl:apply-templates select="cac:Delivery/cbc:ActualDeliveryDate"/>
                    </fo:block>
                </fo:table-cell>
            </fo:table-row>
        </xsl:if>
    </xsl:template>
    
    <xsl:template name="InvoiceSummary">
        <fo:block-container margin-top="2mm" font-size="8px" letter-spacing="0.05px">
            <fo:table table-layout="fixed" width="100%" >
                <fo:table-column column-number="1"/>
                <fo:table-column column-width="55mm" column-number="2"/>
                <fo:table-column column-width="30mm" column-number="3"/>
                <fo:table-column column-width="30mm" column-number="4"/>
                <fo:table-column column-width="20mm" column-number="5"/>
                <fo:table-body>
                    <fo:table-row font-weight="bold" keep-with-previous.within-page="always">
                        <fo:table-cell>
                            <fo:block margin-top="2mm"><xsl:value-of select="$lang/e[@name='TaxInfo']" /></fo:block>
                        </fo:table-cell>
                    </fo:table-row>
                    <fo:table-row font-weight="bold" keep-with-previous.within-page="always">
                        <fo:table-cell>
                            <fo:block margin-top="2mm"><xsl:value-of select="$lang/e[@name='TAXCategoryIDInf']" /></fo:block>
                        </fo:table-cell>
                        <fo:table-cell>
                            <fo:block margin-top="2mm"><xsl:value-of select="$lang/e[@name='TaxExemptionReason']" /></fo:block>
                        </fo:table-cell>
                        <fo:table-cell text-align="right">
                            <fo:block margin-top="2mm"><xsl:value-of select="$lang/e[@name='TaxableAmountInf']" /></fo:block>
                        </fo:table-cell>
                        <fo:table-cell text-align="right">
                            <fo:block margin-top="2mm"><xsl:value-of select="$lang/e[@name='TAXAmountInf']" /></fo:block>
                        </fo:table-cell>
                        <fo:table-cell text-align="right">
                            <fo:block margin-top="2mm"><xsl:value-of select="$lang/e[@name='PayableAmountInv']" /></fo:block>
                        </fo:table-cell>
                    </fo:table-row>
                    <xsl:for-each select="/*/cac:TaxTotal/cac:TaxSubtotal">                        
                        <fo:table-row keep-with-previous.within-page="always">
                            <fo:table-cell text-align="end">
                                <fo:block margin-top="-0.5px" margin-right="20mm">
                                    <xsl:value-of select="./cac:TaxCategory/cbc:ID"/>,&#160;<xsl:apply-templates select='./cac:TaxCategory/cbc:Percent' /> &#160;%
                                </fo:block>
                            </fo:table-cell>
                            <fo:table-cell>
                                <fo:block><xsl:value-of select="./cac:TaxCategory/cbc:TaxExemptionReason"/></fo:block>
                            </fo:table-cell>
                            <fo:table-cell>
                                <fo:block margin-top="-0.5px" text-align="right">
                                    <xsl:apply-templates select='./cbc:TaxableAmount' />                                    
                                </fo:block>
                            </fo:table-cell>
                            <fo:table-cell>
                                <fo:block margin-top="-0.5px" text-align="right">
                                    <xsl:apply-templates select='./cbc:TaxAmount' />
                                </fo:block>
                            </fo:table-cell>
                            <fo:table-cell>
                                <fo:block margin-top="-0.5px" text-align="right">&#160;</fo:block>
                            </fo:table-cell>
                        </fo:table-row>
                    </xsl:for-each>                    
                    <xsl:if test="/*/cac:LegalMonetaryTotal/cbc:PayableRoundingAmount != ''">
                        <fo:table-row keep-with-previous.within-page="always">
                            <fo:table-cell number-columns-spanned="4">
                                <fo:block><xsl:value-of select="$lang/e[@name='RoundingAmount']" /></fo:block>
                            </fo:table-cell>
                            <fo:table-cell text-align="end">
                                <fo:block><xsl:value-of select="/*/cac:LegalMonetaryTotal/cbc:PayableRoundingAmount"/></fo:block>
                            </fo:table-cell>
                        </fo:table-row>
                    </xsl:if>
                    <fo:table-row keep-with-previous.within-page="always" border-top="solid" font-weight="bold">
                        <fo:table-cell number-columns-spanned="2">
                            <fo:block margin-top="1mm" margin-bottom="2mm">
                                <xsl:value-of select="$lang/e[@name='LineTotal']" />
                            </fo:block>
                        </fo:table-cell>
                        <fo:table-cell text-align="right">
                            <fo:block margin-top="1mm" margin-bottom="2mm">
                                <xsl:apply-templates select='/*/cac:LegalMonetaryTotal/cbc:TaxExclusiveAmount' />
                            </fo:block>
                        </fo:table-cell>
                        <fo:table-cell text-align="right">
                            <fo:block margin-top="1mm" margin-bottom="2mm">
                                <xsl:apply-templates select='/*/cac:TaxTotal/cbc:TaxAmount' />
                            </fo:block>
                        </fo:table-cell>
                        <fo:table-cell text-align="right">
                            <fo:block margin-top="1mm" margin-bottom="2mm">
                                <xsl:apply-templates select='/*/cac:LegalMonetaryTotal/cbc:PayableAmount' />
                            </fo:block>
                        </fo:table-cell>
                    </fo:table-row>
                    <fo:table-row keep-with-previous.within-page="always" font-weight="bold">
                        <fo:table-cell text-align="end" number-columns-spanned="4">
                            <fo:block><xsl:value-of select="$lang/e[@name='Currency']" /></fo:block>
                        </fo:table-cell>
                        <fo:table-cell text-align="end">
                            <fo:block><xsl:value-of select="/*/cac:LegalMonetaryTotal/cbc:LineExtensionAmount/@currencyID"/></fo:block>
                        </fo:table-cell>
                    </fo:table-row>
                </fo:table-body>
            </fo:table>
        </fo:block-container>
    </xsl:template>    
    
    <xsl:template name="AllowanceSummary">
        <fo:table table-layout="fixed" width="100%"  font-size="8px">
            <fo:table-column column-number="1"/>
            <fo:table-column column-width="20mm" column-number="2"/>
            <fo:table-column column-width="35mm" column-number="3"/>
            <fo:table-column column-width="25mm" column-number="4"/>
            <fo:table-body>
                <fo:table-row keep-with-next.within-page="always">
                    <fo:table-cell>
                        <fo:block>&#160;</fo:block>
                    </fo:table-cell>
                </fo:table-row>
                <fo:table-row keep-with-next.within-page="always" >
                    <fo:table-cell>
                        <fo:block>&#160;</fo:block>
                    </fo:table-cell>
                    <fo:table-cell number-columns-spanned="2" text-align="end" border-top="solid 0.5px grey" padding="1mm" font-weight="bold" wrap-option="no-wrap">
                        <fo:block><xsl:value-of select="$lang/e[@name='LineExtensionAmountTotal']" /></fo:block>
                    </fo:table-cell>
                    <fo:table-cell text-align="end" border-top="solid 0.5px grey" padding="1mm">
                        <fo:block><xsl:apply-templates select="/*/cac:LegalMonetaryTotal/cbc:LineExtensionAmount"/>&#160;<xsl:value-of select="/*/cac:LegalMonetaryTotal/cbc:LineExtensionAmount/@currencyID"/></fo:block>
                    </fo:table-cell>
                </fo:table-row>
                <!-- PREPARE SEPARATE COPIES OF DISCOUNTS AND CHARGES -->
                <xsl:variable name="discounts">
                    <xsl:for-each select="/*/cac:AllowanceCharge">
                        <xsl:choose>
                            <xsl:when test="cbc:ChargeIndicator = 'false'">
                                <xsl:copy-of select="."/>
                            </xsl:when>
                        </xsl:choose>
                    </xsl:for-each>
                </xsl:variable>
                <xsl:variable name="charges">
                    <xsl:for-each select="/*/cac:AllowanceCharge">
                        <xsl:choose>
                            <xsl:when test="cbc:ChargeIndicator = 'true'">
                                <xsl:copy-of select="."/>
                            </xsl:when>
                        </xsl:choose>
                    </xsl:for-each>
                </xsl:variable>
                <!-- LIST ALL DISCOUNTS -->
                <xsl:for-each select="exsl:node-set($discounts)/cac:AllowanceCharge">
                    <fo:table-row keep-with-next.within-page="always" >
                        <fo:table-cell>
                            <fo:block>&#160;</fo:block>
                        </fo:table-cell>
                        <fo:table-cell padding="1mm" font-weight="bold">
                            <fo:block>
                                <xsl:if test="position() = 1">
                                    <xsl:value-of select="$lang/e[@name='ChargeIndicatorFalse']" />
                                </xsl:if>
                            </fo:block>
                        </fo:table-cell>
                        <fo:table-cell padding="1mm" text-align="end">
                            <fo:block>
                                <xsl:value-of select="cbc:AllowanceChargeReason"/>
                            </fo:block>
                        </fo:table-cell>
                        <fo:table-cell text-align="end" padding="1mm">
                            <fo:block><xsl:value-of select="cbc:Amount"/>&#160;<xsl:value-of select="cbc:Amount/@currencyID"/></fo:block>
                        </fo:table-cell>
                    </fo:table-row>
                </xsl:for-each>
                <!-- LIST ALL CHARGES -->
                <xsl:for-each select="exsl:node-set($charges)/cac:AllowanceCharge">
                    <fo:table-row keep-with-next.within-page="always" >
                        <fo:table-cell>
                            <fo:block>&#160;</fo:block>
                        </fo:table-cell>
                        <fo:table-cell padding="1mm" font-weight="bold">
                            <fo:block>
                                <xsl:if test="position() = 1">
                                    <xsl:value-of select="$lang/e[@name='ChargeIndicatorTrue']" />
                                </xsl:if>
                            </fo:block>
                        </fo:table-cell>
                        <fo:table-cell padding="1mm" text-align="end">
                            <fo:block>
                                <xsl:value-of select="cbc:AllowanceChargeReason"/>
                            </fo:block>
                        </fo:table-cell>
                        <fo:table-cell text-align="end" padding="1mm">
                            <fo:block><xsl:value-of select="cbc:Amount"/>&#160;<xsl:value-of select="cbc:Amount/@currencyID"/></fo:block>
                        </fo:table-cell>
                    </fo:table-row>
                </xsl:for-each>
                <fo:table-row >
                    <fo:table-cell number-columns-spanned="2">
                        <fo:block>&#160;</fo:block>
                    </fo:table-cell>
                    <fo:table-cell text-align="end" border-top="solid 0.5px grey" padding="1mm" margin-right="3mm">
                        <fo:block><xsl:value-of select="$lang/e[@name='TaxExclusiveAmount']"/></fo:block>
                    </fo:table-cell>
                    <fo:table-cell text-align="end" border-top="solid 0.5px grey" padding="1mm">
                        <fo:block><xsl:apply-templates select="/*/cac:LegalMonetaryTotal/cbc:TaxExclusiveAmount"/>&#160;<xsl:value-of select="/*/cac:LegalMonetaryTotal/cbc:TaxExclusiveAmount/@currencyID"/></fo:block>
                    </fo:table-cell>
                </fo:table-row>
            </fo:table-body>
        </fo:table>
    </xsl:template>
    
    <!-- FUNCTIONAL TEMPLATES -->
    
    <!-- Amount conversion -->
    <xsl:template match="cbc:PriceAmount | cbc:LineExtensionAmount | cbc:TaxInclusiveAmount | cbc:TaxExclusiveAmount | cbc:TaxAmount | cbc:PayableAmount | cbc:TaxableAmount | cbc:BaseAmount | cbc:Amount | cbc:Quantity | cbc:InvoicedQuantity | cbc:CreditedQuantity | cbc:Percent | cbc:PenaltySurchargePercent | cancbc:AnyField">
        <xsl:variable name="vAmount">
            <xsl:choose>
                <xsl:when test="string(number(.)) != 'NaN'">
                    <xsl:value-of select="format-number(., '#&#160;##0,00', 'comma_space')" />
                </xsl:when>
            </xsl:choose>
        </xsl:variable>
        <xsl:value-of select="$vAmount" />
    </xsl:template>
    
    <!-- Date conversion -->
    <xsl:template match="cbc:IssueDate | cbc:PaymentDueDate | cbc:ActualDeliveryDate | cbc:DueDate | cbc:StartDate | cbc:EndDate" >
        <xsl:variable name="vDate" select="translate(., '-', '')" />
        <xsl:choose>
            <xsl:when test="normalize-space($vDate) != ''">
                <xsl:value-of select="concat(substring($vDate, 7, 2), '.', substring($vDate, 5, 2), '.', substring($vDate, 1, 4))"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="string('')"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <!-- Convert string to string with zero-length white-spaces for line wrapping -->    
    <xsl:template name="zero_width_space_1">
        <xsl:param name="data"/>
        <xsl:param name="counter" select="0"/>
        <xsl:choose>
            <xsl:when test="$counter &lt; string-length($data) + 1">
                <xsl:value-of select='concat(substring($data,$counter,1),"&#8203;")'/>
                <xsl:call-template name="zero_width_space_1">
                    <xsl:with-param name="data" select="$data"/>
                    <xsl:with-param name="counter" select="$counter+1"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <!-- Values inside curly braces -->
    <xsl:template match="@schemeID">
        <xsl:if test=". != ''">
            &#160;(<xsl:value-of select="."/>)&#160;
        </xsl:if>
    </xsl:template>
    
    <!-- Values inside square braces -->
    <xsl:template match="@unitCodeListID">
        <xsl:if test=". != ''">
            &#160;[<xsl:value-of select="."/>]&#160;
        </xsl:if>
    </xsl:template>    
    
</xsl:stylesheet>