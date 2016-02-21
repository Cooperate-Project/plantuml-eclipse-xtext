package plantuml.eclipse.validation

import org.eclipse.xtext.validation.Check
import plantuml.eclipse.puml.Class
import plantuml.eclipse.puml.EnumConstant
import plantuml.eclipse.puml.PumlPackage
import java.util.HashSet
import plantuml.eclipse.puml.Method
import java.util.HashMap

/**
 * This class provides custom rules that will be validated.
 */
class PumlValidator extends AbstractPumlValidator {

	public static val HIERARCHY_CYCLE = "plantuml.eclipse.puml.HierarchyCycle"
	public static val INVALID_ENUM_CONSTANT_NAME = "plantuml.eclipse.puml.InvalidEmunConstantName";
	public static val INVALID_CLASS_NAME = "plantuml.eclipse.puml.InvalidClassName"
	public static val INCOMPLETE_INTERFACE_IMPLEMENTATION = "plantuml.eclipse.IncompleteInterfaceImplementation"
	public static val OVERLOAD_METHOD_RETURN_TYPE = "plantuml.eclipse.OverloadMethodReturnType"

	// Helper
	private HashMap<String,String> interfaceMethods;

	/**
	 * TODO: Mark correctly for several super types.
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
	 * Helper method for {@link #checkNoCycleClassHierarchy checkNoCycleClassHierarchy} method.
	 */
	def boolean checkSuperTypesForCycle(HashSet<Class> visited, Class someClass) {
		for(Class current : someClass.superTypes){
	 		if(visited.contains(current)){
	 			warning("Cycle in hierarchy of class '" + someClass.name + "'", 
	 				PumlPackage::eINSTANCE.class_SuperTypes, 
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
	def checkForFirstLetterCapitalClassName(Class someClass) {
		if(!Character.isUpperCase(someClass.name.charAt(0)) && someClass.name.matches("[^\"]*")){
			warning("First capitals of classes should be capital letters", 
				PumlPackage::eINSTANCE.class_Name, 
				INVALID_CLASS_NAME, 
				someClass.name
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
	 * Checks for overloads of return types of implemented interface methods.
	 */ 
	@Check
	def checkImplements(Class someClass) {
		interfaceMethods = new HashMap<String,String>();
		// Loop through interfaces
		for(interface : someClass.interfaces){
			for(classContent : interface.classContents){
				if(classContent instanceof Method){
					// Put in HashMap
					// Example: Key("eineMethode()","String")
					val output = interfaceMethods.put(classContent.name, classContent.type)
					if(output != null && output != classContent.type){
						warning("Overload for return type of method '" + classContent.name  +"' through implemented interface '" + interface.name + "'", 
							PumlPackage::eINSTANCE.class_Name, 
							OVERLOAD_METHOD_RETURN_TYPE, 
							someClass.name
						)
					}
				}
			}
		}
		// Loop trough class methods
		for(classContent : someClass.classContents){
			if(classContent instanceof Method){
				val output = interfaceMethods.remove(classContent.name)
				if(output != null && output != classContent.type){
						warning("Overload for return type of method '" + classContent.name +"'", 
							PumlPackage::eINSTANCE.class_Name, 
							OVERLOAD_METHOD_RETURN_TYPE, 
							someClass.name
						)
				}
			}
		}
	}
	 
	 
	 
	 
	 
	 
}
