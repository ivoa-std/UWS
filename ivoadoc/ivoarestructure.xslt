<?xml version="1.0" encoding="UTF-8"?>
<x:stylesheet xmlns:x="http://www.w3.org/1999/XSL/Transform"
              version="2.0"
              xmlns:h="http://www.w3.org/1999/xhtml"
              xmlns="http://www.w3.org/1999/xhtml"
              xmlns:dc="http://purl.org/dc/elements/1.1/"
              xmlns:dcterms="http://purl.org/dc/terms/">

  <x:output method="xml"
            encoding="ISO-8859-1" doctype-public="-//W3C//DTD XHTML 1.0 Transitional//EN" doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"
            />

  <!--
  This script is designed to help with the production of IVOA standards - it is derived from a script by Norman Gray, but is different in behaviour in that the document produced by the script is 
  intended to be used as input in the next round of editing.
  
  Paul Harrison
  
      The following supports a mildly-enhanced version of XHTML.  Most
      notably, it supports sectioning via nested <div class='section'>
      elements, with the section title being given by the first 
      <h1><a name="secid"/><span class="secnum">1.1</span> Title</h1> child of the <div>.  The <div> class can also
      be 'section-nonum', with the obvious meaning, and the div can
      have an 'id' attribute which allows cross-references to it.
      Cross-references are supported by a <span class='xref'>id</span> element.

      Appendices go in a <div class='appendices'>, and an abstract in
      <div class='abstract'>

      The <div>s can be collected into a ToC, at a location marked by
      a <?toc?> PI.

      Bibliography: entries can be marked with <span
      class='cite'>ref</span>, and these can be collected into a .aux
      file by running this stylesheet with the parameter 'target'
      given as 'aux'.  The location of the bibliography is marked by a
      <?bibliography?> PI: this simply reads in a file
      $document-id.bbl, the generation of which must be managed
      externally to this script.
      
      
      xml documents can be literally included (and formatted) with the <?xmlinc href=""?> processing instruction. All text between
      until the <?xmlinc end?> will be replaced.

      There's also a <span class='url'>url</span>, which formats the
      URL appropriately, and a
      <span class='rcsinfo'>$foo: bar $</span>, which extracts the
      contents 'bar' from the string.

      The output has extra properties added to support RDFa, using
      information extracted from 'title' and 'abstract', and from
      <meta name='DC.xxx'> and <meta name='rcsdate'> fields in the <head>
  -->

  <!-- We include support for RDFa in the following, via: the output doctype,
       the 'profile' attribute in the head element, and the various 'property'
       attributes in the text.
       See <http://www.w3.org/TR/2008/WD-rdfa-syntax-20080221/#docconf>.
       We also add a GRDDL transformation which independently specifies
       the RDFa transformation. -->

  <x:param name="target"/>

  <x:param name="document-id">document-id</x:param>
  
  <x:param name="reloadbib"/>


  <!-- process root node -->
  <x:template match="/">
    <x:choose>
      <x:when test="$target">
        <x:message terminate="yes">Unrecognised target <x:value-of select="$target"/>
        </x:message>
      </x:when>
      <x:otherwise>
        <x:apply-templates select="child::node()"/>
      </x:otherwise>
    </x:choose>
  </x:template>


  <x:template match="h:head">
    <head profile='http://www.w3.org/1999/xhtml/vocab'>
      <x:apply-templates select="@*"/>
      <x:copy-of select="namespace::*[.='http://purl.org/dc/elements/1.1/']"/>
      <x:apply-templates select="child::node()"/>
    </head>
  </x:template>


  <x:template match="h:div[@class='section' or @class='section-nonum']">

   <x:copy>
    <x:apply-templates select="@*"/>
    <x:variable name='id'>
      <x:call-template name='make-section-id'/>
    </x:variable>
    <x:variable name="level">
      <x:choose>
        <x:when test="ancestor::h:div[@class='section']/ancestor::h:div[@class='section']">h4</x:when>
        <x:when test="ancestor::h:div[@class='section']">h3</x:when>
        <x:otherwise>h2</x:otherwise>
      </x:choose>
    </x:variable>
      <x:message>section <x:value-of select="$level"/></x:message>
    <x:element name='{$level}'>
      <x:element name="a"><x:attribute name='name' select="$id"/>
      <x:copy-of select="./(h:h2|h:h3|h:h4)/h:a/@*" />
      
      </x:element>
      <x:apply-templates select="." mode="make-section-name"/>
    </x:element>
    <x:apply-templates select="*[1]/following-sibling::node()"/><!-- perhaps a little dangerous perhaps better to have a template to ignore the first h1 etc after a section... -->
   </x:copy> 
  </x:template>
 
 <!-- this is not perfect either - depends how many levels down...
  <x:template match="h:div[@class='section' or @class='section-nonum']/h1[1]|h2[1]|h3[1]">
  </x:template>
   --> 
  
  <!--
  <x:template match="h:div[@class='section' or @class='section-nonum']">
    <x:variable name="id">
      <x:call-template name="make-section-id"/>
    </x:variable>
    <x:variable name="level">
      <x:choose>
        <x:when test="ancestor::h:div[@class='section']/ancestor::h:div[@class='section']">h4</x:when>
        <x:when test="ancestor::h:div[@class='section']">h3</x:when>
        <x:otherwise>h2</x:otherwise>
      </x:choose>
    </x:variable>
    <x:element name="{$level}" namespace='http://www.w3.org/1999/xhtml'>
      <x:if test="@id">
        <x:attribute name='class'>hlink</x:attribute>
      </x:if>
      <x:apply-templates select="." mode="make-section-name"/>
      <x:element name='a' namespace='http://www.w3.org/1999/xhtml'>
        <x:attribute name='name'><x:value-of select='$id'/></x:attribute>
        <x:if test="@id">
          <x:attribute name='href'>#<x:value-of select='$id'/></x:attribute>
          <x:text> [link here]</x:text>
        </x:if>
      </x:element>
    </x:element>
    <x:apply-templates/>
  </x:template>
  -->


  <x:template match="h:div[@class='appendices']">
    <x:copy>
    <x:apply-templates select="@*"/>
   
    <x:apply-templates select="child::node()"/>
    </x:copy>
  </x:template>

  <x:template match="h:div" mode="make-toc">
    <x:variable name="id">
      <x:call-template name="make-section-id"/>
    </x:variable>
    <li>
      <a href='#{$id}'>
        <x:apply-templates select='.' mode='make-section-name'/>
      </a>
      <x:if test="h:div[@class='section' or @class='section-nonum']">
        <ul>
          <x:apply-templates select="h:div[@class='section' or @class='section-nonum']" mode="make-toc"/>
        </ul>
      </x:if>
    </li>
  </x:template>
  
  <x:template match="h:div[processing-instruction()[1][count(preceding-sibling::element()) = 0]]">
  <!-- the processing instructions will replace everything with the enclosing div if they are first - used for the toc, bibliography and xmlinc processing instucctions-->
    <x:copy>
    <x:choose>
      <x:when test="child::processing-instruction('bibliography') and not($reloadbib)">
         <x:apply-templates/>
      </x:when>
      <x:otherwise>
         <x:apply-templates select="child::processing-instruction()"/>
      </x:otherwise>
    </x:choose>
    
    </x:copy>
  </x:template>

  <x:template match="processing-instruction('toc')">
  <copy>
    <div id='toc' class='toc'>
      <ul>
        <x:apply-templates select="//h:div[@class='body']/h:div[@class='section' or @class='section-nonum']|//h:div[@class='body']/h:div[@class='appendices']/h:div" mode="make-toc"/>
      </ul>
    </div>
   </copy>
  </x:template>

  <x:template name="make-section-id">
  
    <x:choose>
      <x:when test="child::*[1]/h:a/@id">
        <x:value-of select="child::*[1]/h:a/@id"/>
      </x:when>
      <x:otherwise>
        <x:value-of select="generate-id()"/>
      </x:otherwise>
    </x:choose>
  </x:template>

  <x:template match="h:div" mode="make-section-name">
    <x:element name="span"><x:attribute name="class" select="'secnum'"></x:attribute>
    <x:apply-templates select="." mode="make-section-number"/>
     </x:element>
    <x:apply-templates select="child::*[1]/text()"/>
  </x:template>
  
  <x:template match="h:div" mode="make-section-number"><!-- would named template be better? -->
      <x:choose>
      <x:when test="ancestor-or-self::h:div[@class='section-nonum']"/>
      <x:when test="ancestor::h:div[@class='appendices']">
        <x:text>Appendix </x:text>
        <x:number count="h:div[@class='section']" level="multiple" format="A.1."/>
        <x:text> </x:text>
      </x:when>
      <x:otherwise>
        <x:number count="h:div[@class='section']" level="multiple" format="1.1."/>
        <x:text> </x:text>
      </x:otherwise>
    </x:choose>
    
    
  </x:template>

  <x:template match="processing-instruction('bibliography')">
    <x:copy/>
    <x:choose><x:when test="contains(.,'replace')">
   
    <!-- think of better way to get the document id in -->
    <x:if test="$document-id ne 'document-id'">
       <x:copy-of select="document(concat(substring-before($document-id, '.xml'),'.bbl'))"/>
    </x:if>
    </x:when></x:choose>
  </x:template>

  <x:template match="h:cite">
  <!-- need to do this as numbered along with bibstyle... -->
    <x:copy>
    <x:variable name="ref">
    <x:choose>
       <x:when test="h:a/@href">
        <x:value-of select="substring-after(h:a/@href,'#ref:')"/>
       </x:when>
       <x:otherwise>
         <x:value-of select="."/>
       </x:otherwise>
    </x:choose>
    </x:variable>
    [<a href='#ref:{$ref}'><x:value-of select='$ref'/></a>]
    </x:copy>
  </x:template>

  <x:template match="h:span[@class='url']">
    <a href='{text()}'>
      <span class='url'><x:value-of select='.'/></span>
    </a>
  </x:template>

 
  <x:key name="xrefs" match="h:div[(h:h1|h:h2|h:h3|h:h4|h:h5|h:h6)/h:a]" use="*/h:a/@id"/><!-- can only reference sections at the moment -->

  <x:template match="h:span[@class='xref']">
  <h:span class="xref">
    
    <x:variable name="id">
      <x:choose>
        <x:when test="h:a/@href">
          <x:value-of select="substring-after(h:a/@href, '#')"/>
        </x:when>
        <x:otherwise>
          <x:value-of select="."/> <!-- can just put in the xref span -->
        </x:otherwise>
      </x:choose>
    </x:variable>
    <x:choose>
      <x:when test="key('xrefs',$id)">
      <x:message>putting in xref <x:value-of select="$id"/></x:message>
      </x:when>
      <x:otherwise>
      <x:message >error putting in xref <x:value-of select="$id"/> - destination does not exist </x:message>
      </x:otherwise>
    </x:choose>
    <a href='#{$id}'>
      <x:apply-templates select="key('xrefs',$id)" mode="make-section-number"/>
    </a>
  </h:span>
  </x:template>

  <x:template match="h:span[@class='rcsinfo']">
    <x:value-of select="substring-before(substring-after(.,': '),' $')"/>
  </x:template>


