/*
* generated by Xtext
*/
package plantuml.eclipse.ui.labeling

import com.google.inject.Inject

import org.eclipse.emf.edit.ui.provider.AdapterFactoryLabelProvider
import org.eclipse.jface.viewers.StyledString
import org.eclipse.xtext.ui.IImageHelper
import org.eclipse.xtext.ui.label.DefaultEObjectLabelProvider
import org.eclipse.xtext.common.types.JvmVisibility
import org.eclipse.xtext.xbase.ui.labeling.XbaseImages2
import org.eclipse.jdt.ui.JavaElementImageDescriptor;

import plantuml.eclipse.puml.Association
import plantuml.eclipse.puml.Attribute
import plantuml.eclipse.puml.Classifier
import plantuml.eclipse.puml.ClassUml
import plantuml.eclipse.puml.Enum
import plantuml.eclipse.puml.EnumConstant
import plantuml.eclipse.puml.Method
import plantuml.eclipse.puml.Visibility
import plantuml.eclipse.puml.AssociationType
import plantuml.eclipse.puml.InterfaceDef

/**
 * Provides labels for a EObjects.
 * TODO: Multiple icons per entry to display something is static or abstract.
 */
class PumlLabelProvider extends DefaultEObjectLabelProvider {

	@Inject private IImageHelper imageHelper
	@Inject private XbaseImages2 images
    
    /** Association Type Tuples */
	static final val ASSOCIATION_LABELS = newHashMap(
		AssociationType.NONDIRECTIONAL -> "--",
		AssociationType.DIRECTIONALLEFT -> "<--",
		AssociationType.DIRECTIONALRIGHT -> "-->",
		AssociationType.BIDIRECTIONAL -> "<-->",
		AssociationType.INHERITANCELEFT -> "<|--",
		AssociationType.INHERITANCERIGHT -> "--|>",
		AssociationType.REALIZATIONLEFT -> "<|..",
		AssociationType.REALIZATIONRIGHT -> "..|>",
		AssociationType.COMPOSITIONLEFT -> "*--",
		AssociationType.COMPOSITIONRIGHT -> "--*",
		AssociationType.AGGREGATIONLEFT -> "o--",
		AssociationType.AGGREGATIONRIGHT -> "--o"
	)

	@Inject
	new(AdapterFactoryLabelProvider delegate) {
		super(delegate);
	}
	
	// -------------------------------------------------------------------------------------------
	// ---------------------------------------- Texts --------------------------------------------
	// -------------------------------------------------------------------------------------------

	/**
	 * @return The label text for the PlantUML-Class-Group.
	 */
	def text(ClassUml classUml) {
		"Class Diagram"
	}
	
	/**
	 * @return The label text for Enums.
	 */
	def text(Enum someEnum){
		return " " + someEnum.name
	}
	
	/**
	 * @return The label text for enum constants.
	 */
	def text(EnumConstant enumConstant){
		return " " + enumConstant.name
	}
	
	
	/**
	 * @return The label text for connections.
	 */
	 def text(Association association){
		var styledLabel = new StyledString()
		styledLabel.append(association.classLeft.name + " ");
		// Which association do we have?
		styledLabel.append(ASSOCIATION_LABELS.get(association.associationArrow))
		styledLabel.append(" " + association.classRight.name);
		if(association.label != null && association.label.length != 0){
			var label = new StringBuffer(" : ");
			/*for(String text : association.label){
				label.append(text + " ")
			}*/
			styledLabel.append(new StyledString(label.toString(), StyledString::DECORATIONS_STYLER))
		}
		return styledLabel
	 }

	/**
	 * @return The label text for classes.
	 */
	def text(Classifier someClass) {
		var styledLabel = new StyledString()
		if(someClass.longName == null){
			styledLabel.append(" " + someClass.getName())
		}else{
			styledLabel.append(" " + someClass.longName)
			styledLabel.append(new StyledString(" [", StyledString::DECORATIONS_STYLER))
			styledLabel.append(someClass.name)
			styledLabel.append(new StyledString("]", StyledString::DECORATIONS_STYLER))
		}
		if(someClass.inheritance.generalizations != null && someClass.inheritance.generalizations.length != 0){
			var buffer = new StringBuffer();
			buffer.append(" extends " + someClass.inheritance.generalizations.get(0).superType.name);
			for(var i = 1; i < someClass.inheritance.generalizations.length;i++){
				buffer.append(", " + someClass.inheritance.generalizations.get(i).superType.name)
			}
			styledLabel.append(new StyledString(buffer.toString(), StyledString::DECORATIONS_STYLER))
		}
		return styledLabel
	}
		
	/**
	 * @return The label text for attributes.
	 */
	def text(Attribute attribute){
		var styledLabel = new StyledString()
		styledLabel.append(" " + attribute.getName())
		var label = new StringBuffer();
		if(attribute.type != null){
			label.append(" : " + attribute.type)
			/*if(attribute.array){
				label.append("[")
				if(attribute.length > 0){
					label.append(attribute.length)
				}
				label.append("]")
			}*/
			if(attribute.length >= 0){
				label.append("[")
				label.append(attribute.length)
				label.append("]")
			}
				
		}
		styledLabel.append(new StyledString(label.toString(), StyledString::DECORATIONS_STYLER))
		return styledLabel
	}
	
