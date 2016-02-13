package plantuml.eclipse.ui.highlighting;

import org.eclipse.swt.SWT;
import org.eclipse.swt.graphics.RGB;
import org.eclipse.xtext.ui.editor.syntaxcoloring.IHighlightingConfiguration;
import org.eclipse.xtext.ui.editor.syntaxcoloring.IHighlightingConfigurationAcceptor;
import org.eclipse.xtext.ui.editor.utils.TextStyle;

/**
 * Defines text styles and maps them to IDs so the SemanticHighlightingCalcuator can use them to color regions of code.
 *
 */
public class PumlHighlightingConfiguration implements IHighlightingConfiguration{

	public static final String KEYWORD_ID = "keyword";
	public static final String DATATYPE_ID = "datatype";
	public static final String CLASS_ID = "class";
	
	TextStyle textStyle = new TextStyle();
	
	override configure(IHighlightingConfigurationAcceptor acceptor) {
		acceptor.acceptDefaultHighlighting(KEYWORD_ID, "Keyword", keywordTextStyle());
		acceptor.acceptDefaultHighlighting(DATATYPE_ID, "DataType", dataTypeTextStyle());
		acceptor.acceptDefaultHighlighting(CLASS_ID, "Class", classTextStyle());
	}

	def TextStyle keywordTextStyle(){
		textStyle = new TextStyle();
		textStyle.setColor(new RGB(127,0,85));
		textStyle.setStyle(SWT.BOLD);
		return textStyle;
	}
	
	def TextStyle dataTypeTextStyle(){
		textStyle = new TextStyle();
		textStyle.setStyle(SWT.ITALIC);
		return textStyle;
	}
	
	def TextStyle classTextStyle(){
		textStyle = new TextStyle();
		textStyle.setColor(new RGB(245,147,0));
		textStyle.setStyle(SWT.BOLD);
		return textStyle;
	}
}