<!-- maybe later
  <x:template xmlns:owl="http://www.w3.org/2002/07/owl#" match="h:meta">
    <x:choose>
      <x:when test="@name='DC.rights'">
        <link about='' rel='{@name}' href='{@content}'/>
      </x:when>
      <x:when test="@name='rcsdate'">
        <meta about='' property='dcterms:modified'>
          <x:attribute name='content'>
            <x:value-of select="translate(substring(@content,8,10),'/','-')"/>
            <x:text>T</x:text>
            <x:value-of select="substring(@content,19,8)"/>
          </x:attribute>
        </meta>
      </x:when>
      <x:when test="@name='purl'">
        <link about='' rel='dc:identifier' href='{@content}'/>
        <link about='' rel='owl:sameAs'    href='{@content}'/>
      </x:when>
      <x:when test="starts-with(@name,'DC.')">
        <meta about='' content='{@content}'>
          <x:attribute name="property">dc:<x:value-of select="substring-after(@name, 'DC.')"/>
          </x:attribute>
        </meta>
      </x:when>
      <x:when test='@property and @content'>
       
        <x:copy-of select='.'/>
      </x:when>
    </x:choose>
  </x:template>
   -->

  <x:template match="h:div[@class='signature']">
    <x:copy>
      <x:apply-templates select="@*"/>
      <x:choose>
        <x:when test="h:a/@href">
          <x:attribute name="rel">dc:creator</x:attribute>
          <x:attribute name="href">
            <x:value-of select="h:a/@href"/>
          </x:attribute>
        </x:when>
        <x:otherwise>
          <x:attribute name="property">dc:creator</x:attribute>
          <x:attribute name="content">
            <x:value-of select="h:a/text()"/>
          </x:attribute>
        </x:otherwise>
      </x:choose>
      <x:apply-templates/>
    </x:copy>
  </x:template>

  <x:template match="h:div[@class='abstract']">
    <x:copy>
      <x:apply-templates select="@*"/>
      <x:element name='meta' namespace='http://www.w3.org/1999/xhtml'>
        <x:attribute name='property'>dcterms:abstract</x:attribute>
        <x:attribute name='about'/>
        <x:attribute name="content">
          <x:apply-templates select="h:p[not(@class)]" mode="text-only"/>
        </x:attribute>
      </x:element>
      <x:apply-templates select="child::node()"/>
    </x:copy>
  </x:template>

