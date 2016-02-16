package plantuml.eclipse.ui.contentassist

import org.eclipse.emf.ecore.EObject
import org.eclipse.xtext.ui.editor.contentassist.ContentAssistContext
import org.eclipse.xtext.Assignment
import org.eclipse.xtext.ui.editor.contentassist.ICompletionProposalAcceptor
import plantuml.eclipse.puml.Association
import com.google.inject.Inject
import plantuml.eclipse.services.PumlGrammarAccess
import org.eclipse.xtext.Keyword
import org.eclipse.xtext.ui.IImageHelper

/**
 * Content Assist.
 */
class PumlProposalProvider extends AbstractPumlProposalProvider {

	@Inject
    private IImageHelper imageHelper

	static final String[] FILTERED_KEYWORDS = #["-", ".", "-[", "o", "*", "<", "<|" , "UNDEFINED"]

	@Inject
	private PumlGrammarAccess ga;
	
	override completeKeyword(Keyword keyword, ContentAssistContext contentAssistContext, ICompletionProposalAcceptor acceptor) {
		// Removes content assists suggestions when creating an association
		// They are not useful and we are creating our own
        if (FILTERED_KEYWORDS.contains(keyword.getValue())) {
            return;
        }
        super.completeKeyword(keyword, contentAssistContext, acceptor);
    }
	
	override createProposals(ContentAssistContext context, ICompletionProposalAcceptor acceptor) {
		// suppress content assist in multi-line comments
		if (context.getCurrentNode().getGrammarElement()==ga.getML_COMMENTRule())
			return;
		super.createProposals(context, acceptor);
	}

	/**
	 * Content assist for creating associations.
	 */
	override completeAssociation_AssociationArrow(EObject element, Assignment assignment, ContentAssistContext context, ICompletionProposalAcceptor acceptor) {
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
	
}
