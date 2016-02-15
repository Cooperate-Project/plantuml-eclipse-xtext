package plantuml.eclipse.formatting

import org.eclipse.xtext.formatting.impl.AbstractDeclarativeFormatter
import org.eclipse.xtext.formatting.impl.FormattingConfig
import com.google.inject.Inject
import plantuml.eclipse.services.PumlGrammarAccess


/**
 * This class contains custom formatting description.
 */
class PumlFormatter extends AbstractDeclarativeFormatter {

	@Inject extension PumlGrammarAccess g
	
	override protected void configureFormatting(FormattingConfig c) {
		/**
		for (pair : g.findKeywordPairs("{", "}")) {
		    c.setIndentation(pair.getFirst(), pair.getSecond()); // indent between ( )
		    c.setLinewrap().after(pair.getFirst()); // linewrap after (
		    c.setLinewrap().before(pair.getSecond()); // linewrap before )
		    c.setNoSpace().after(pair.getSecond()); // no space after )
		} */
	}
}