<!--  <x:template match="h:q">
    <x:text>“</x:text>
    <x:apply-templates/>
    <x:text>”</x:text>
  </x:template> --> 

  <x:template match="h:p" mode="text-only">
    <x:value-of select="normalize-space(.)"/>
    <x:text>  </x:text>
  </x:template>

  <x:template match="processing-instruction('incxml')">
      <x:copy/>
      <x:choose>
        <x:when test="starts-with(., 'href')">
        <x:analyze-string regex="href=['&quot;]([^'&quot;]+)['&quot;]" select=".">
          <x:matching-substring>
          <x:message>Including xml from <x:value-of select="regex-group(1)"/></x:message>
            <x:apply-templates select="document(regex-group(1))" mode="printxml"></x:apply-templates>
          </x:matching-substring>
        </x:analyze-string>
        </x:when>
        
      </x:choose>
  </x:template>


   <!-- default identity transformation -->
  <x:template match="node()|@*">
    <x:copy>
      <x:apply-templates select="node()|@*"/>
    </x:copy>
  </x:template>
 
 <!-- printxml stuff -->

  <x:template match="/" mode="printxml" >
  <div class="viewxml">
  <x:apply-templates select="child::node()" mode="printxml"/>
  </div>
   </x:template>
  
<x:template match="/*" mode="printxml" priority="1"><!-- try to add the namespaces for the root element -->
  <x:message>in root element <x:value-of select="name(.)"/></x:message>
          <div class="element">
          <span class="markup">&lt;</span><span class="start-tag"><x:value-of select="name(.)"/></span><x:apply-templates select="@*" mode="printxml"/>
          <x:variable  name="v" select="."/> 
          <x:for-each select="in-scope-prefixes(.)">
             <x:text> </x:text><span class="attribute-name"><x:text>xlmns:</x:text><x:value-of select="."/></span><span class="markup">=</span><span class="attribute-value">"<x:value-of select="namespace-uri-for-prefix(., $v)"/>"</span>
          </x:for-each>
          <span class="markup">&gt;</span>
          <x:apply-templates select="child::node()"  mode="printxml"/>
          <span class="markup">&lt;/</span><span class="end-tag"><x:value-of select="name(.)"/></span><span class="markup">&gt;</span>
          </div>
  </x:template>
  
  
  <x:template match="processing-instruction()" mode="printxml">
    <div class="indent pi">
      <x:text>&lt;?</x:text>
      <x:value-of select="name(.)"/>
      <x:text> </x:text>
      <x:value-of select="."/>
      <x:text>?&gt;</x:text>
    </div>
  </x:template>
  
  <x:template match="comment()"  mode="printxml">
  <x:message>comment</x:message>
    <div class="comment"><x:text>&lt;!--</x:text><x:value-of select="."/><x:text>--&gt;</x:text></div>
  </x:template>


  <x:template match="*" mode="printxml" >
  <x:message>all <x:value-of select="name(.)"/></x:message>
    <div class="indent">
      <span class="markup">&lt;</span>
      <span class="start-tag"><x:value-of select="name(.)"/></span>
      <x:apply-templates select="@*"  mode="printxml"/>
      <span class="markup">/&gt;</span>
    </div>
  </x:template>

