package org.apache.cxf.tools.wsdlto.databinding.jaxb;

import org.xml.sax.ErrorHandler;
import org.xml.sax.SAXException;

import java.util.Map;
import java.util.logging.Logger;

import com.sun.codemodel.JCodeModel;

import com.sun.tools.xjc.Options;
import com.sun.tools.xjc.Plugin;
import com.sun.tools.xjc.model.Model;
import com.sun.tools.xjc.outline.Outline;
import com.sun.tools.xjc.reader.xmlschema.bindinfo.BIClass;
import com.sun.tools.xjc.reader.xmlschema.bindinfo.BIDeclaration;
import com.sun.tools.xjc.reader.xmlschema.bindinfo.BindInfo;

import com.sun.xml.xsom.XSAnnotation;
import com.sun.xml.xsom.XSElementDecl;
import com.sun.xml.xsom.XSSchema;

public class TypeHarvesterPlugin extends Plugin {

  private final Logger log = Logger.getLogger(getClass().getName());

  @Override
  public String getOptionName() {
    return "Xharvester";
  }

  @Override
  public String getUsage() {
    return "  -Xharvester    :  CXF code model harvester plugin";
  }

  @Override
  public boolean run(Outline outline, Options opt, ErrorHandler errorHandler) throws SAXException {
    JCodeModel codeModel = outline.getCodeModel();
    // private codeModel.refClasses contains "some" episode classes known to the XJC compiler but no mapping to a QName
    return true;
  }

  @Override
  public void postProcessModel(Model model, ErrorHandler errorHandler) {

    for (XSSchema schema : model.schemaComponent.getSchemas()) {
      Map<String, XSElementDecl> elementDecls = schema.getElementDecls();
      for (String element : elementDecls.keySet()) {
        XSElementDecl elementDecl = elementDecls.get(element);
        if (elementDecl.getType().isComplexType()) {
          XSAnnotation xsAnnotation = elementDecl.getType().getAnnotation();
          if (xsAnnotation != null) {
            Object bindInfoCandidate = xsAnnotation.getAnnotation();
            if (bindInfoCandidate != null && bindInfoCandidate instanceof BindInfo) {
              BindInfo bindInfo = (BindInfo) bindInfoCandidate;
              for (BIDeclaration decl : bindInfo.getDecls()) {
                if (decl instanceof BIClass) {
                  BIClass refClazz = (BIClass) decl;
                  String classRefName = refClazz.getExistingClassRef();
                  int lastDot = classRefName.lastIndexOf('.');
                  String classRefPackage = null;
                  if(lastDot > 0) {
                    classRefPackage = classRefName.substring(0, lastDot);
                    classRefName = classRefName.substring(lastDot + 1);
                  }
                  model.options.classNameAllocator.assignClassName(classRefPackage, classRefName);
                  log.warning(String.format("{%s}%s => %s", schema.getTargetNamespace(), element, refClazz.getExistingClassRef()));
                }
              }
            }
          }
        }
      }

    }

  }
}
