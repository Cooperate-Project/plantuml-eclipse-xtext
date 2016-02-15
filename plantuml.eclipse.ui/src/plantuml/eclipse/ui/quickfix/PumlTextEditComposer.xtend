package plantuml.eclipse.ui.quickfix

import org.eclipse.xtext.ui.editor.model.edit.DefaultTextEditComposer
import org.eclipse.xtext.resource.SaveOptions

public class PumlTextEditComposer extends DefaultTextEditComposer {

    override SaveOptions getSaveOptions() {
        return SaveOptions.newBuilder().format().getOptions();
    }

}