<!-- this template causes ambiguity with the next one - seems harmless in saxon, but need to understand how to remove - possibly because of newlines... -->
  <x:template match="*[text()]" mode="printxml">
    <div class="indent">
      <span class="markup">&lt;</span>
      <span class="start-tag"><x:value-of select="name(.)"/></span>
      <x:apply-templates select="@*"  mode="printxml"/>
      <span class="markup">&gt;</span>
      <span class="text"><x:value-of select="."/></span>
      <span class="markup">&lt;/</span>
      <span class="end-tag"><x:value-of select="name(.)"/></span>
      <span class="markup">&gt;</span>
    </div>
  </x:template>


 <x:template match="*[element()]" mode="printxml" >
          <div class="element">
          <span class="markup">&lt;</span><span class="start-tag"><x:value-of select="name(.)"/></span><x:apply-templates select="@*" mode="printxml"/><span class="markup">&gt;</span>
          <x:apply-templates select="child::node()"  mode="printxml"/>
          <span class="markup">&lt;/</span><span class="end-tag"><x:value-of select="name(.)"/></span><span class="markup">&gt;</span>
          </div>
  </x:template>

 

  <x:template match="@*"  mode="printxml">
    <x:text> </x:text><span class="attribute-name"><x:value-of select="name(.)"/></span><span class="markup">=</span><span class="attribute-value">"<x:value-of select="."/>"</span>
  </x:template>
  
 
  <x:template match="text()"  mode="printxml">
    <x:if test="normalize-space(.)">
      <div class="indent text"><x:value-of select="."/></div>
    </x:if>
  </x:template>


 
</x:stylesheet>
