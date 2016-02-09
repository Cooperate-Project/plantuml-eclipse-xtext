package plantuml.eclipse.ui.highlighting;

import org.eclipse.swt.SWT;
import org.eclipse.swt.graphics.RGB;
import org.eclipse.xtext.ui.editor.syntaxcoloring.IHighlightingConfiguration;
import org.eclipse.xtext.ui.editor.syntaxcoloring.IHighlightingConfigurationAcceptor;
import org.eclipse.xtext.ui.editor.utils.TextStyle;

public class PumlHighlightingConfiguration implements IHighlightingConfiguration{

	public static final String KEYWORD_ID = "keyword";
	public static final String COMMENT_ID = "comment";
	
	@Override
	public void configure(IHighlightingConfigurationAcceptor acceptor) {
		acceptor.acceptDefaultHighlighting(KEYWORD_ID, "Keyword", keywordTextStyle());
	}

	public TextStyle keywordTextStyle(){
		TextStyle textStyle = new TextStyle();
		textStyle.setColor(new RGB(127,0,85));
		textStyle.setStyle(SWT.ITALIC);
		return textStyle;
	}
}
