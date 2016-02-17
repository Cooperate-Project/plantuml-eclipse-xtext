package plantuml.eclipse.ui.highlighting

import org.eclipse.xtext.ide.editor.syntaxcoloring.IHighlightedPositionAcceptor
import org.eclipse.xtext.ide.editor.syntaxcoloring.ISemanticHighlightingCalculator
import org.eclipse.xtext.resource.XtextResource
import org.eclipse.xtext.util.CancelIndicator
import org.eclipse.xtext.nodemodel.util.NodeModelUtils
import java.util.Iterator
import org.eclipse.emf.ecore.EObject
import plantuml.eclipse.puml.PumlPackage
import plantuml.eclipse.puml.Class
import plantuml.eclipse.puml.Enum
import plantuml.eclipse.puml.Attribute
import plantuml.eclipse.puml.Method
import plantuml.eclipse.puml.EnumConstant
import org.eclipse.emf.ecore.EStructuralFeature
import plantuml.eclipse.puml.Association

/**
 * Uses the IDs from the HighlightingConfigurator and colors the regions of code.
 * 
 */
class PumlSemanticHighlightingCalculator implements ISemanticHighlightingCalculator {
	
	Iterator<EObject> contents;
	EObject element;
	
	override provideHighlightingFor(XtextResource resource, IHighlightedPositionAcceptor acceptor, CancelIndicator cancelor) {
		if(resource == null || resource.getParseResult() == null){
			return;
		}
		
		// Loop through contents
		for(contents = resource.getAllContents(); contents.hasNext(); ) 
        {
            element = contents.next();
            if (element instanceof Class){
            	highlightNode(element, PumlPackage.Literals.CLASS__NAME, PumlHighlightingConfiguration.CLASS_ID, acceptor)
            	highlightNode(element, PumlPackage.Literals.CLASS__COLOR, PumlHighlightingConfiguration.COLOR_ID, acceptor)
            }
            if (element instanceof Enum){
            	highlightNode(element, PumlPackage.Literals.ENUM__NAME, PumlHighlightingConfiguration.CLASS_ID, acceptor)
            	highlightNode(element, PumlPackage.Literals.ENUM__COLOR, PumlHighlightingConfiguration.COLOR_ID, acceptor)
            }
            if (element instanceof Attribute){
            	highlightNode(element, PumlPackage.Literals.CLASS_CONTENT__NAME, PumlHighlightingConfiguration.ATTRIBUTE_ID, acceptor)
            	highlightNode(element, PumlPackage.Literals.CLASS_CONTENT__TYPE, PumlHighlightingConfiguration.TYPE_ID, acceptor)
            }
            if(element instanceof Method){
            	highlightNode(element, PumlPackage.Literals.CLASS_CONTENT__NAME, PumlHighlightingConfiguration.METHOD_ID, acceptor)
            	highlightNode(element, PumlPackage.Literals.CLASS_CONTENT__TYPE, PumlHighlightingConfiguration.TYPE_ID, acceptor)
            }
            if(element instanceof EnumConstant){
            	highlightNode(element, PumlPackage.Literals.ENUM_CONSTANT__NAME, PumlHighlightingConfiguration.CONSTANT_ID, acceptor)
            }
            if(element instanceof Association){
            	highlightNode(element, PumlPackage.Literals.ASSOCIATION__CLASS_LEFT, PumlHighlightingConfiguration.CLASS_ID, acceptor)
            	highlightNode(element, PumlPackage.Literals.ASSOCIATION__CLASS_RIGHT, PumlHighlightingConfiguration.CLASS_ID, acceptor)
            }
        }
    }
    
    def highlightNode(EObject element, EStructuralFeature feature, String id, IHighlightedPositionAcceptor acceptor){
    	// Search for features and highlight them
    	for (node : NodeModelUtils.findNodesForFeature(element, feature)){
			acceptor.addPosition(node.getOffset(), node.getLength(), id)
		}
    }	
	
}
