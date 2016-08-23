package plantuml.eclipse

import com.google.inject.Inject
import org.eclipse.xtext.junit4.InjectWith
import org.eclipse.xtext.junit4.XtextRunner
import org.eclipse.xtext.junit4.util.ParseHelper
import org.junit.Test
import org.junit.runner.RunWith

import plantuml.eclipse.puml.ClassUml
import plantuml.eclipse.puml.UmlDiagram
import plantuml.eclipse.puml.Method
import org.eclipse.xtext.junit4.validation.ValidationTestHelper
import plantuml.eclipse.validation.PumlValidator
import plantuml.eclipse.puml.PumlPackage
import plantuml.eclipse.puml.ClassDef

@RunWith(XtextRunner)
@InjectWith(PumlInjectorProvider)
class ClassDiagramTest extends AbstractDiagramTest {

	@Inject extension ParseHelper<UmlDiagram>
	@Inject extension ValidationTestHelper
	
	private static val TEST_FOLDER = "testmodels/"
		
	@Test
	def void classWithoutContents() {
		val xmiModel = getUmlDiagram(TEST_FOLDER + "classWithoutContents.xmi")
		val model = '''
			CLASS
			@startuml
			class Alice
			@enduml
		'''.parse
		assertEqualsModel(getClassDiagram(model), getClassDiagram(xmiModel))
	}
	
	@Test
	def void interfaceWithoutContents() {
		val xmiModel = getUmlDiagram(TEST_FOLDER + "interfaceWithoutContents.xmi")
		val model = '''
			CLASS
			@startuml
			interface Alice
			@enduml
		'''.parse
		assertEqualsModel(getClassDiagram(model), getClassDiagram(xmiModel))
	}
	
	@Test
	def void enumWithConstants() {
		val xmiModel = getUmlDiagram(TEST_FOLDER + "enumWithConstants.xmi")
		val model = '''
			CLASS
			@startuml
			enum weekend {
				SATURDAY ,
				SUNDAY
			}
			@enduml
		'''.parse
		assertEqualsModel(getClassDiagram(model), getClassDiagram(xmiModel))
	}
	
	@Test
	def void abstractClassWithoutContents() {
		val xmiModel = getUmlDiagram(TEST_FOLDER + "abstractClassWithoutContents.xmi")
		val model = '''
			CLASS
			@startuml
			abstract class Alice
			@enduml
		'''.parse
		assertEqualsModel(getClassDiagram(model), getClassDiagram(xmiModel))
	}
	
	@Test
	def void classWithAttributes() {
		val xmiModel = getUmlDiagram(TEST_FOLDER + "classWithAttributes.xmi")
		val model = '''
			CLASS
			@startuml
			class Alice {
				+firstName : String
				+lastName : String
				-age : int
			}
			@enduml
		'''.parse
		assertEqualsModel(getClassDiagram(model), getClassDiagram(xmiModel))
	}
	
	@Test
	def void classWithMethods() {
		val xmiModel = getUmlDiagram(TEST_FOLDER + "classWithMethods.xmi")
		val model = '''
			CLASS
			@startuml
			class Alice {
				+getAge() : int
			}
			@enduml
		'''.parse
		assertEqualsModel(getClassDiagram(model), getClassDiagram(xmiModel))
	}
	
	@Test
	def void visibilities() {
		val xmiModel = getUmlDiagram(TEST_FOLDER + "visibilities.xmi")
		val model = '''
			CLASS
			@startuml
			class Alice {
				-firstName : String
				+lastName : String
				~age : int
				#height : int
			}
			@enduml
		'''.parse
		assertEqualsModel(getClassDiagram(model), getClassDiagram(xmiModel))
	}
	
	@Test
	def void classWithMethodsAndAttributes() {
		val xmiModel = getUmlDiagram(TEST_FOLDER + "classWithMethodsAndAttributes.xmi")
		val model = '''
			CLASS
			@startuml
			class Alice {
				-age : int
				+getAge() : int
			}
			@enduml
		'''.parse
		assertEqualsModel(getClassDiagram(model), getClassDiagram(xmiModel))
	}
	
	@Test
	def void abstractAndStaticMethods() {
		val xmiModel = getUmlDiagram(TEST_FOLDER + "abstractAndStaticMethods.xmi")
		val model = '''
			CLASS
			@startuml
			class Alice {
				{abstract} -buildHouse() : House
				{static} getDate() : Date
			}
			@enduml
		'''.parse
		assertEqualsModel(getClassDiagram(model), getClassDiagram(xmiModel))
	}
	
	@Test
	def void staticAttributes() {
		val xmiModel = getUmlDiagram(TEST_FOLDER + "staticAttributes.xmi")
		val model = '''
			CLASS
			@startuml
			class Alice {
				{static} -pi : float
				{static} +g : float
			}
			@enduml
		'''.parse
		assertEqualsModel(getClassDiagram(model), getClassDiagram(xmiModel))
	}
	
