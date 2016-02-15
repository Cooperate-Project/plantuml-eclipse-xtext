package plantuml.eclipse

import com.google.inject.Inject
import org.eclipse.xtext.junit4.InjectWith
import org.eclipse.xtext.junit4.XtextRunner
import org.eclipse.xtext.junit4.util.ParseHelper
import org.junit.Assert
import org.junit.Test
import org.junit.runner.RunWith

import plantuml.eclipse.puml.ClassUml
import plantuml.eclipse.puml.UmlDiagram
import plantuml.eclipse.puml.Class
import plantuml.eclipse.puml.Enum
import plantuml.eclipse.puml.Attribute
import plantuml.eclipse.puml.Visibility
import plantuml.eclipse.puml.Method
import plantuml.eclipse.puml.Classifier
import plantuml.eclipse.puml.Association
import plantuml.eclipse.puml.Bidirectional
import plantuml.eclipse.puml.EnumConstant
import org.eclipse.xtext.junit4.validation.ValidationTestHelper
import plantuml.eclipse.validation.PumlValidator
import plantuml.eclipse.puml.PumlPackage

@RunWith(XtextRunner)
@InjectWith(PumlInjectorProvider)
class ClassDiagramTests {

	@Inject extension ParseHelper<UmlDiagram>
	@Inject extension ValidationTestHelper
	
	@Test
	def void classWithoutContents() {
		val heros = '''
			CLASS
			@startuml
			class Alice
			@enduml
		'''.parse
		val classAlice = ((heros.umlDiagrams.head as ClassUml).umlElements.get(0) as Class)
		Assert::assertEquals("Alice", classAlice.name)
	}
	
	@Test
	def void interfaceWithoutContents() {
		val heros = '''
			CLASS
			@startuml
			interface Alice
			@enduml
		'''.parse
		val interfaceAlice = ((heros.umlDiagrams.head as ClassUml).umlElements.get(0) as Class)
		Assert::assertEquals("Alice", interfaceAlice.name)
		Assert::assertTrue(interfaceAlice.interface)
	}
	
	@Test
	def void enumWithConstants() {
		val heros = '''
			CLASS
			@startuml
			enum weekend {
				SATURDAY ,
				SUNDAY
			}
			@enduml
		'''.parse
		val enumWeekend = ((heros.umlDiagrams.head as ClassUml).umlElements.get(0) as Enum)
		val firstConstant = (enumWeekend.enumConstants.get(0) as EnumConstant)
		val secondConstant = (enumWeekend.enumConstants.get(1) as EnumConstant)
		Assert::assertEquals("weekend", enumWeekend.name)
		Assert::assertEquals(2, enumWeekend.enumConstants.length)
		Assert::assertEquals("SATURDAY", firstConstant.name)
		Assert::assertEquals("SUNDAY", secondConstant.name)	
	}
	
	@Test
	def void abstractClassWithoutContents() {
		val heros = '''
			CLASS
			@startuml
			abstract class Alice
			@enduml
		'''.parse
		val classAlice = ((heros.umlDiagrams.head as ClassUml).umlElements.get(0) as Class)
		Assert::assertEquals("Alice", classAlice.name)
		Assert::assertEquals("abstract", classAlice.classifier)
	}
	
	@Test
	def void classWithAttributes() {
		val heros = '''
			CLASS
			@startuml
			class Alice {
				-firstName : String
				-lastName : String
				+age : int
			}
			@enduml
		'''.parse
		val classAlice = ((heros.umlDiagrams.head as ClassUml).umlElements.get(0) as Class)
		val firstAttrAlice = (classAlice.classContents.get(0) as Attribute)
		val secondAttrAlice = (classAlice.classContents.get(1) as Attribute)
		val thirdAttrAlice = (classAlice.classContents.get(2) as Attribute)
		Assert::assertEquals("Alice",classAlice.name)
		Assert::assertEquals(3,classAlice.classContents.length)
		Assert::assertEquals("firstName", firstAttrAlice.name)
		Assert::assertEquals("String", firstAttrAlice.type)
		Assert::assertEquals(Visibility.PRIVATE, firstAttrAlice.visibility)
		Assert::assertEquals("lastName", secondAttrAlice.name)
		Assert::assertEquals("String", firstAttrAlice.type)
		Assert::assertEquals(Visibility.PRIVATE, firstAttrAlice.visibility)
		Assert::assertEquals("age", thirdAttrAlice.name)
		Assert::assertEquals("int", thirdAttrAlice.type)
		Assert::assertEquals(Visibility.PUBLIC, thirdAttrAlice.visibility)
	}
	
