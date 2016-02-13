/*
* generated by Xtext
*/
package plantuml.eclipse.ui.labeling

import com.google.inject.Inject
import plantuml.eclipse.puml.ClassUml
import plantuml.eclipse.puml.Class
import plantuml.eclipse.puml.Attribute
import plantuml.eclipse.puml.Method
import org.eclipse.xtext.ui.IImageHelper
import plantuml.eclipse.puml.Visibility
import plantuml.eclipse.puml.Classifier
import plantuml.eclipse.puml.Association
import plantuml.eclipse.puml.Bidirectional
import plantuml.eclipse.puml.UnidirectionalLeft
import plantuml.eclipse.puml.UnidirectionalRight
import plantuml.eclipse.puml.AggregationLeft
import plantuml.eclipse.puml.AggregationRight
import plantuml.eclipse.puml.CompositionLeft
import plantuml.eclipse.puml.CompositionRight
import plantuml.eclipse.puml.InheritanceLeft
import plantuml.eclipse.puml.InheritanceRight

/**
 * Provides labels for a EObjects.
 * 
 * see http://www.eclipse.org/Xtext/documentation.html#labelProvider
 */
class PumlLabelProvider extends org.eclipse.xtext.ui.label.DefaultEObjectLabelProvider {

	@Inject
    private IImageHelper imageHelper;
    private StringBuffer label;
    
    // association representations in outline
    private static final String BIDIRECTIONAL = "--"
    private static final String UNIDIRECTIONAL = "-->"
    private static final String AGGREGATION = "--o"
    private static final String COMPOSITION = "--*"
    private static final String INHERITANCE = "--|>"
    

	@Inject
	new(org.eclipse.emf.edit.ui.provider.AdapterFactoryLabelProvider delegate) {
		super(delegate);
	}
	
	// ==================================================================================
	// ========================== TEXTS FOR LABELS ======================================
	// ==================================================================================

	/*
	 * Returns the label text for the PlantUML-Class-Group
	 */
	def text(ClassUml classUml) {
		"Class Diagram";
	}
	
	/*
	 * Returns the label text for connections.
	 */
	 def text(Association association){
		label = new StringBuffer();
		label.append(association.classFrom.name + " ");
		// Which association do we have?
		if(association.associationType instanceof Bidirectional){
			label.append(BIDIRECTIONAL);
		}else if(association.associationType instanceof UnidirectionalLeft
			|| association.associationType instanceof UnidirectionalRight){
			label.append(UNIDIRECTIONAL);
		}else if(association.associationType instanceof AggregationLeft
			|| association.associationType instanceof AggregationRight){
			label.append(AGGREGATION);
		}else if(association.associationType instanceof CompositionLeft
			|| association.associationType instanceof CompositionRight){
			label.append(COMPOSITION);
		}else if(association.associationType instanceof InheritanceLeft
			|| association.associationType instanceof InheritanceRight){
			label.append(INHERITANCE);
		}
		label.append(" " + association.classTo.name);
		if(association.text.length != 0){
			label.append(" : ");
			for(String text : association.text){
				label.append(text);
			}
		}
		return label.toString();
	 }

	/*
	 * Returns the label text for classes.
	 */
	def text(Class someClass) {
		label = new StringBuffer();
		label.append(someClass.getName());
		if(someClass.classifier != null){
			label.append(" {abstract}");
		}
		return label.toString();
	}
		
	/*
	 * Returns the label text for attributes.
	 */
	def text(Attribute attribute){
		label = new StringBuffer();
		label.append(attribute.getName());
		if(attribute.type != null){
			label.append(" : " + attribute.type);
			if(attribute.array){
				label.append("[");
				if(attribute.length >= 0){
					label.append(attribute.length)
				}
				label.append("]");
			}
		}
		if(attribute.classifier != Classifier.UNSPECIFIED){
			if(attribute.classifier == Classifier.ABSTRACT){
				label.append(" {abstract}");
			}
			if(attribute.classifier == Classifier.STATIC){
				label.append(" {static}");
			}
		}
		return label.toString();
	}
	
	/*
	 * Returns the label text for methods.
	 */
	def text(Method method){
		label = new StringBuffer();
		label.append(method.getName());
		if(method.type != null){
			label.append(" : " + method.type);
			if(method.array){
				label.append("[");
				if(method.length >= 0){
					label.append(method.length)
				}
				label.append("]");
			}
		}
		if(method.classifier != Classifier.UNSPECIFIED){
			if(method.classifier == Classifier.ABSTRACT){
				label.append(" {abstract}");
			}
			if(method.classifier == Classifier.STATIC){
				label.append(" {static}");
			}
		}
		return label.toString();
	}
	
	// ==================================================================================
	// ======================= IMAGE ICONS FOR LABELS ===================================
	// ==================================================================================
	
	/*
	 * Returns the image for the PlantUML-Class-Group.
	 */
	def image(ClassUml classUml){
		imageHelper.getImage("java_model_obj.png");
	}
	
	/*
	 * Returns the images for attributes.
	 */
	def image(Attribute attribute){
		if(attribute.visibility == Visibility.PROTECTED){
			imageHelper.getImage("field_protected_obj.png");
		}else if(attribute.visibility == Visibility.PRIVATE){
			imageHelper.getImage("field_private_obj.png");
		}else if(attribute.visibility == Visibility.PUBLIC){
			imageHelper.getImage("field_public_obj.png");
		}else if(attribute.visibility == Visibility.DEFAULT){
			imageHelper.getImage("field_default_obj.png");
		}
	}
	
	/*
	 * Returns the images for methods.
	 */
	def image(Method method){
		if(method.visibility == Visibility.PROTECTED){
			imageHelper.getImage("methpro_obj.png");
		}else if(method.visibility == Visibility.PRIVATE){
			imageHelper.getImage("methpri_obj.png");
		}else if(method.visibility == Visibility.PUBLIC){
			imageHelper.getImage("methpub_obj.png");
		}else if(method.visibility == Visibility.DEFAULT){
			imageHelper.getImage("methdef_obj.png");
		}
	}
	
	/*
	 * Returns the images for classes.
	 */
	def image(Class someClass){
		imageHelper.getImage("class_obj.png");
	}

	
	
}
