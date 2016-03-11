package plantuml.eclipse.converter

import org.eclipse.xtext.conversion.impl.AbstractDeclarativeValueConverterService
import org.eclipse.xtext.conversion.IValueConverter
import org.eclipse.xtext.conversion.ValueConverter
import org.eclipse.xtext.nodemodel.INode
import org.eclipse.xtext.conversion.ValueConverterException
import plantuml.eclipse.puml.AssociationType
import org.eclipse.xtext.conversion.impl.AbstractNullSafeConverter

class PumlValueConverter extends AbstractDeclarativeValueConverterService {
	
	StringBuffer stringBuffer;
	String buffer;
	
	/**
	 * Checks for correct association arrows.
	 */
	@ValueConverter(rule="ARROWTYPE")
	def IValueConverter<AssociationType> ARROW() {
		return new AbstractNullSafeConverter<AssociationType>() {
			override protected internalToString(AssociationType value) {
				return value + "?";
			}
			override protected internalToValue(String string, INode node) throws ValueConverterException {
				if (string == null && checkArrowEnd(string) == null) {
					throw new ValueConverterException("null value", node, null);
				}
				return checkArrowEnd(string);
				
			}
			
		};
	}
	
	/**
	 * Allows to create classes with strings containing empty spaces as names.
	 */
	@ValueConverter(rule="STRING")
	def IValueConverter<String> STRING() {
		return new IValueConverter<String>() {
			override toString(String value) throws ValueConverterException {
				if (value.matches("^?[a-zA-Z_][a-zA-Z_0-9]*")) {
					return value;
				}
				return String.format("\"%s\"", value);
			}
			override toValue(String value, INode node) throws ValueConverterException {
				if (value == null) {
					throw new ValueConverterException("null value", node, null);
				}
				if (value.matches("\\\".*\\\"")) {
					return value.subSequence(1, value.length - 1).toString;
				}
				return value;
			}
		}
	}
	
	// -------------------------------------------------------------------------------------------
	// ---------------------------------------- Helper -------------------------------------------
	// -------------------------------------------------------------------------------------------
	
	/**
	 * Checks for color tag in an arrow. Returns color (as hex or word), else null.
	 */
	def String checkForColorTag(String string){
		if(!string.contains("[")){
			return null;
		}
		// contains color tag
		
		buffer = string.split("\\[").get(0);
		if(buffer.contains("]")){
			return buffer = buffer.split("\\]").get(0);
		}
		// Parsing Error
		return "#";
	}
	
	def String removeColorTag(String string){
		stringBuffer = new StringBuffer();
		if(!string.contains("[")){
			return string;
		}
		// contains color tag
		stringBuffer.append(string.split("\\[").get(0));
		if(string.contains("]")){
			return stringBuffer.append(string.split("\\]").get(1)).toString();
		}
		// Parsing Error
		return "#";
	}
	
	def AssociationType checkArrowEnd(String string){
		switch (removeColorTag(string)){
			case "<|--": 	return AssociationType.INHERITANCELEFT
			case "<|..": 	return AssociationType.INHERITANCELEFT
			case "--|>": 	return AssociationType.INHERITANCERIGHT
			case "..|>": 	return AssociationType.INHERITANCERIGHT
			case "--":		return AssociationType.BIDIRECTIONAL
			case "..":		return AssociationType.BIDIRECTIONAL
			case "<--": 	return AssociationType.DIRECTIONALLEFT
			case "<..": 	return AssociationType.DIRECTIONALLEFT
			case "-->": 	return AssociationType.DIRECTIONALRIGHT
			case "..>": 	return AssociationType.DIRECTIONALRIGHT
			case "o--": 	return AssociationType.AGGREGATIONLEFT
			case "o..": 	return AssociationType.AGGREGATIONLEFT
			case "--o": 	return AssociationType.AGGREGATIONRIGHT
			case "..o": 	return AssociationType.AGGREGATIONRIGHT
			case "*--": 	return AssociationType.COMPOSITIONLEFT
			case "*..": 	return AssociationType.COMPOSITIONLEFT
			case "--*": 	return AssociationType.COMPOSITIONRIGHT
			case "..*": 	return AssociationType.COMPOSITIONRIGHT
		}
		return null;
	}
	
	
	
	
	
	
	
	
	
	
	
	
	
}