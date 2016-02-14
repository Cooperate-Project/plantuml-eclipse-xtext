package plantuml.eclipse.validation

import org.eclipse.xtext.validation.Check
import plantuml.eclipse.puml.Class
import plantuml.eclipse.puml.EnumConstant
import plantuml.eclipse.puml.PumlPackage
import java.util.HashSet

/**
 * Custom validation rules. 
 *
 */
class PumlValidator extends AbstractPumlValidator {

	public static val HIERARCHY_CYCLE = "plantuml.eclipse.puml.HierarchyCycle"
	public static val INVALID_ENUM_CONSTANT_NAME = "plantuml.eclipse.puml.InvalidEmunConstantName";
	public static val INVALID_CLASS_NAME = "plantuml.eclipse.puml.InvalidClassName"

	/**
	 * Checks for cycles in super type hierarchy.
	 * Example for Error:
	 * class A extends B
	 * class B extends C
	 * class C extends A
	 */
	@Check
	def checkNoCycleClassHierarchy(Class someClass) {
		if(someClass.superTypes == null && someClass.superTypes.length == 0){
			return
		}
		val visitedClasses = <Class>newHashSet()
		checkSuperTypesForCycle(visitedClasses, someClass);		
	}
	
	/**
	 * Helper method for checkNoCycleClassHierarchy.
	 */
	def boolean checkSuperTypesForCycle(HashSet<Class> visited, Class someClass) {
		for(Class current : someClass.superTypes){
	 		if(visited.contains(current)){
	 			warning("Cycle in hierarchy of class '" + someClass.name + "'", PumlPackage::eINSTANCE.class_SuperTypes, HIERARCHY_CYCLE, someClass.name)
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
	 */
	@Check
	def checkForFirstLetterCapitalClassName(Class someClass) {
		if(!Character.isUpperCase(someClass.name.charAt(0)) && someClass.name.matches("[^\"]*")){
			warning("First capitals of classes should be capital letters", PumlPackage::eINSTANCE.class_Name, INVALID_CLASS_NAME, someClass.name)
		}
	}
	 
	/**
	 * Checks for non-capital letters in enum constant names.
	 */
	@Check
	def checkForCapitalEnumName(EnumConstant someEnum) {
		for(var i = 0; i < someEnum.name.length;i++){
			if(!Character.isUpperCase(someEnum.name.charAt(i))){
				warning("Enum constants should be upper case", PumlPackage::eINSTANCE.enumConstant_Name, INVALID_ENUM_CONSTANT_NAME, someEnum.name)
				return
			}
		}
	}
	 
	 
	 
	 
	 
	 
	 
	 
}
