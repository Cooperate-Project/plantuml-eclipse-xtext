package plantuml.eclipse.ui.highlighting

import org.eclipse.xtext.ide.editor.syntaxcoloring.IHighlightedPositionAcceptor
import org.eclipse.xtext.ide.editor.syntaxcoloring.ISemanticHighlightingCalculator
import org.eclipse.xtext.nodemodel.INode
import org.eclipse.xtext.resource.XtextResource
import org.eclipse.xtext.util.CancelIndicator
import org.eclipse.emf.ecore.EObject
import java.util.Iterator
import org.eclipse.emf.ecore.util.EcoreUtil
import plantuml.eclipse.puml.Class
import org.eclipse.xtext.nodemodel.impl.AbstractNode
import plantuml.eclipse.puml.PumlPackage

/**
 * Uses the IDs from the HighlightingConfigurator and colors the regions of code.
 * 
 */
class PumlSemanticHighlightingCalculator implements ISemanticHighlightingCalculator {
	
	Iterator<EObject> iterator;
	EObject currentElement;
	AbstractNode node;

	override provideHighlightingFor(XtextResource resource, IHighlightedPositionAcceptor acceptor, CancelIndicator cancelor) {
		if(resource != null || resource.getParseResult() == null){
			return;
		}
		// Loop through all the elements
		iterator = EcoreUtil.getAllContents(resource, true);
		while(iterator.hasNext()){
			currentElement = iterator.next();
			if(currentElement instanceof Class){
				acceptor.addPosition(node.getOffset(),node.getLength(), PumlHighlightingConfiguration.CLASS_ID);
			}
		}
	}
	
	
}
