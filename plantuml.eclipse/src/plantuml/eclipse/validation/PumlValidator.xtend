package plantuml.eclipse.validation

import org.eclipse.xtext.validation.Check
import plantuml.eclipse.puml.Class
import plantuml.eclipse.puml.PumlPackage
import plantuml.eclipse.puml.Method
import java.util.HashSet

/**
 * Custom validation rules. 
 *
 */
class PumlValidator extends AbstractPumlValidator {

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
	 * Checks for non-capital letters in first character of class names.
	 */
	@Check
	def checkForFirstLetterCapitalClass(Class someClass) {
		if(!Character.isUpperCase(someClass.name.charAt(0))){
			warning("First capitals of classes should be capital letters", PumlPackage::eINSTANCE.class_Name)
		}
	}
	 
	def boolean checkSuperTypesForCycle(HashSet<Class> visited, Class someClass) {
		for(Class current : someClass.superTypes){
	 		if(visited.contains(current)){
	 			warning("Cycle in hierarchy of class '" + someClass.name + "'", PumlPackage::eINSTANCE.class_SuperTypes)
	 			return true
	 		}else{
	 			val newVisited = visited
	 			newVisited.add(current)
	 			checkSuperTypesForCycle(newVisited, current)
	 		}
	 	}
	 	return false
	 }
	 
	 
	 
	 
	 
	 
	 
	 
}
