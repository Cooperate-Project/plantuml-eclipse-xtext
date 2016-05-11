package plantuml.eclipse

import plantuml.eclipse.puml.ClassUml
import org.eclipse.emf.ecore.resource.impl.ResourceSetImpl
import org.eclipse.emf.common.util.URI
import org.eclipse.emf.compare.scope.DefaultComparisonScope
import org.eclipse.emf.compare.EMFCompare
import org.eclipse.emf.ecore.util.EcoreUtil
import org.eclipse.emf.common.util.EList
import org.eclipse.emf.compare.Diff
import org.junit.Assert
import org.eclipse.emf.ecore.resource.Resource
import java.util.Map
import org.eclipse.emf.ecore.EPackage.Registry
import org.junit.BeforeClass
import org.eclipse.emf.ecore.xmi.impl.XMIResourceFactoryImpl
import org.eclipse.emf.ecore.EPackage
import plantuml.eclipse.puml.PumlPackage
import org.junit.AfterClass
import plantuml.eclipse.puml.UmlDiagram

class AbstractDiagramTest {
	
	private static Resource.Factory.Registry registry
	private static Map<String, Object> map
	private static Registry preg
	
	@BeforeClass
	static def void ressourceSetUp() {
		registry = Resource.Factory.Registry.INSTANCE
		
		map = registry.getExtensionToFactoryMap()
		map.put("xmi", new XMIResourceFactoryImpl())

		preg = EPackage.Registry.INSTANCE
		preg.replace(PumlPackage.eNS_URI, PumlPackage.eINSTANCE)
	}
	
	@AfterClass
	static def void cleanUp() {
		registry = null
		map = null
		preg = null
	}
	
	def UmlDiagram getUmlDiagram(String uri) {
		val resSet = new ResourceSetImpl()
    	val resource = resSet.getResource(URI.createURI(uri), true) 
    	
   		return resource.getContents().get(0) as UmlDiagram
	}
	
	def getClassDiagram(UmlDiagram umlDiagram) {
		return umlDiagram.umlDiagrams.filter(ClassUml).get(0)
	}
	
	def compare(ClassUml expected, ClassUml diagram) {
		val scope = new DefaultComparisonScope(expected, diagram, null)
		val comparison = EMFCompare.builder().build().compare(scope)
		return comparison.getDifferences();
	}
	
	def assertEqualsModel(ClassUml expected, ClassUml diagram) {		
		EcoreUtil.resolveAll(expected)
		val diff = compare(expected, diagram)
		try {
			Assert::assertTrue(diff.isEmpty)
		} catch(AssertionError e) {
			println("Differences:")
			printDiff(diff)
			throw(e)
		}
	}
	
	def printDiff(EList<Diff> diff) {
		for(d : diff) {
			println(d)
		}
	}
}