	/**
	 * @return The label text for methods.
	 */
	def text(Method method){
		var styledLabel = new StyledString()
		styledLabel.append(" " + method.getName())
		var label = new StringBuffer()
		if(method.type != null){
			label.append(" : " + method.type)
			/*if(method.array){
				label.append("[")
				if(method.length >= 0){
					label.append(method.length)
				}
				label.append("]")
			}*/
			if(method.length >= 0){
				label.append("[")
				label.append(method.length)
				label.append("]")
			}
		}
		styledLabel.append(new StyledString(label.toString(), StyledString::DECORATIONS_STYLER))
		return styledLabel
	}
	
	// -------------------------------------------------------------------------------------------
	// ---------------------------------------- Icons --------------------------------------------
	// -------------------------------------------------------------------------------------------
	
	/**
	 * @return The image for the PlantUML-Class-Group.
	 */
	def image(ClassUml classUml){
		imageHelper.getImage("java_model_obj.png")
	}
	
	/**
	 * @return The images for attributes.
	 */
	def image(Attribute attribute){
		if(attribute.visibility == Visibility.PROTECTED){
			images.forField(JvmVisibility.PROTECTED, getAdornments(attribute))
		}else if(attribute.visibility == Visibility.PRIVATE){
			images.forField(JvmVisibility.PRIVATE, getAdornments(attribute))
		}else if(attribute.visibility == Visibility.PUBLIC){
			images.forField(JvmVisibility.PUBLIC, getAdornments(attribute))
		}else if(attribute.visibility == Visibility.DEFAULT){
			images.forField(JvmVisibility.DEFAULT, getAdornments(attribute))
		}
	}
	
	/**
	 * @return The image für enum constants.
	 */
	 def image(EnumConstant enumConstant){
	 	images.forField(JvmVisibility.PUBLIC, getAdornments(enumConstant))
	 }
	
	/**
	 * @return The images for methods.
	 */
	def image(Method method){
		if(method.visibility == Visibility.PROTECTED){
			images.forOperation(JvmVisibility.PROTECTED, getAdornments(method))
		}else if(method.visibility == Visibility.PRIVATE){
			images.forOperation(JvmVisibility.PRIVATE, getAdornments(method))
		}else if(method.visibility == Visibility.PUBLIC){
			images.forOperation(JvmVisibility.PUBLIC, getAdornments(method))
		}else if(method.visibility == Visibility.DEFAULT){
			images.forOperation(JvmVisibility.DEFAULT, getAdornments(method))
		}
	}
	
	/**
	 * @return The image for enums.
	 */
	def image(Enum someEnum){
		images.forEnum(JvmVisibility.PUBLIC, getAdornments(someEnum))
	}
	
	/**
	 * @return The images for classes.
	 */
	def image(Classifier someClass){
		if(someClass instanceof InterfaceDef){
			images.forInterface(JvmVisibility.PUBLIC, getAdornments(someClass))
		}else{
			images.forClass(JvmVisibility.PUBLIC, getAdornments(someClass))
		}
	}
	
	/** 
	 * @return The image for the associations.
	 */
	 def image(Association association){
	 	if(association.associationArrow == AssociationType.BIDIRECTIONAL){
	 		imageHelper.getImage("ref_co.png")
	 	}else if(association.associationArrow == AssociationType.INHERITANCELEFT
	 		|| association.associationArrow == AssociationType.INHERITANCERIGHT){
	 		imageHelper.getImage("implm_co.png")
	 	}else if(association.associationArrow == AssociationType.COMPOSITIONLEFT
	 		|| association.associationArrow == AssociationType.COMPOSITIONRIGHT){
	 		imageHelper.getImage("comp_co.png")
	 	}else if(association.associationArrow == AssociationType.AGGREGATIONLEFT
	 		|| association.associationArrow == AssociationType.AGGREGATIONRIGHT){
	 		imageHelper.getImage("aggr_co.png")
	 	}else if(association.associationArrow == AssociationType.DIRECTIONALLEFT
	 		|| association.associationArrow == AssociationType.DIRECTIONALRIGHT){
	 		imageHelper.getImage("ref_co.png")
	 	}
	 }
	
	// -------------------------------------------------------------------------------------------
	// ---------------------------------------- Helper -------------------------------------------
	// -------------------------------------------------------------------------------------------

	/**
	 * @param obj The object to check for adorments.
	 * @return Adornment for decoraters.
	 */
	def private dispatch getAdornments(Enum obj){
		var adornment = 0
		adornment += JavaElementImageDescriptor.FINAL
		adornment += JavaElementImageDescriptor.STATIC
	}	
	
	def private dispatch getAdornments(Attribute obj){
		var adornment = 0
		if(obj.static){
			adornment += JavaElementImageDescriptor.STATIC
		}
		if(obj.abstract){
			adornment += JavaElementImageDescriptor.ABSTRACT
		}
		if(obj.name.matches("([A-Z]|_)*")){
			adornment += JavaElementImageDescriptor.FINAL
		}		
	}
	
	def private dispatch getAdornments(Method obj){
		var adornment = 0
		if(obj.static){
			adornment += JavaElementImageDescriptor.STATIC
		}
		if(obj.abstract){
			adornment += JavaElementImageDescriptor.ABSTRACT
		}
	}
	
	def private dispatch getAdornments(Classifier obj){
		var adornment = 0
		if(obj.abstract){
			adornment += JavaElementImageDescriptor.ABSTRACT
		}
	}
	
	def private dispatch getAdornments(EnumConstant obj){
		var adornment = 0
		adornment += JavaElementImageDescriptor.FINAL
		adornment += JavaElementImageDescriptor.STATIC
	}
}
