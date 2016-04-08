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
import plantuml.eclipse.puml.Enum
import org.eclipse.xtext.ui.editor.contentassist.ConfigurableCompletionProposal
import org.eclipse.xtext.ui.editor.contentassist.ReplacementTextApplier
import org.eclipse.swt.widgets.Display
import org.eclipse.swt.widgets.ColorDialog
import org.eclipse.swt.graphics.RGB

/**
 * This class provides content assist in our editor. It offeres suggestions for code completion.
 */
class PumlProposalProvider extends AbstractPumlProposalProvider {

	// ------------------------ CONFIGURATION PARAMETERS ---------------------------------
	
	/** Filtered proposals that does not provide any useful help */
	static final String[] FILTERED_KEYWORDS = #["{","}","--","==","__","[","#","+","~","-", ".", "-[", "o", "*", "<", "<|" , "UNDEFINED"]

	/** Visibility tuples with (word,sign) */
	static val VISIBILITIES = #["public"->"+","private"->"-","protected"->"#","default"->"~"]
	/** Standard placeholder descriptions for method or attribute names added through proposals */
	static val PLACEHOLDER_DESC = "enterName"
	/** Standard placeholder type for method or attribute types added through proposals*/
	static val PLACEHOLDER_TYPE = "enterType"
	
	/** Standard colors with hex codes because default colors are awful. */
	static final val COLORS = #[
		"black"->"000000",
		"blue"->"49CAF5",
		"green"->"73E36F",
		"purple"->"FC68FA",
		"red"->"FC6868",
		"yellow"->"FCF768"
	]

	// -----------------------------------------------------------------------------------

	@Inject
    private IImageHelper imageHelper

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
		if(element instanceof Association){
			val asDescs = #[
				"gets implemented by" -> ("implm_co.png" -> "<|.."),
				"gets extended by" -> ("over_co.png" -> "<|--"),
				"gets aggregated by" -> ("aggr_co.png" -> "o--"),
				"gets composited by" -> ("comp_co.png" -> "*--"),
				"gets referenced by" -> ("ref_co.png" -> "<--"),
				"implements" -> ("implm_co.png" -> "..|>"),
				"extends" -> ("over_co.png" -> "--|>"),
				"aggregates" -> ("aggr_co.png" -> "--o"),
				"composites" -> ("comp_co.png" -> "--*"),
				"references" -> ("ref_co.png" -> "-->"),
				"two-way reference" -> ("ref_co.png" -> "--")
			]
			// Add proposals for association arrows
			for(asDesc : asDescs){
				acceptor.accept(createCompletionProposal(asDesc.value.value, asDesc.key , imageHelper.getImage(asDesc.value.key), context));
			}
		}	
	}
	
	/**
	 * Content assist for creating class contents like attributes, methods or dividers.
	 */
	override completeClass_ClassContents(EObject element, Assignment assignment, ContentAssistContext context, ICompletionProposalAcceptor acceptor) {
		if(element instanceof Class){
			for(var i = 0; i < VISIBILITIES.length ; i++){
				// Add method proposal
				acceptor.accept(createCompletionProposal(
					VISIBILITIES.get(i).value + plantuml.eclipse.ui.contentassist.PumlProposalProvider.PLACEHOLDER_DESC + "() : " + plantuml.eclipse.ui.contentassist.PumlProposalProvider.PLACEHOLDER_TYPE,
					"Method (" + VISIBILITIES.get(i).key + ")",
					imageHelper.getImage("visibilities/meth_" + VISIBILITIES.get(i).key + "_obj.png"),
					context
				));
				// Add attribute proposal
				acceptor.accept(createCompletionProposal(
					VISIBILITIES.get(i).value + plantuml.eclipse.ui.contentassist.PumlProposalProvider.PLACEHOLDER_DESC + " : " + plantuml.eclipse.ui.contentassist.PumlProposalProvider.PLACEHOLDER_TYPE,
					"Attribute (" + VISIBILITIES.get(i).key + ")",
					imageHelper.getImage("visibilities/field_" + VISIBILITIES.get(i).key + "_obj.png"),
					context
				));
			}
			// Add dividers
			acceptor.accept(createCompletionProposal("-- text text text -- ", "Divider with text" , imageHelper.getImage("divider_text.png"), context));
			acceptor.accept(createCompletionProposal("--", "Divider without text" , imageHelper.getImage("divider.png"), context));
		}		
	}
	
	/**
	 * Content assist for creating colors for classes.
	 */
	override completeClass_Color(EObject element, Assignment assignment, ContentAssistContext context, ICompletionProposalAcceptor acceptor) {
		if(element instanceof Class){
			addStandardColorsToAcceptor(element, assignment, context, acceptor)
			acceptor.accept(createColorProposal(context))
		}	
	}
	
	/**
	 * Content assist for creating colors for enums.
	 */
	 override completeEnum_Color(EObject element, Assignment assignment, ContentAssistContext context, ICompletionProposalAcceptor acceptor) {
	 	if(element instanceof Enum){
	 		addStandardColorsToAcceptor(element, assignment, context, acceptor)
	 		acceptor.accept(createColorProposal(context))
	 	}
	 }
	 
	// -------------------------------------------------------------------------------------------
	// -------------------------------------- Helpers --------------------------------------------
	// -------------------------------------------------------------------------------------------

	/**
	 * Helper for creating proposals with defined colors.
	 */
	private def addStandardColorsToAcceptor(EObject element, Assignment assignment, ContentAssistContext context, ICompletionProposalAcceptor acceptor){ 
		// Create color selection by entering hexcode
		var colorPick = imageHelper.getImage("colors/color_pick.png")
		acceptor.accept(createCompletionProposal("#FFFFFF ", "Color... Enter own hexcode" , colorPick, context))
		// Create color by selecting from standard colors
		for(color : COLORS){
			acceptor.accept(createCompletionProposal(" #" + color.value, "Color: " + color.key , imageHelper.getImage("colors/color_" + color.key + ".png"), context))
		}
	}
	
	/**
	 * Helper method. Returns a ConfigurableCompletionProposal to pick a color from a palette.
	 * @author Sebastian Zernekow
	 * @see <a href="http://zarnekow.blogspot.de/2011/06/customizing-content-assist-with-xtext.html">Customizing Content Assist with Xtext</a> in Sebastian's blog.
	 */
	private def ConfigurableCompletionProposal createColorProposal(ContentAssistContext context){
		var colorPalette = imageHelper.getImage("colors/color_palette.jpg")
		val pickColor = createCompletionProposal("#FFFFFF","Color... Pick from palette", colorPalette, context) as ConfigurableCompletionProposal
		if (pickColor != null) {
			pickColor.setTextApplier(
				new ReplacementTextApplier() {
					override getActualReplacementString(ConfigurableCompletionProposal proposal) {
						val display = context.getViewer().getTextWidget().getDisplay()
						val colorDialog = new ColorDialog(display.getActiveShell());
						val newColor = colorDialog.open();
						val hexColor = String.format(" #%02x%02x%02x", newColor.red, newColor.green, newColor.blue);
						return hexColor.toUpperCase()
					}
				}
			)
			return pickColor
		}
	}	
}
