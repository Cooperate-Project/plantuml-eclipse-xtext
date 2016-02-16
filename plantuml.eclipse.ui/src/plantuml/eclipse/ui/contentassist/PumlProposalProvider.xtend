package plantuml.eclipse.ui.contentassist

import org.eclipse.emf.ecore.EObject
import org.eclipse.xtext.ui.editor.contentassist.ContentAssistContext
import org.eclipse.xtext.Assignment
import org.eclipse.xtext.ui.editor.contentassist.ICompletionProposalAcceptor
import plantuml.eclipse.puml.Class
import plantuml.eclipse.puml.Association
import com.google.inject.Inject
import plantuml.eclipse.services.PumlGrammarAccess

/**
 * Content Assist.
 */
class PumlProposalProvider extends AbstractPumlProposalProvider {


	@Inject
	private PumlGrammarAccess ga;
	
	override createProposals(ContentAssistContext context, ICompletionProposalAcceptor acceptor) {
		// suppress content assist in multi-line comments
		if (context.getCurrentNode().getGrammarElement()==ga.getML_COMMENTRule())
			return;
		super.createProposals(context, acceptor);
	}

	/**
	 * Help to select a color.
	 */
	override completeColorTag_Color(EObject element, Assignment assignment, ContentAssistContext context, ICompletionProposalAcceptor acceptor) {		
		acceptor.accept(createCompletionProposal("42", "WHAT IS THE ANSWER?", null, context));
	}
	
	override completeAssociation_AssociationType(EObject element, Assignment assignment, ContentAssistContext context, ICompletionProposalAcceptor acceptor) {
		
	}
}
