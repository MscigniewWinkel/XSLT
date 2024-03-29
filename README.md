# XSLT
Example of simple standard transformation from XML to PDF, using XSLT and Apache FOP

To be able to run the stylesheet, you will need to download Apache FOP. This stylesheet was tested on versions 2.2 and above. 
All given files are mandatory to run the transformation. To run the transformation, use this command in your shell:
..\fop-2.9\fop\fop.bat -c config.xml -xml Example_UBL.xml -xsl stylesheet.xsl -param language 'PL.xml' images\output.pdf ;Start-Process ((Resolve-Path "C:\Path_to_your_folder\images\output.pdf").Path)
