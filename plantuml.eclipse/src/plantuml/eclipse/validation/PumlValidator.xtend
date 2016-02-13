package plantuml.eclipse.validation

import org.eclipse.xtext.validation.Check
import plantuml.eclipse.puml.Class
import plantuml.eclipse.puml.PumlPackage

/**
 * Custom validation rules. 
 *
 */
class PumlValidator extends AbstractPumlValidator {

	@Check
	def checkNoCycleClassHierarchy(Class someClass) {
		if(someClass.superTypes == null){
			return
		}
		val visitedClasses = <Class>newHashSet()
		visitedClasses.add(someClass)
		var current = someClass.superTypes
		while(current != null){
			if(visitedClasses.contains(current)){
				error("Cycle in hierarchy of class '" + current.name + "'", PumlPackage::eINSTANCE.class_SuperTypes)
				return
			}
			visitedClasses.add(current)
			current = current.superTypes
		} 
	}
}
