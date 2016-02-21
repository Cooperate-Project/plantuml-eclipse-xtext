package plantuml.eclipse.converter

import org.eclipse.xtext.conversion.impl.AbstractDeclarativeValueConverterService
import org.eclipse.xtext.conversion.IValueConverter
import org.eclipse.xtext.conversion.ValueConverter
import org.eclipse.xtext.nodemodel.INode
import org.eclipse.xtext.conversion.ValueConverterException

class PumlValueConverter extends AbstractDeclarativeValueConverterService {
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
}