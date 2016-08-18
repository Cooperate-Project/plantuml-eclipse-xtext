package plantuml.eclipse.generator.uml.generator;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.util.Collections;
import java.util.List;

import org.eclipse.emf.common.util.URI;
import org.eclipse.emf.ecore.EObject;
import org.eclipse.emf.ecore.resource.Resource;
import org.eclipse.xtext.generator.IFileSystemAccess;
import org.eclipse.xtext.generator.IGenerator;

public class UMLGenerator implements IGenerator {

	private static final PumlToUMLTransformator transformator = new PumlToUMLTransformator();
	
	@Override
	public void doGenerate(Resource input, IFileSystemAccess fsa) {
		String fileBaseName = input.getURI().trimFileExtension().lastSegment();
		String outputFileName = fileBaseName + ".uml";
		String umlContent;
		try {
			umlContent = getUMLContent(input, outputFileName);
			fsa.generateFile(outputFileName, umlContent);
		} catch (IOException e) {
			return;
		}
	}

	private String getUMLContent(Resource input, String outputFileName) throws IOException {
		List<EObject> resultModelElements = transformator.transform(input.getContents());
		URI targetURI = input.getURI().trimFragment().trimQuery().trimSegments(1).appendSegment(outputFileName);
		Resource targetResource = input.getResourceSet().createResource(targetURI);
		try {
			targetResource.getContents().addAll(resultModelElements);
			ByteArrayOutputStream baos = new ByteArrayOutputStream();
			try {
				targetResource.save(baos, Collections.emptyMap());
				return baos.toString();
			} finally {
				baos.close();
			}	
		} finally {
			input.getResourceSet().getResources().remove(targetResource);
		}
	}

}
