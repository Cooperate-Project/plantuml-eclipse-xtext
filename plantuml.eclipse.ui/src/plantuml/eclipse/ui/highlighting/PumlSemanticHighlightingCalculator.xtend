package plantuml.eclipse.ui.highlighting

import org.eclipse.xtext.ide.editor.syntaxcoloring.ISemanticHighlightingCalculator
import org.eclipse.xtext.resource.XtextResource
import org.eclipse.xtext.ide.editor.syntaxcoloring.IHighlightedPositionAcceptor
import org.eclipse.xtext.util.CancelIndicator
import org.eclipse.xtext.nodemodel.INode
import org.eclipse.xtext.nodemodel.BidiTreeIterator
import org.eclipse.xtext.nodemodel.impl.CompositeNodeWithSemanticElement
import java.util.Iterator
import org.eclipse.emf.ecore.EObject
import org.eclipse.xtext.parser.IParseResult
import org.eclipse.xtext.nodemodel.ICompositeNode

class PumlSemanticHighlightingCalculator implements ISemanticHighlightingCalculator {
	
	/*INode root;
	INode node;
	BidiTreeIterator<INode> treeIterator;
	
	Iterator<EObject> objectIterator;
	EObject object;*/
	
	IParseResult parseResult;
	ICompositeNode rootNode;
	EObject semanticElement;
	
	override provideHighlightingFor(XtextResource resource, IHighlightedPositionAcceptor acceptor, CancelIndicator arg2) {
		if(resource != null || resource.getParseResult() == null){
			return;
		}
		parseResult = resource.getParseResult();
		rootNode = parseResult.getRootNode();
		for(abstractNode : rootNode.getAsTreeIterable()){
			semanticElement = abstractNode.getSemanticElement();
			/*if(semanticElement instanceof DataType){
				acceptor.addPosition(abstractNode.getOffset(), abstractNode.getLength(), PumlHighlightingConfiguration.DATATYPE);
			}	*/
		}
		
		
		
		/*for(objectIterator = resource.getAllContents(); objectIterator.hasNext();){
			object = objectIterator.next();
			if(object instanceof DataType){
				
			}
		}
		
		root = resource.getParseResult().getRootNode();
		treeIterator = root.getAsTreeIterable().iterator();
		while(treeIterator.hasNext()){
			node = treeIterator.next();
			if( node instanceof CompositeNodeWithSemanticElement && node.getSemanticElement() instanceof DataType){
				
			}
		
		}*/
	}

	
}
