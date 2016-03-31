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
	char type;
	
	/**
	 * Checks for correct association arrows.
	 */
	@ValueConverter(rule="ARROWTYPE")
	def IValueConverter<AssociationType> ARROW() {
		return new AbstractNullSafeConverter<AssociationType>() {
			override protected internalToString(AssociationType value) {
				return value.toString()
			}
			override protected internalToValue(String string, INode node) throws ValueConverterException {
				if (string == null) {
					throw new ValueConverterException("The assiciation arrow can't be empty", node, null)
				}
				var modifiedString = removeColorTag(string)
				if(modifiedString == null) {
					throw new ValueConverterException("Incorrect Color Tag! Reminder: Syntax is \'#[<Hexcode|Color>]\'.", node, null)
				}
				modifiedString = removeOrientationInformation(modifiedString)
				if(modifiedString == null) {
					throw new ValueConverterException("More than one orientation information or on the wrong position!", node, null)
				}
				modifiedString = fixLength(modifiedString)
				if(modifiedString == null){
					throw new ValueConverterException("You should not mix dashed and continuous linies.", node, null)
				}
				val result = checkArrowEnd(modifiedString)
				if(result == null){
					throw new ValueConverterException("\'" + modifiedString + "\' is not a correct association arrow.", node, null)
				}
				return result
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
				return String.format("\"%s\"", value)
			}
			override toValue(String value, INode node) throws ValueConverterException {
				if (value == null) {
					throw new ValueConverterException("null value", node, null)
				}
				if (value.matches("\\\".*\\\"")) {
					return value.subSequence(1, value.length - 1).toString;
				}
				return value
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
		return null;
	}
	
	/**
	 * Removes color tag from an association.
	 */
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
		return null;
	}
	
	/**
	 * Removes the orientation information of an arrow.
	 * Color information has to be removed before calling this method.
	 */
	 def String removeOrientationInformation(String string){
		val orientations = #["l","r","u","d"]
		buffer = null;
		for(String orientation : orientations){
			if(string.contains(orientation)){
				if (buffer == null){
					buffer = orientation
				}else{
					// More than one orientation information
					return null
				}
			}
		}
		// Nothing to do
		if(buffer == null){
			return string
		}
		return removeSubstring(string, buffer)
	 }
	 
	 /**
	  * Removes a substring from a string.
	  * Conditions: only one occurence of substring, first character can't be the end of the string.
	  * Returns null if conditions are violated.
	  */
	def String removeSubstring(String string, String sub){
		stringBuffer = new StringBuffer()
		if(string.contains(sub)){
			if(string.indexOf(sub) != string.length()-1){
				stringBuffer.append(string.replaceFirst(sub,""))
				if(!stringBuffer.toString().contains(sub)){
					return stringBuffer.toString()
				}
				return null
			}
			return null
		}
		return string
	}
	
	def String fixLength(String string){
		// Check for arrow style
		type = '-'
		if(string.contains(".")){
			if(string.contains("-")) {
				// We don't allow mixed styles
				// (does not make any sense, although it's not a syntax error in PlantUML)
				return null;
			}
			type = '.';
		}
		// search for first occurence of character
		val firstIndex = string.indexOf(type);
		// replace this character with special character
		buffer = string.substring(0,firstIndex) + "$" + string.substring(firstIndex+1);
		// delete all other occurences of character
		buffer = buffer.replace(type.toString(), "");
		// replace special character with style information
		buffer = buffer.replace("$",type);
		// insert single character for style information
		return buffer;
	}
	
	/**
	 * Checks for the type of an association and returns an Association Enum.
	 */
	def AssociationType checkArrowEnd(String string){
		switch (string){
			case "<|-": return AssociationType.INHERITANCELEFT
			case "<|.": return AssociationType.INHERITANCELEFT
			case "-|>": return AssociationType.INHERITANCERIGHT
			case ".|>": return AssociationType.INHERITANCERIGHT
			case "-":	return AssociationType.BIDIRECTIONAL
			case ".":	return AssociationType.BIDIRECTIONAL
			case "<-": 	return AssociationType.DIRECTIONALLEFT
			case "<.": 	return AssociationType.DIRECTIONALLEFT
			case "->": 	return AssociationType.DIRECTIONALRIGHT
			case ".>": 	return AssociationType.DIRECTIONALRIGHT
			case "o-": 	return AssociationType.AGGREGATIONLEFT
			case "o.": 	return AssociationType.AGGREGATIONLEFT
			case "-o": 	return AssociationType.AGGREGATIONRIGHT
			case ".o": 	return AssociationType.AGGREGATIONRIGHT
			case "*-": 	return AssociationType.COMPOSITIONLEFT
			case "*.": 	return AssociationType.COMPOSITIONLEFT
			case "-*": 	return AssociationType.COMPOSITIONRIGHT
			case ".*": 	return AssociationType.COMPOSITIONRIGHT
			
			// Sequence Diagram Addons
			case "o<-":  return AssociationType.DIRECTIONALLEFTO
			case "<-o":  return AssociationType.DIRECTIONALLEFTO
			case "o<-o": return AssociationType.DIRECTIONALLEFTO
			case "x<-":  return AssociationType.DIRECTIONALLEFTX
			case "<-x":  return AssociationType.DIRECTIONALLEFTX
			case "x<-x": return AssociationType.DIRECTIONALLEFTX
			case "->o":  return AssociationType.DIRECTIONALRIGHTO
			case "o->":  return AssociationType.DIRECTIONALRIGHTO
			case "o->o": return AssociationType.DIRECTIONALRIGHTO
			case "->x":  return AssociationType.DIRECTIONALRIGHTX
			case "x->":  return AssociationType.DIRECTIONALRIGHTX
			case "x->x": return AssociationType.DIRECTIONALRIGHTX
		}
		return null;
	}	
}