	@Test
	def void abstractAndStaticAttributes() {
		val xmiModel = getUmlDiagram(TEST_FOLDER + "abstractAndStaticAttributes.xmi")
		val model = '''
			CLASS
			@startuml
			class Alice {
				{static}{abstract} -pi : float
				{abstract} +g : float
				{static} -h : float
			}
			@enduml
		'''.parse
		assertEqualsModel(getClassDiagram(model), getClassDiagram(xmiModel))
	}
	
	@Test
	def void associationBidirectional(){
		val xmiModel = getUmlDiagram(TEST_FOLDER + "associationBidirectional.xmi")
		val model = '''
			CLASS
			@startuml
			class Alice
			class Bob
			Alice .. Bob
			Alice -- Bob
			Alice ------ Bob
			Alice .[#Red]. Bob
			Alice ..[#FF00FF].... Bob
			@enduml
		'''.parse
		assertEqualsModel(getClassDiagram(model), getClassDiagram(xmiModel))
	}
	
	@Test
	def void title(){
		val xmiModel = getUmlDiagram(TEST_FOLDER + "title.xmi")
		val model = '''
			CLASS
			@startuml
			title "title of the diagram"
			@enduml
		'''.parse
		assertEqualsModel(getClassDiagram(model), getClassDiagram(xmiModel))
	}
	
	@Test
	def void associationDirectional(){
		val xmiModel = getUmlDiagram(TEST_FOLDER + "associationDirectional.xmi")
		val model = '''
			CLASS
			@startuml
			class Alice
			class Bob
			Alice -> Bob
			Alice .> Bob
			Alice --> Bob
			Alice ..> Bob
			Alice ----> Bob
			Alice ....> Bob
			Alice -[#Green]-> Bob
			Alice .[#00FF00].> Bob
			Alice --[#SkyBlue]--> Bob
			Alice ..[#Orange]..> Bob
			Alice <- Bob
			Alice <. Bob
			Alice <-- Bob
			Alice <.. Bob
			Alice <---- Bob
			Alice <.... Bob
			Alice <-[#Green]- Bob
			Alice <.[#00FF00]. Bob
			Alice <--[#SkyBlue]-- Bob
			Alice <..[#Orange].. Bob
			@enduml
		'''.parse
		assertEqualsModel(getClassDiagram(model), getClassDiagram(xmiModel))
	}
	
	@Test
	def void associationInheritance(){
		val xmiModel = getUmlDiagram(TEST_FOLDER + "associationInheritance.xmi")
		val model = '''
			CLASS
			@startuml
			class Alice
			class Bob
			Alice --|> Bob
			Alice ..|> Bob
			Alice -[#FF0022]-|> Bob
			Alice <|-- Bob
			Alice <|.. Bob
			Alice <|-[#Orange]- Bob
			@enduml
		'''.parse
		assertEqualsModel(getClassDiagram(model), getClassDiagram(xmiModel))
	}
	
	@Test
	def void associationComposition(){
		val xmiModel = getUmlDiagram(TEST_FOLDER + "associationComposition.xmi")
		val model = '''
			CLASS
			@startuml
			class Alice
			class Bob
			Alice --* Bob
			Alice ..* Bob
			Alice -[#123456]-* Bob
			Alice *-- Bob
			Alice *.. Bob
			Alice *-[#Red]- Bob
			@enduml
		'''.parse
		assertEqualsModel(getClassDiagram(model), getClassDiagram(xmiModel))
	}
	
	@Test
	def void associationAggregation(){
		val xmiModel = getUmlDiagram(TEST_FOLDER + "associationAggregation.xmi")
		val model = '''
			CLASS
			@startuml
			class Alice
			class Bob
			Alice --o Bob
			Alice ..o Bob
			Alice -[#123456]-o Bob
			Alice o-- Bob
			Alice o.. Bob
			Alice o-[#Red]- Bob
			@enduml
		'''.parse
		assertEqualsModel(getClassDiagram(model), getClassDiagram(xmiModel))
	}
	
	@Test
	def void classesExtendsAndImplements(){
		val xmiModel = getUmlDiagram(TEST_FOLDER + "classesExtendsAndImplements.xmi")
		val model = '''
			CLASS
			@startuml
			class A
			interface I
			interface J
			class B extends A
			class C extends A , B
			class D implements I
			class E implements I , J
			class F extends A implements I , J
			@enduml
		'''.parse
		assertEqualsModel(getClassDiagram(model), getClassDiagram(xmiModel))
	}
	
	@Test
	def void coloredClassesAndEnums(){
		val xmiModel = getUmlDiagram(TEST_FOLDER + "coloredClassesAndEnums.xmi")
		val model = '''
			CLASS
			@startuml
			class Alice #RosyBrown
			interface Bob #FF0028
			abstract class Mallory #22AB99 {
				-age : int
			}
			enum weekend #PapayaWhip {
				SATURDAY ,
				SUNDAY
			}
			@enduml
		'''.parse
		assertEqualsModel(getClassDiagram(model), getClassDiagram(xmiModel))
	}
	
