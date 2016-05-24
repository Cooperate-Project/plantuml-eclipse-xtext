package plantuml.eclipse.ui.highlighting

import org.eclipse.xtext.ide.editor.syntaxcoloring.IHighlightedPositionAcceptor
import org.eclipse.xtext.ide.editor.syntaxcoloring.ISemanticHighlightingCalculator
import org.eclipse.xtext.resource.XtextResource
import org.eclipse.xtext.util.CancelIndicator
import org.eclipse.xtext.nodemodel.util.NodeModelUtils
import org.eclipse.emf.ecore.EStructuralFeature
import org.eclipse.emf.ecore.EObject
import plantuml.eclipse.puml.PumlPackage
import plantuml.eclipse.puml.Enum
import plantuml.eclipse.puml.Attribute
import plantuml.eclipse.puml.Method
import plantuml.eclipse.puml.EnumConstant
import plantuml.eclipse.puml.Association 
import plantuml.eclipse.puml.NoteClass
//import plantuml.eclipse.puml.DividerClass
import plantuml.eclipse.puml.Classifier
import plantuml.eclipse.puml.DividerClass
import plantuml.eclipse.puml.UmlDiagram
import plantuml.eclipse.puml.ClassUml
import plantuml.eclipse.puml.Inheritance

/**
 * Uses the IDs from the HighlightingConfigurator and colors the regions of code.
 * 
 */
class PumlSemanticHighlightingCalculator implements ISemanticHighlightingCalculator {

	override provideHighlightingFor(XtextResource resource, IHighlightedPositionAcceptor acceptor,
		CancelIndicator cancelor) {
		if (resource == null || resource.getParseResult() == null) {
			return;
		}

		// Loop through contents
		for (var contents = resource.getAllContents(); contents.hasNext();) {
			var element = contents.next();
			highlight(element, acceptor)
		/*if (element instanceof DividerClass){
		 * 	highlightNode(element, PumlPackage.Literals.DIVIDER_CLASS__VALUE, PumlHighlightingConfiguration.DIVIDER_ID, acceptor)
		 }*/
		}
	}

	private def dispatch highlight(Classifier element, IHighlightedPositionAcceptor acceptor) {
		highlightNode(element, PumlPackage.Literals.CLASSIFIER__NAME, PumlHighlightingConfiguration.CLASS_ID, acceptor)
		highlightNode(element, PumlPackage.Literals.CLASSIFIER__COLOR, PumlHighlightingConfiguration.COLOR_ID, acceptor)
		highlightNode(element, PumlPackage.Literals.CLASSIFIER__ADVANCED_BODY, PumlHighlightingConfiguration.NOTE_ID,
			acceptor)
	}
	
	private def dispatch highlight(DividerClass element, IHighlightedPositionAcceptor acceptor) {
		highlightNode(element, PumlPackage.Literals.DIVIDER__VALUE, PumlHighlightingConfiguration.DIVIDER_ID, acceptor)
	}

	private def dispatch highlight(Enum element, IHighlightedPositionAcceptor acceptor) {
		highlightNode(element, PumlPackage.Literals.ENUM__NAME, PumlHighlightingConfiguration.CLASS_ID, acceptor)
		highlightNode(element, PumlPackage.Literals.ENUM__COLOR, PumlHighlightingConfiguration.COLOR_ID, acceptor)
	}

	private def dispatch highlight(Attribute element, IHighlightedPositionAcceptor acceptor) {
		highlightNode(element, PumlPackage.Literals.ATTRIBUTE__NAME,
			PumlHighlightingConfiguration.ATTRIBUTE_ID, acceptor)
		highlightNode(element, PumlPackage.Literals.ATTRIBUTE__TYPE, PumlHighlightingConfiguration.TYPE_ID,
			acceptor)
	}

	private def dispatch highlight(Method element, IHighlightedPositionAcceptor acceptor) {
		highlightNode(element, PumlPackage.Literals.METHOD__NAME, PumlHighlightingConfiguration.METHOD_ID,
			acceptor)
		highlightNode(element, PumlPackage.Literals.METHOD__TYPE, PumlHighlightingConfiguration.TYPE_ID,
			acceptor)
	}

	private def dispatch highlight(EnumConstant element, IHighlightedPositionAcceptor acceptor) {
		highlightNode(element, PumlPackage.Literals.ENUM_CONSTANT__NAME, PumlHighlightingConfiguration.CONSTANT_ID,
			acceptor)
	}

	private def dispatch highlight(Association element, IHighlightedPositionAcceptor acceptor) {
		highlightNode(element, PumlPackage.Literals.ASSOCIATION__CLASS_LEFT, PumlHighlightingConfiguration.CLASS_ID,
			acceptor)
		highlightNode(element, PumlPackage.Literals.ASSOCIATION__CLASS_RIGHT, PumlHighlightingConfiguration.CLASS_ID,
			acceptor)
		highlightNode(element, PumlPackage.Literals.ASSOCIATION__ASSOCIATION_ARROW,
			PumlHighlightingConfiguration.ASSOCIATION_ID, acceptor)
		highlightNode(element, PumlPackage.Literals.ASSOCIATION__LABEL, PumlHighlightingConfiguration.NOTE_ID, acceptor)
	}

	private def dispatch highlight(NoteClass element, IHighlightedPositionAcceptor acceptor) {
		highlightNode(element, PumlPackage.Literals.NOTE_CLASS__NOTE_OF, PumlHighlightingConfiguration.CLASS_ID,
			acceptor)
		highlightNode(element, PumlPackage.Literals.NOTE_CLASS__NOTE, PumlHighlightingConfiguration.NOTE_ID, acceptor)
	}
	
	
	private def dispatch highlight(UmlDiagram umlDiagram, IHighlightedPositionAcceptor acceptor) {
		
	}
	
	private def dispatch highlight(ClassUml umlDiagram, IHighlightedPositionAcceptor acceptor) {
		
	}
	
	private def dispatch highlight(Inheritance element, IHighlightedPositionAcceptor acceptor) {
		
	}

	private def highlightNode(EObject element, EStructuralFeature feature, String id, IHighlightedPositionAcceptor acceptor) {
		// Search for features and highlight them
		for (node : NodeModelUtils.findNodesForFeature(element, feature)) {
			acceptor.addPosition(node.getOffset(), node.getLength(), id)
		}
	}

}
