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
import plantuml.eclipse.puml.Association
import plantuml.eclipse.puml.EnumConstant
import org.eclipse.xtext.junit4.validation.ValidationTestHelper
import plantuml.eclipse.validation.PumlValidator
import plantuml.eclipse.puml.PumlPackage
import plantuml.eclipse.puml.NoteClass
import plantuml.eclipse.puml.AssociationType
import java.util.ArrayList
import plantuml.eclipse.puml.TitleClass

@RunWith(XtextRunner)
@InjectWith(PumlInjectorProvider)
class ClassDiagramTest {

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
		Assert::assertTrue(classAlice.abstract)
	}
	
	@Test
	def void classWithAttributes() {
		val heros = '''
			CLASS
			@startuml
			class Alice {
				+firstName : String
				+lastName : String
				-age : int
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
		Assert::assertEquals(Visibility.PUBLIC, firstAttrAlice.visibility)
		Assert::assertEquals("lastName", secondAttrAlice.name)
		Assert::assertEquals("String", firstAttrAlice.type)
		Assert::assertEquals(Visibility.PUBLIC, firstAttrAlice.visibility)
		Assert::assertEquals("age", thirdAttrAlice.name)
		Assert::assertEquals("int", thirdAttrAlice.type)
		Assert::assertEquals(Visibility.PRIVATE, thirdAttrAlice.visibility)
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
	def void visibilities() {
		val heros = '''
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
		val classAlice = ((heros.umlDiagrams.head as ClassUml).umlElements.get(0) as Class)
		val aliceAttr = #[
			classAlice.classContents.get(0) as Attribute,
			classAlice.classContents.get(1) as Attribute,
			classAlice.classContents.get(2) as Attribute,
			classAlice.classContents.get(3) as Attribute
		]
		Assert::assertEquals("Alice", classAlice.name)
		Assert::assertEquals("firstName", aliceAttr.get(0).name)
		Assert::assertEquals("String", aliceAttr.get(0).type)
		Assert::assertEquals(Visibility.PRIVATE, aliceAttr.get(0).visibility)
		Assert::assertEquals("lastName", aliceAttr.get(1).name)
		Assert::assertEquals("String", aliceAttr.get(1).type)
		Assert::assertEquals(Visibility.PUBLIC, aliceAttr.get(1).visibility)
		Assert::assertEquals("age", aliceAttr.get(2).name)
		Assert::assertEquals("int", aliceAttr.get(2).type)
		Assert::assertEquals(Visibility.DEFAULT, aliceAttr.get(2).visibility)
		Assert::assertEquals("height", aliceAttr.get(3).name)
		Assert::assertEquals("int", aliceAttr.get(3).type)
		Assert::assertEquals(Visibility.PROTECTED, aliceAttr.get(3).visibility)
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
		Assert::assertTrue(firstMethdAlice.abstract)
		Assert::assertEquals("getDate()", secondMethAlice.name)
		Assert::assertEquals("Date", secondMethAlice.type)
		Assert::assertTrue(secondMethAlice.static)
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
		Assert::assertTrue(firstAttrAlice.static)
		Assert::assertEquals("g", secondAttrAlice.name)
		Assert::assertEquals("float", secondAttrAlice.type)
		Assert::assertEquals(Visibility.PUBLIC, secondAttrAlice.visibility)
		Assert::assertTrue(secondAttrAlice.static)
	}
	
	@Test
	def void abstractAndStaticAttributes() {
		val heros = '''
			CLASS
			@startuml
			class Alice {
				{static}{abstract} -pi : float
				{abstract} +g : float
				{static} -h : float
			}
			@enduml
		'''.parse
		val classAlice = ((heros.umlDiagrams.head as ClassUml).umlElements.get(0) as Class)
		val firstAttrAlice = (classAlice.classContents.get(0) as Attribute)
		val secondAttrAlice = (classAlice.classContents.get(1) as Attribute)
		val thirdAttrAlice = (classAlice.classContents.get(2) as Attribute)
		Assert::assertEquals("Alice", classAlice.name)
		Assert::assertEquals("pi", firstAttrAlice.name)
		Assert::assertEquals("float", firstAttrAlice.type)
		Assert::assertEquals(Visibility.PRIVATE, firstAttrAlice.visibility)
		Assert::assertTrue(firstAttrAlice.abstract)
		Assert::assertTrue(firstAttrAlice.static)
		Assert::assertEquals("g", secondAttrAlice.name)
		Assert::assertEquals("float", secondAttrAlice.type)
		Assert::assertEquals(Visibility.PUBLIC, secondAttrAlice.visibility)
		Assert::assertTrue(secondAttrAlice.abstract)
		Assert::assertEquals("h", thirdAttrAlice.name)
		Assert::assertEquals("float", thirdAttrAlice.type)
		Assert::assertEquals(Visibility.PRIVATE, thirdAttrAlice.visibility)
		Assert::assertTrue(thirdAttrAlice.static)
	}
	
	@Test
	def void associationBidirectional(){
		val heros = '''
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
		val classUml = heros.umlDiagrams.head as ClassUml
		val classAlice = classUml.umlElements.get(0) as Class
		val classBob = classUml.umlElements.get(1) as Class
		val associations = #[
			classUml.umlElements.get(2) as Association,
			classUml.umlElements.get(3) as Association,
			classUml.umlElements.get(4) as Association,
			classUml.umlElements.get(5) as Association,
			classUml.umlElements.get(6) as Association
		]
		Assert::assertEquals("Alice", classAlice.name);
		Assert::assertEquals("Bob", classBob.name);
		for(Association association : associations){
			Assert::assertEquals(AssociationType.BIDIRECTIONAL, association.associationArrow)
		}
	}
	
	@Test
	def void title(){
		val heros = '''
			CLASS
			@startuml
			title Das ist der Titel des Diagrams
			@enduml
		'''.parse
		val classUml = heros.umlDiagrams.head as ClassUml
		val title = classUml.umlElements.get(0) as TitleClass
		val titleExpected = #["Das","ist","der","Titel","des","Diagrams"]
		for(var i = 0; i < title.value.size(); i++){
			Assert::assertEquals(titleExpected.get(i), title.value.get(i));
		}
	}
	
	@Test
	def void associationDirectional(){
		val heros = '''
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
		val classUml = heros.umlDiagrams.head as ClassUml
		val classAlice = classUml.umlElements.get(0) as Class
		val classBob = classUml.umlElements.get(1) as Class
		val associationsRight = new ArrayList<Association>()
		val associationsLeft = new ArrayList<Association>()
		for(var i = 2; i < 12; i+=2){
			associationsRight.add(classUml.umlElements.get(i) as Association)
			associationsLeft.add(classUml.umlElements.get(i+10) as Association)
		}
		Assert::assertEquals("Alice", classAlice.name);
		Assert::assertEquals("Bob", classBob.name);
		for(Association association : associationsRight){
			Assert::assertEquals(AssociationType.DIRECTIONALRIGHT, association.associationArrow)
		}
		for(Association association : associationsLeft){
			Assert::assertEquals(AssociationType.DIRECTIONALLEFT, association.associationArrow)
		}
	}
	
	@Test
	def void associationInheritance(){
		val heros = '''
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
		val classUml = heros.umlDiagrams.head as ClassUml
		val classAlice = classUml.umlElements.get(0) as Class
		val classBob = classUml.umlElements.get(1) as Class
		val associationsRight = #[
			classUml.umlElements.get(2) as Association,
			classUml.umlElements.get(3) as Association,
			classUml.umlElements.get(4) as Association
			]
		val associationsLeft = #[
			classUml.umlElements.get(5) as Association,
			classUml.umlElements.get(6) as Association,
			classUml.umlElements.get(7) as Association
			]
		Assert::assertEquals("Alice", classAlice.name);
		Assert::assertEquals("Bob", classBob.name);
		for(Association association : associationsRight){
			Assert::assertEquals(AssociationType.INHERITANCERIGHT, association.associationArrow)
		}
		for(Association association : associationsLeft){
			Assert::assertEquals(AssociationType.INHERITANCELEFT, association.associationArrow)
		}
	}
	
	@Test
	def void associationComposition(){
		val heros = '''
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
		val classUml = heros.umlDiagrams.head as ClassUml
		val classAlice = classUml.umlElements.get(0) as Class
		val classBob = classUml.umlElements.get(1) as Class
		val associationsRight = #[
			classUml.umlElements.get(2) as Association,
			classUml.umlElements.get(3) as Association,
			classUml.umlElements.get(4) as Association
			]
		val associationsLeft = #[
			classUml.umlElements.get(5) as Association,
			classUml.umlElements.get(6) as Association,
			classUml.umlElements.get(7) as Association
			]
		Assert::assertEquals("Alice", classAlice.name);
		Assert::assertEquals("Bob", classBob.name);
		for(Association association : associationsRight){
			Assert::assertEquals(AssociationType.COMPOSITIONRIGHT, association.associationArrow)
		}
		for(Association association : associationsLeft){
			Assert::assertEquals(AssociationType.COMPOSITIONLEFT, association.associationArrow)
		}
	}
	
	@Test
	def void associationAggregation(){
		val heros = '''
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
		val classUml = heros.umlDiagrams.head as ClassUml
		val classAlice = classUml.umlElements.get(0) as Class
		val classBob = classUml.umlElements.get(1) as Class
		val associationsRight = #[
			classUml.umlElements.get(2) as Association,
			classUml.umlElements.get(3) as Association,
			classUml.umlElements.get(4) as Association
			]
		val associationsLeft = #[
			classUml.umlElements.get(5) as Association,
			classUml.umlElements.get(6) as Association,
			classUml.umlElements.get(7) as Association
			]
		Assert::assertEquals("Alice", classAlice.name);
		Assert::assertEquals("Bob", classBob.name);
		for(Association association : associationsRight){
			Assert::assertEquals(AssociationType.AGGREGATIONRIGHT, association.associationArrow)
		}
		for(Association association : associationsLeft){
			Assert::assertEquals(AssociationType.AGGREGATIONLEFT, association.associationArrow)
		}
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
	
	@Test
	def void coloredClassesAndEnums(){
		val heros = '''
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
		val classUml = heros.umlDiagrams.head as ClassUml
		val classAlice = classUml.umlElements.get(0) as Class
		val classBob = classUml.umlElements.get(1) as Class
		val classMallory = classUml.umlElements.get(2) as Class
		val malloryAttr = classMallory.classContents.get(0) as Attribute
		val enumWeekend = classUml.umlElements.get(3) as Enum
		val weekendFirstAttr = enumWeekend.enumConstants.get(0) as EnumConstant
		val weekendSecondAttr = enumWeekend.enumConstants.get(1) as EnumConstant
		Assert::assertEquals("Alice", classAlice.name)
		Assert::assertEquals("#RosyBrown", classAlice.color)
		Assert::assertEquals("Bob", classBob.name)
		Assert::assertTrue(classBob.interface)
		Assert::assertEquals("#FF0028", classBob.color)
		Assert::assertEquals("Mallory", classMallory.name)
		Assert::assertEquals("#22AB99", classMallory.color)
		Assert::assertTrue(classMallory.abstract)
		Assert::assertEquals("age", malloryAttr.name)
		Assert::assertEquals("int", malloryAttr.type)
		Assert::assertEquals(Visibility.PRIVATE, malloryAttr.visibility)
		Assert::assertEquals("weekend", enumWeekend.name)
		Assert::assertEquals("#PapayaWhip", enumWeekend.color)
		Assert::assertEquals("SATURDAY", weekendFirstAttr.name)
		Assert::assertEquals("SUNDAY", weekendSecondAttr.name)
	}
	
	@Test
	def void attributesAndMethodsWithTypesArray(){
		val heros = '''
			CLASS
			@startuml
			class Alice {
				-friendNames : String[20]
				+getFriendNames() : String[]
			}
			@enduml
		'''.parse
		val classUml = heros.umlDiagrams.head as ClassUml
		val classAlice = classUml.umlElements.get(0) as Class
		val aliceAttr = classAlice.classContents.get(0) as Attribute
		val aliceMeth = classAlice.classContents.get(1) as Method
		Assert::assertEquals("Alice", classAlice.name)
		Assert::assertEquals("friendNames", aliceAttr.name)
		Assert::assertEquals("String", aliceAttr.type)
		Assert::assertTrue(aliceAttr.array)
		Assert::assertEquals(20, aliceAttr.length)
		Assert::assertEquals("getFriendNames()", aliceMeth.name)
		Assert::assertEquals("String", aliceMeth.type)
		Assert::assertTrue(aliceMeth.array)
		Assert::assertEquals(0, aliceMeth.length)
	}
	
	@Test
	def void notesOnClasses(){
		val heros = '''
			CLASS
			@startuml
			class Alice
			class Bob
			class Mallory
			note left of Alice
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
		val classUml = heros.umlDiagrams.head as ClassUml
		val aliceNote = classUml.umlElements.get(3) as NoteClass
		val aliceNoteValue = #["This","is","a","comment","for","Alice"]
		val bobNote = classUml.umlElements.get(4) as NoteClass
		val bobNoteValue = #["This","is","a","multiline","comment","for","Bob"]
		val malloryNote = classUml.umlElements.get(5) as NoteClass
		val malloryNoteValue = #["Something","important","for","Mallory"]
		Assert::assertEquals("Alice", aliceNote.noteOf.name)
		Assert::assertEquals(aliceNoteValue, aliceNote.value)
		Assert::assertEquals("Bob", bobNote.noteOf.name)
		Assert::assertEquals(bobNoteValue, bobNote.value)
		Assert::assertEquals("Mallory", malloryNote.noteOf.name)
		Assert::assertEquals(malloryNoteValue, malloryNote.value)
	}
	
	@Test
	def void dividerInClass(){
		val heros = '''
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
		val classUml = heros.umlDiagrams.head as ClassUml
		val classAlice = classUml.umlElements.get(0) as Class
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
	
	@Test
	def void invalidInterfaceImplementation(){
		val heros = '''
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
		val classUml = heros.umlDiagrams.head as ClassUml
		val bob = classUml.umlElements.get(1) as Class
		val methodOfBob = bob.classContents.get(0) as Method
		heros.assertWarning(PumlPackage::eINSTANCE.getClass_(),
			PumlValidator::OVERLOAD_METHOD_RETURN_TYPE,
			"Overload for return type of method '" + methodOfBob.name + "'"
		)
	}
	
	@Test
	def void invalidAssociationForDiagramType(){
		val heros = '''
			CLASS
			@startuml
			class Alice
			class Bob
			Alice --> Bob
			Alice o-->o Bob
			Alice ..> Bob
			@enduml
		'''.parse
		heros.assertError(PumlPackage::eINSTANCE.getAssociation(),
			PumlValidator::WRONG_ASSOCIATION_FOR_DIAGRAMTYPE,
			"This association is not allowed for class diagrams."
		)
	}
	
	
	
	
	
}