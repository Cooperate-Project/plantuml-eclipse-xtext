package plantuml.eclipse.validation

import org.eclipse.xtext.validation.Check
import plantuml.eclipse.puml.Classifier
import plantuml.eclipse.puml.EnumConstant
import plantuml.eclipse.puml.PumlPackage
import java.util.HashSet
import plantuml.eclipse.puml.Method
import java.util.HashMap
import plantuml.eclipse.puml.Association
import plantuml.eclipse.puml.AssociationType
import plantuml.eclipse.puml.ClassDef
import plantuml.eclipse.puml.InterfaceDef

/**
 * This class provides custom rules that will be validated.
 */
class PumlValidator extends AbstractPumlValidator {

	public static val HIERARCHY_CYCLE = "plantuml.eclipse.puml.HierarchyCycle"
	public static val INVALID_ENUM_CONSTANT_NAME = "plantuml.eclipse.puml.InvalidEmunConstantName";
	public static val INVALID_CLASS_NAME = "plantuml.eclipse.puml.InvalidClassName"
	public static val OVERLOAD_METHOD_RETURN_TYPE = "plantuml.eclipse.OverloadMethodReturnType"
	public static val WRONG_ASSOCIATION_FOR_DIAGRAMTYPE = "plantuml.eclipse.WrongAssociationForDiagramType"

	/**
	 * Checks for cycles in super type hierarchy.
	 * Example for Error:
	 * class A extends B
	 * class B extends C
	 * class C extends A
	 */
	@Check
	def checkNoCycleClassHierarchy(Classifier someClass) {
		if(someClass.inheritance.superTypes == null || someClass.inheritance.superTypes.length == 0){
			return
		}
		val visitedClasses = <Classifier>newHashSet()
		checkSuperTypesForCycle(visitedClasses, someClass);		
	}
	
	/**
	 * Helper method for {@link #checkNoCycleClassHierarchy checkNoCycleClassHierarchy} method.
	 */
	def boolean checkSuperTypesForCycle(HashSet<Classifier> visited, Classifier someClass) {
		for(Classifier current : someClass.inheritance.superTypes){
	 		if(visited.contains(current)){
	 			warning("Cycle in hierarchy of class '" + someClass.name + "'", 
	 				PumlPackage::eINSTANCE.classifier_Inheritance, 
	 				HIERARCHY_CYCLE, 
	 				someClass.name
	 			)
	 			return true
	 		}else{
	 			val newVisited = visited
	 			newVisited.add(current)
	 			checkSuperTypesForCycle(newVisited, current)
	 		}
	 	}
	 	return false
	 }
	
	/**
	 * Checks for non-capital letters in first character of class names.
	 * Displays a warning if first character is not lower case.
	 */
	@Check
	def checkForFirstLetterCapitalClassName(Classifier someClass) {
		if(!Character.isUpperCase(someClass.name.toString.charAt(0)) && someClass.name.toString.matches("[^\"]*")){
			warning("First capitals of classes should be capital letters", 
				PumlPackage::eINSTANCE.classifier_Name, 
				INVALID_CLASS_NAME, 
				someClass.name.toString
			)
		}
	}
	 
	/**
	 * Checks for non-capital letters in enum constant names.
	 * Displays a warning if enum constant name contains anything else than upper case letters.
	 */
	@Check
	def checkForCapitalEnumName(EnumConstant someEnum) {
		for(var i = 0; i < someEnum.name.length;i++){
			if(!Character.isUpperCase(someEnum.name.charAt(i))){
				warning("Enum constants should be upper case", 
					PumlPackage::eINSTANCE.enumConstant_Name, 
					INVALID_ENUM_CONSTANT_NAME, 
					someEnum.name
				)
				return
			}
		}
	}
	
	/**
	 * Checks for associations that are not allowed in class diagrams.
	 */
	@Check
	def checkAssociations(Association association){
		if(association.associationArrow == AssociationType.DIRECTIONALRIGHTX
			|| association.associationArrow == AssociationType.DIRECTIONALRIGHTO
			|| association.associationArrow == AssociationType.DIRECTIONALLEFTX
			|| association.associationArrow == AssociationType.DIRECTIONALLEFTO
		){
			error("This association is not allowed for class diagrams.", 
				PumlPackage::eINSTANCE.association_AssociationArrow, 
				WRONG_ASSOCIATION_FOR_DIAGRAMTYPE, 
				null
			)
		}
	}
	
	/**
	 * Checks for overloads of return types of implemented interface methods.
	 */ 
	@Check
	def checkReturnTypes(Classifier someClass) {
		var interfaceMethods = new HashMap<String,String>();
		// Loop through interfaces
		for(interface : someClass.inheritance.implementedInterfaces) {
			var content = getClassContent(interface)
			for(classContent : content){
				if(classContent instanceof Method){
					// Put in HashMap
					// Example: Key("eineMethode()","String")
					val output = interfaceMethods.put(classContent.name, classContent.type)
					if(output != null && output != classContent.type){
						warning("Overload for return type of method '" + classContent.name  +"' through implemented interface '" + interface.name + "'", 
							PumlPackage::eINSTANCE.classifier_Name, 
							OVERLOAD_METHOD_RETURN_TYPE, 
							someClass.name
						)
					}
				}
			}
		}
		// Loop trough class methods
		for(classContent : getClassContent(someClass)){
			if(classContent instanceof Method){
				val output = interfaceMethods.remove(classContent.name)
				if(output != null && output != classContent.type){
						warning("Overload for return type of method '" + classContent.name +"'", 
							PumlPackage::eINSTANCE.classifier_Name, 
							OVERLOAD_METHOD_RETURN_TYPE, 
							someClass.name
						)
				}
			}
		}		
	}
	
	private def getClassContent(Classifier someClass) {
		if (someClass instanceof ClassDef) {
			return someClass.classContents
		} else if (someClass instanceof InterfaceDef) {
			return someClass.interfaceContents
		}
	}
}
