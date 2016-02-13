package plantuml.eclipse.ui.highlighting

import org.eclipse.xtext.ide.editor.syntaxcoloring.IHighlightedPositionAcceptor
import org.eclipse.xtext.ide.editor.syntaxcoloring.ISemanticHighlightingCalculator
import org.eclipse.xtext.nodemodel.INode
import org.eclipse.xtext.resource.XtextResource
import org.eclipse.xtext.util.CancelIndicator
import plantuml.eclipse.puml.Class

/**
 * Uses the IDs from the HighlightingConfigurator and colors the regions of code.
 * 
 */
class PumlSemanticHighlightingCalculator implements ISemanticHighlightingCalculator {
	
	INode root;

	override provideHighlightingFor(XtextResource resource, IHighlightedPositionAcceptor acceptor, CancelIndicator cancelor) {
		if(resource != null || resource.getParseResult() == null){
			return;
		}
		// Loop through all the elements
		root = resource.getParseResult().getRootNode();
		for(INode node : root.getAsTreeIterable()){
			if(node.getGrammarElement() instanceof Class){
		    	acceptor.addPosition(node.getOffset(), node.getLength(), PumlHighlightingConfiguration.CLASS_ID);
			}
		}
	}
	
	
}