	@Test
	def void classWithMethods() {
		val heros = '''
			CLASS
			@startuml
			class Alice {
				+getAge() : int
			}
			@enduml
		'''.parse
		val classAlice = ((heros.umlDiagrams.head as ClassUml).umlElements.get(0) as Class)
		val methAlice = (classAlice.classContents.get(0) as Method)
		Assert::assertEquals("Alice", classAlice.name)
		Assert::assertEquals("getAge()", methAlice.name)
		Assert::assertEquals("int", methAlice.type)
		Assert::assertEquals(Visibility.PUBLIC, methAlice.visibility)
	}
	
	@Test
	def void classWithMethodsAndAttributes() {
		val heros = '''
			CLASS
			@startuml
			class Alice {
				-age : int
				+getAge() : int
			}
			@enduml
		'''.parse
		val classAlice = ((heros.umlDiagrams.head as ClassUml).umlElements.get(0) as Class)
		val attrAlice = (classAlice.classContents.get(0) as Attribute)
		val methAlice = (classAlice.classContents.get(1) as Method)
		Assert::assertEquals("Alice", classAlice.name)
		Assert::assertEquals("age", attrAlice.name)
		Assert::assertEquals("int", attrAlice.type)
		Assert::assertEquals(Visibility.PRIVATE, attrAlice.visibility)
		Assert::assertEquals("getAge()", methAlice.name)
		Assert::assertEquals("int", methAlice.type)
		Assert::assertEquals(Visibility.PUBLIC, methAlice.visibility)
	}
	
	@Test
	def void abstractAndStaticMethods() {
		val heros = '''
			CLASS
			@startuml
			class Alice {
				{abstract} -buildHouse() : House
				{static} getDate() : Date
			}
			@enduml
		'''.parse
		val classAlice = ((heros.umlDiagrams.head as ClassUml).umlElements.get(0) as Class)
		val firstMethdAlice = (classAlice.classContents.get(0) as Method)
		val secondMethAlice = (classAlice.classContents.get(1) as Method)
		Assert::assertEquals("Alice", classAlice.name)
		Assert::assertEquals("buildHouse()", firstMethdAlice.name)
		Assert::assertEquals("House", firstMethdAlice.type)
		Assert::assertEquals(Visibility.PRIVATE, firstMethdAlice.visibility)
		Assert::assertEquals(Classifier.ABSTRACT, firstMethdAlice.classifier)
		Assert::assertEquals("getDate()", secondMethAlice.name)
		Assert::assertEquals("Date", secondMethAlice.type)
		Assert::assertEquals(Classifier.STATIC, secondMethAlice.classifier)
	}
	
	@Test
	def void staticAttributes() {
		val heros = '''
			CLASS
			@startuml
			class Alice {
				{static} -pi : float
				{static} +g : float
			}
			@enduml
		'''.parse
		val classAlice = ((heros.umlDiagrams.head as ClassUml).umlElements.get(0) as Class)
		val firstAttrAlice = (classAlice.classContents.get(0) as Attribute)
		val secondAttrAlice = (classAlice.classContents.get(1) as Attribute)
		Assert::assertEquals("Alice", classAlice.name)
		Assert::assertEquals("pi", firstAttrAlice.name)
		Assert::assertEquals("float", firstAttrAlice.type)
		Assert::assertEquals(Visibility.PRIVATE, firstAttrAlice.visibility)
		Assert::assertEquals(Classifier.STATIC, firstAttrAlice.classifier)
		Assert::assertEquals("g", secondAttrAlice.name)
		Assert::assertEquals("float", secondAttrAlice.type)
		Assert::assertEquals(Visibility.PUBLIC, secondAttrAlice.visibility)
		Assert::assertEquals(Classifier.STATIC, secondAttrAlice.classifier)
	}
	
