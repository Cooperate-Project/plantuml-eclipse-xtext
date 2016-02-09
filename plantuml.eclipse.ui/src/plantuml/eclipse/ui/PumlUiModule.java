/*
 * generated by Xtext
 */
package plantuml.eclipse.ui;

import org.eclipse.ui.plugin.AbstractUIPlugin;
import org.eclipse.xtext.ui.editor.syntaxcoloring.IHighlightingConfiguration;

import plantuml.eclipse.ui.highlighting.PumlHighlightingConfiguration;

/**
 * Use this class to register components to be used within the IDE.
 */
public class PumlUiModule extends plantuml.eclipse.ui.AbstractPumlUiModule {
	public PumlUiModule(AbstractUIPlugin plugin) {
		super(plugin);
	}
	
	public Class<? extends IHighlightingConfiguration> 
    bindIHighlightingConfiguration() {
     return PumlHighlightingConfiguration.class;
	}
}
