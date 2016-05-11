/*
 * generated by Xtext
 */
package plantuml.eclipse.ui.outline

import org.eclipse.xtext.ui.editor.outline.impl.DefaultOutlineTreeProvider
import org.eclipse.xtext.ui.editor.outline.impl.DocumentRootNode
import org.eclipse.emf.ecore.EObject
import plantuml.eclipse.puml.Classifier
import plantuml.eclipse.puml.Enum
import plantuml.eclipse.puml.UmlDiagram
import org.eclipse.xtext.ui.editor.outline.impl.AbstractOutlineNode
import plantuml.eclipse.puml.ClassUml
import com.google.inject.Inject
import org.eclipse.xtext.ui.IImageHelper
import plantuml.eclipse.puml.Association
import plantuml.eclipse.puml.PumlFactory
import plantuml.eclipse.puml.AssociationType
import plantuml.eclipse.puml.InterfaceDef

/**
 * Customization of the default outline structure.
 */
class PumlOutlineTreeProvider extends DefaultOutlineTreeProvider {

	@Inject
	private IImageHelper imageHelper;	

	/**
	 * Loops through elements and creates our outline tree.
	 */
	def _createChildren(DocumentRootNode parentNode, UmlDiagram root) {
		for (umlDiagram : root.umlDiagrams) {
			createChildrenFromDiagram(umlDiagram, parentNode)
		}
	}
	
	def private getClassesParent(DocumentRootNode parentNode) {
		 new AbstractOutlineNode(parentNode, imageHelper.getImage("class_obj.png"), "Classes", false) {}
	}
	
	def private getInterfacesParent(DocumentRootNode parentNode) {
		 new AbstractOutlineNode(parentNode, imageHelper.getImage("int_obj.png"), "Interfaces", false) {}
	}
	
	def private getAssociationsParent(DocumentRootNode parentNode) {
		 new AbstractOutlineNode(parentNode, imageHelper.getImage("reference.png"), "Assocations", false) {}
	}
	
	def private getEnumsParent(DocumentRootNode parentNode) {
		 new AbstractOutlineNode(parentNode, imageHelper.getImage("enum_obj.png"), "Enums", false) {}
	}

	/**
	 * creates outline elements for the UML Class Diagram.
	 */
	def private dispatch createChildrenFromDiagram(ClassUml classUml, DocumentRootNode parentNode) {
		// Create Root Nodes for Elements
		// Loop through Class Elements
		for (EObject umlClassElement : classUml.umlElements) {
			createChildrenFromDiagramElements(umlClassElement, parentNode)
		}
	}

	/**
	 * Dummy dispatch method.
	 */
	def private dispatch createChildrenFromDiagram(EObject classUml, DocumentRootNode parentNode) {
	}

	/**
	 * Dummy dispatch method.
	 */
	def private dispatch createChildrenFromDiagramElements(EObject classUml, DocumentRootNode parentNode) {
	}

	/**
	 * creates Association outline elements.
	 */
	def private dispatch createChildrenFromDiagramElements(Association association, DocumentRootNode parentNode) {
		createNode(getAssociationsParent(parentNode), association)
	}

	/**
	 * creates Enum outline elements.
	 */
	def private dispatch createChildrenFromDiagramElements(Enum _enum, DocumentRootNode parentNode) {		
		createNode(getEnumsParent(parentNode), _enum)
	}

	/**
	 * creates Classifier outline elements.
	 */
	def private dispatch createChildrenFromDiagramElements(Classifier classifier, DocumentRootNode parentNode) {		
		// Do we have extended Supertypes?
		if (classifier.inheritance.superTypes.length() != 0) {
			for (extendedClass : classifier.inheritance.superTypes) {
				createNode(getAssociationsParent(parentNode),
					createAssociation(classifier, extendedClass, AssociationType.INHERITANCERIGHT))
			}
		}
		// Do we have implemented Interfaces?
		if (classifier.inheritance.implementedInterfaces.length() != 0) {
			for (implementedClass : classifier.inheritance.implementedInterfaces) {
				createNode(getAssociationsParent(parentNode),
					createAssociation(classifier, implementedClass, AssociationType.INHERITANCERIGHT))
			}
		}
		if (classifier instanceof InterfaceDef) {
			createNode(getInterfacesParent(parentNode), classifier)
		} else {
			createNode(getClassesParent(parentNode), classifier)
		}
	}

	/**
	 * Creates a new Association EObject and returns it.
	 */
	def Association createAssociation(Classifier classLeft, Classifier classRight, AssociationType type) {
		var newAssociation = PumlFactory.eINSTANCE.createAssociation()
		newAssociation.classLeft = classLeft
		newAssociation.classRight = classRight
		newAssociation.associationArrow = type
		return newAssociation
	}
}