	@Test
	def void attributesAndMethodsWithTypesArray(){
		val xmiModel = getUmlDiagram(TEST_FOLDER + "attributesAndMethodsWithTypesArray.xmi")
		val model = '''
			CLASS
			@startuml
			class Alice {
				-friendNames : String[20]
				+getFriendNames() : String[]
			}
			@enduml
		'''.parse
		assertEqualsModel(getClassDiagram(model), getClassDiagram(xmiModel))
	}
	
	@Test
	def void notesOnClasses(){
		val xmiModel = getUmlDiagram(TEST_FOLDER + "notesOnClasses.xmi")
		val model = '''
			CLASS
			@startuml
			class Alice
			class Bob
			class Mallory
			note top of Alice
				This is a comment for Alice
			end note
			note left of Bob
				This is a multiline
				comment for Bob
			end note
			note right of Mallory
				Something important for Mallory
			end note
			@enduml
		'''.parse
		assertEqualsModel(getClassDiagram(model), getClassDiagram(xmiModel))
	}
	
	/*/@Test
	def void dividerInClass(){
		val model = '''
			CLASS
			@startuml
			class Alice {
				== Attributes ==
				#username : String
				__ Encrypted Attributes __
				-password : String
				== Methods ==
				+getUserName() : String
				__ Reserved __
			}
			end note
			@enduml
		'''.parse
		val classUml = model.umlDiagrams.head as ClassUml
		val classAlice = classUml.umlElements.get(0) as ClassDef
		val aliceContents = #[
			classAlice.classContents.get(0) as Attribute,
			classAlice.classContents.get(1) as Attribute,
			classAlice.classContents.get(2) as Method
		]
		Assert::assertEquals("Alice", classAlice.name)
		Assert::assertEquals("username", aliceContents.get(0).name)
		Assert::assertEquals("String", aliceContents.get(0).type)
		Assert::assertEquals(Visibility.PROTECTED, aliceContents.get(0).visibility)
		Assert::assertEquals("password", aliceContents.get(1).name)
		Assert::assertEquals("String", aliceContents.get(1).type)
		Assert::assertEquals(Visibility.PRIVATE, aliceContents.get(1).visibility)
		Assert::assertEquals("getUserName()", aliceContents.get(2).name)
		Assert::assertEquals("String", aliceContents.get(2).type)
		Assert::assertEquals(Visibility.PUBLIC, aliceContents.get(2).visibility)
	}*/
	
	// ==================================================================================
	// =========================== VALIDATOR TESTS ======================================
	// ==================================================================================
	
	@Test
	def void cycleInSuperTypeHierarchy(){
		val model = '''
			CLASS
			@startuml
			class A extends B
			class B extends C
			class C extends A
			@enduml
		'''.parse
		
		model.assertWarning(PumlPackage::eINSTANCE.classDef,
			PumlValidator::HIERARCHY_CYCLE,
			"Cycle in hierarchy of class 'A'"
		)
		model.assertWarning(PumlPackage::eINSTANCE.classDef,
			PumlValidator::HIERARCHY_CYCLE,
			"Cycle in hierarchy of class 'B'"
		)
		model.assertWarning(PumlPackage::eINSTANCE.classDef,
			PumlValidator::HIERARCHY_CYCLE,
			"Cycle in hierarchy of class 'C'"
		)
	}
	
	@Test
	def void invalidEnumConstantName(){
		val model = '''
			CLASS
			@startuml
			enum weekend {
				SATURDAY ,
				sunday
			}
			@enduml
		'''.parse
		model.assertWarning(PumlPackage::eINSTANCE.enumConstant,
			PumlValidator::INVALID_ENUM_CONSTANT_NAME,
			"Enum constants should be upper case"
		)
	}
	
	@Test
	def void invalidClassName(){
		val model = '''
			CLASS
			@startuml
			class alice
			@enduml
		'''.parse
		model.assertWarning(PumlPackage::eINSTANCE.classDef,
			PumlValidator::INVALID_CLASS_NAME,
			"First capitals of classes should be capital letters"
		)
	}
	
	@Test
	def void invalidInterfaceImplementation(){
		val model = '''
			CLASS
			@startuml
			interface AnInterface {
				+doSomething() : Something
			}
			class Bob implements AnInterface {
				+doSomething() : AnotherSomething
			}
			@enduml
		'''.parse
		val classUml = model.umlDiagrams.head as ClassUml
		val bob = classUml.umlElements.get(1) as ClassDef
		val methodOfBob = bob.contents.get(0) as Method
		model.assertWarning(PumlPackage::eINSTANCE.classDef,
			PumlValidator::OVERLOAD_METHOD_RETURN_TYPE,
			"Overload for return type of method '" + methodOfBob.name + "'"
		)
	}
	
	@Test
	def void invalidAssociationForDiagramType(){
		val model = '''
			CLASS
			@startuml
			class Alice
			class Bob
			Alice --> Bob
			Alice o-->o Bob
			Alice ..> Bob
			@enduml
		'''.parse
		model.assertError(PumlPackage::eINSTANCE.getAssociation(),
			PumlValidator::WRONG_ASSOCIATION_FOR_DIAGRAMTYPE,
			"This association is not allowed for class diagrams."
		)
	}
	
	
	
	
	
}