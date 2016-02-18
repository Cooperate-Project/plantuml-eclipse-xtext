package plantuml.eclipse.ui.contentassist

import org.eclipse.emf.ecore.EObject
import org.eclipse.xtext.ui.editor.contentassist.ContentAssistContext
import org.eclipse.xtext.Assignment
import org.eclipse.xtext.ui.editor.contentassist.ICompletionProposalAcceptor
import com.google.inject.Inject
import plantuml.eclipse.services.PumlGrammarAccess
import org.eclipse.xtext.Keyword
import org.eclipse.xtext.ui.IImageHelper

import plantuml.eclipse.puml.Association
import plantuml.eclipse.puml.Class

/**
 * This class provides content assist in our editor. It offeres suggestions for code completion.
 */
class PumlProposalProvider extends AbstractPumlProposalProvider {


	@Inject
    private IImageHelper imageHelper

	/** We don't want to display those proposals in the content assist window, because they are not helpful **/
	static final String[] FILTERED_KEYWORDS = #["{","}","--","==","__","#","+","~","-", ".", "-[", "o", "*", "<", "<|" , "UNDEFINED"]

	@Inject
	private PumlGrammarAccess ga;
	
	/**
	 * Removes the defined filter for proposals we do not want to have.
	 */
	override completeKeyword(Keyword keyword, ContentAssistContext contentAssistContext, ICompletionProposalAcceptor acceptor) {
        if (FILTERED_KEYWORDS.contains(keyword.getValue())) {
            return;
        }
        super.completeKeyword(keyword, contentAssistContext, acceptor);
    }
	
	/**
	 * Supresses content assist in special cases.
	 */
	override createProposals(ContentAssistContext context, ICompletionProposalAcceptor acceptor) {
		if (context.getCurrentNode().getGrammarElement()==ga.getML_COMMENTRule())
			return;
		super.createProposals(context, acceptor);
	}

	/**
	 * Content assist for creating associations. They will be shown after a cross reference to a class was typed in.
	 */
	override completeAssociation_AssociationArrow(EObject element, Assignment assignment, ContentAssistContext context, ICompletionProposalAcceptor acceptor) {
		// Prefetch images
		val linkIcon = imageHelper.getImage("link.png")
		val implIcon = imageHelper.getImage("implm_co.png")
		val aggrIcon = imageHelper.getImage("aggr_co.png")
		val compIcon = imageHelper.getImage("comp_co.png")
		val extIcon = imageHelper.getImage("over_co.png")
		if(element instanceof Association){
			val association = element as Association
			if(association.classLeft.interface){
				acceptor.accept(createCompletionProposal("<|.. ", "gets implemented by" , implIcon, context));
			}else{
				acceptor.accept(createCompletionProposal("<|-- ", "gets extended by" , extIcon, context));
			}
			acceptor.accept(createCompletionProposal("o-- ", "gets aggregated by" , aggrIcon, context));
			acceptor.accept(createCompletionProposal("*-- ", "gets composited by" , compIcon, context));
			acceptor.accept(createCompletionProposal("--o ", "aggregates" , aggrIcon, context));
			acceptor.accept(createCompletionProposal("--* ", "composites" , compIcon, context));
			acceptor.accept(createCompletionProposal("--|> ", "extends" , extIcon, context));
			acceptor.accept(createCompletionProposal("..|> ", "implements" , implIcon, context));
			acceptor.accept(createCompletionProposal("--> ", "links to" , linkIcon, context));
			acceptor.accept(createCompletionProposal("<-- ", "gets linked by" , linkIcon, context));
		}		
	}
	
	/**
	 * Content assist for creating class contents like attributes, methods or dividers.
	 */
	override completeClass_ClassContents(EObject element, Assignment assignment, ContentAssistContext context, ICompletionProposalAcceptor acceptor) {
		// Prefetch images
		var attributes = #[
			imageHelper.getImage("field_public_obj.png"),
			imageHelper.getImage("field_private_obj.png"),
			imageHelper.getImage("field_protected_obj.png"),
			imageHelper.getImage("field_default_obj.png")
		]
		var methods = #[
			imageHelper.getImage("methpub_obj.png"),
			imageHelper.getImage("methpri_obj.png"),
			imageHelper.getImage("methpro_obj.png"),
			imageHelper.getImage("methdef_obj.png")
		]
		if(element instanceof Class){
			acceptor.accept(createCompletionProposal("+name() : type ", "Method (public)" , methods.get(0), context));
			acceptor.accept(createCompletionProposal("-name() : type ", "Method (private)" , methods.get(1), context));
			acceptor.accept(createCompletionProposal("~name() : type ", "Method (protected)" , methods.get(2), context));
			acceptor.accept(createCompletionProposal("#name() : type ", "Method (default)" , methods.get(3), context));
			acceptor.accept(createCompletionProposal("+name : type ", "Attribute (public)" , attributes.get(0), context));
			acceptor.accept(createCompletionProposal("-name : type ", "Attribute (private)" , attributes.get(1), context));
			acceptor.accept(createCompletionProposal("~name : type ", "Attribute (protected)" , attributes.get(2), context));
			acceptor.accept(createCompletionProposal("#name : type ", "Attribute (default)" , attributes.get(3), context));
			acceptor.accept(createCompletionProposal("-- text text text -- ", "Divider with text" , null, context));
			acceptor.accept(createCompletionProposal("--", "Divider without text" , null, context));
		}		
	}
	
	/**
	 * Content assist for creating colors for classes.
	 */
	override completeClass_Color(EObject element, Assignment assignment, ContentAssistContext context, ICompletionProposalAcceptor acceptor) {
		// Prefetch images
		var colorPalette = imageHelper.getImage("color_palette.jpg")
		var colors = #[
			imageHelper.getImage("colors/color_black.png"),
			imageHelper.getImage("colors/color_blue.png"),
			imageHelper.getImage("colors/color_green.png"),
			imageHelper.getImage("colors/color_purple.png"),
			imageHelper.getImage("colors/color_red.png"),
			imageHelper.getImage("colors/color_yellow.png")
		]
		if(element instanceof Class){
			acceptor.accept(createCompletionProposal("#FFFFFF", "Color: Enter own hexcode" , colorPalette, context))
			acceptor.accept(createCompletionProposal("#Black", "Color: Black" , colors.get(0), context))
			acceptor.accept(createCompletionProposal("#Blue", "Color: Blue" , colors.get(1), context))
			acceptor.accept(createCompletionProposal("#Green", "Color: Green" , colors.get(2), context))
			acceptor.accept(createCompletionProposal("#Purple", "Color: Purple" , colors.get(3), context))
			acceptor.accept(createCompletionProposal("#Red", "Color: Red" , colors.get(4), context))
			acceptor.accept(createCompletionProposal("#Yellow", "Color: Yellow" , colors.get(5), context))
		}		
	}
}
