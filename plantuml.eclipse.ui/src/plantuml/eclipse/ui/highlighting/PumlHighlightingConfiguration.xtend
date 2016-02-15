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

	public static final String KEYWORD_ID = "keyword"
	public static final String COMMENT_ID = "comment"
	public static final String TYPE_ID = "type"
	public static final String CLASS_ID = "class"
	public static final String ATTRIBUTE_ID = "attribute"
	public static final String METHOD_ID = "method"
	public static final String CONSTANT_ID = "constant"
	
	TextStyle textStyle = new TextStyle();
	
	override configure(IHighlightingConfigurationAcceptor acceptor) {
		acceptor.acceptDefaultHighlighting(KEYWORD_ID, "Keyword", keywordTextStyle())
		acceptor.acceptDefaultHighlighting(COMMENT_ID, "Comment", commentTextStyle())
		acceptor.acceptDefaultHighlighting(TYPE_ID, "Type", typeTextStyle())
		acceptor.acceptDefaultHighlighting(CLASS_ID, "Class", classTextStyle())
		acceptor.acceptDefaultHighlighting(ATTRIBUTE_ID, "Attribute", attributeTextStyle())
		acceptor.acceptDefaultHighlighting(METHOD_ID, "Method", methodTextStyle())
		acceptor.acceptDefaultHighlighting(CONSTANT_ID, "Constant", constantTextStyle())
	}
	
	def TextStyle keywordTextStyle(){
		textStyle = new TextStyle()
		textStyle.setColor(new RGB(0,0,255)) // Default 127,0,85
		textStyle.setStyle(SWT.BOLD)
		return textStyle
	}
	
	def TextStyle commentTextStyle() {
		textStyle = new TextStyle()
		textStyle.setColor(new RGB(0,128,0))
		return textStyle
	}

	def TextStyle typeTextStyle(){
		textStyle = new TextStyle()
		textStyle.setColor(new RGB(0,0,0))
		textStyle.setStyle(SWT.ITALIC)
		return textStyle
	}
	
	def TextStyle classTextStyle(){
		textStyle = new TextStyle()
		textStyle.setColor(new RGB(0,0,128))
		return textStyle
	}
	
	def TextStyle attributeTextStyle(){
		textStyle = new TextStyle()
		textStyle.setColor(new RGB(128,0,128))
		return textStyle
	}
	
	def TextStyle methodTextStyle(){
		textStyle = new TextStyle()
		textStyle.setColor(new RGB(255,0,255))
		return textStyle
	}
	
	def TextStyle constantTextStyle(){
		textStyle = new TextStyle()
		textStyle.setColor(new RGB(128,0,64))
		textStyle.setStyle(SWT.ITALIC)
		return textStyle
	}
}