	@Test
	def void associationBidirectional(){
		val heros = '''
			CLASS
			@startuml
			class Alice
			class Bob
			Alice -- Bob
			Alice - Bob
			@enduml
		'''.parse
		val classUml = heros.umlDiagrams.head as ClassUml
		val classAlice = classUml.umlElements.get(0) as Class
		val classBob = classUml.umlElements.get(1) as Class
		val firstAsso = classUml.umlElements.get(2) as Association
		val secondAsso = classUml.umlElements.get(3) as Association
		Assert::assertEquals("Alice", classAlice.name);
		Assert::assertEquals("Bob", classBob.name);
		Assert::assertEquals("Alice", firstAsso.classFrom.name);
		Assert::assertEquals("Bob", firstAsso.classTo.name);
		Assert::assertTrue(firstAsso.associationType instanceof Bidirectional);
		Assert::assertEquals("Alice", secondAsso.classFrom.name);
		Assert::assertEquals("Bob", secondAsso.classTo.name);
		Assert::assertTrue(secondAsso.associationType instanceof Bidirectional);
	}
	
	@Test
	def void classesExtendsAndImplements(){
		val heros = '''
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
		val classUml = heros.umlDiagrams.head as ClassUml
		val classA = classUml.umlElements.get(0) as Class
		val interfaceI = classUml.umlElements.get(1) as Class
		val interfaceJ = classUml.umlElements.get(2) as Class
		val classB = classUml.umlElements.get(3) as Class
		val classC = classUml.umlElements.get(4) as Class
		val classD = classUml.umlElements.get(5) as Class
		val classE = classUml.umlElements.get(6) as Class
		val classF = classUml.umlElements.get(7) as Class
		Assert::assertEquals("A", classB.superTypes.get(0).name)
		Assert::assertEquals("A", classC.superTypes.get(0).name)
		Assert::assertEquals("B", classC.superTypes.get(1).name)
		Assert::assertEquals("I", classD.interfaces.get(0).name)
		Assert::assertEquals("I", classE.interfaces.get(0).name)
		Assert::assertEquals("J", classE.interfaces.get(1).name)
		Assert::assertEquals("A", classF.superTypes.get(0).name)
		Assert::assertEquals("I", classF.interfaces.get(0).name)
		Assert::assertEquals("J", classF.interfaces.get(1).name)
	}
	
	
	// ==================================================================================
	// =========================== VALIDATOR TESTS ======================================
	// ==================================================================================
	
	@Test
	def void cycleInSuperTypeHierarchy(){
		val heros = '''
			CLASS
			@startuml
			class A extends B
			class B extends C
			class C extends A
			@enduml
		'''.parse
		
		heros.assertWarning(PumlPackage::eINSTANCE.getClass_(),
			PumlValidator::HIERARCHY_CYCLE,
			"Cycle in hierarchy of class 'A'"
		)
		heros.assertWarning(PumlPackage::eINSTANCE.getClass_(),
			PumlValidator::HIERARCHY_CYCLE,
			"Cycle in hierarchy of class 'B'"
		)
		heros.assertWarning(PumlPackage::eINSTANCE.getClass_(),
			PumlValidator::HIERARCHY_CYCLE,
			"Cycle in hierarchy of class 'C'"
		)
	}
	
	@Test
	def void invalidEnumConstantName(){
		val heros = '''
			CLASS
			@startuml
			enum weekend {
				SATURDAY ,
				sunday
			}
			@enduml
		'''.parse
		heros.assertWarning(PumlPackage::eINSTANCE.enumConstant,
			PumlValidator::INVALID_ENUM_CONSTANT_NAME,
			"Enum constants should be upper case"
		)
	}
	
	@Test
	def void invalidClassName(){
		val heros = '''
			CLASS
			@startuml
			class alice
			@enduml
		'''.parse
		heros.assertWarning(PumlPackage::eINSTANCE.getClass_(),
			PumlValidator::INVALID_CLASS_NAME,
			"First capitals of classes should be capital letters"
		)
	}
	
	
	
	
	
	
	
	
	
}