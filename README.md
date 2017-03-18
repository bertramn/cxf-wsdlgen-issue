
# CXF Compilation Episode Issue 

This example demonstrates a problem in CXF where compilation of schemata in the same namespace across multiple in episodes is failing.
 
It appears that the `org.apache.cxf.tools.wsdlto.databinding.jaxb.JAXBDataBinding` does not populate type information if an episode customisation is presented to cxf that contains some but not all types within a schema.