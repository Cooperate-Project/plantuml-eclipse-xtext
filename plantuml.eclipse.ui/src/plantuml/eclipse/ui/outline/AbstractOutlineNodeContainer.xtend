package plantuml.eclipse.ui.outline

import org.eclipse.xtext.ui.editor.outline.impl.AbstractOutlineNode

class AbstractOutlineNodeContainer {
	
	private AbstractOutlineNode classesNode;
	private AbstractOutlineNode interfacesNode;
	private AbstractOutlineNode associationsNode;
	private AbstractOutlineNode enumsNode;
	
	new(AbstractOutlineNode classesNode, AbstractOutlineNode interfacesNode, AbstractOutlineNode associationsNode, AbstractOutlineNode enumssNode) {
		this.classesNode = classesNode;
		this.interfacesNode = interfacesNode;
		this.associationsNode = associationsNode;
		this.enumsNode = enumssNode;
	}
	
	def AbstractOutlineNode getClassesNode() {
		return classesNode;
	}
	
	def AbstractOutlineNode getInterfacesNode() {
		return interfacesNode;
	}
	
	def AbstractOutlineNode getAssociationsNode() {
		return associationsNode;
	}
	
	def AbstractOutlineNode getEnumsNode() {
		return enumsNode;
	}
	
}