package plantuml.eclipse.generator.uml.generator;

import java.io.IOException;
import java.util.Collections;
import java.util.List;

import org.eclipse.core.runtime.IStatus;
import org.eclipse.emf.common.util.BasicDiagnostic;
import org.eclipse.emf.common.util.Diagnostic;
import org.eclipse.emf.common.util.URI;
import org.eclipse.emf.ecore.EObject;
import org.eclipse.emf.ecore.resource.Resource;
import org.eclipse.emf.ecore.resource.ResourceSet;
import org.eclipse.m2m.qvt.oml.BasicModelExtent;
import org.eclipse.m2m.qvt.oml.ExecutionContextImpl;
import org.eclipse.m2m.qvt.oml.ExecutionDiagnostic;
import org.eclipse.m2m.qvt.oml.ModelExtent;
import org.eclipse.m2m.qvt.oml.TransformationExecutor;
import org.eclipse.uml2.uml.resource.UMLResource;

import plantuml.eclipse.generator.uml.Activator;

public class PumlToUMLTransformator {

	private static final URI TRANSFORMATION_URI = URI
			.createPlatformPluginURI(String.format("/%s/transforms/%s", Activator.PLUGIN_ID, "PUML_to_UML.qvto"), true);

	public PumlToUMLTransformator() {

	}

	public List<EObject> transform(List<EObject> sourceContents) throws IOException {
		ModelExtent source = new BasicModelExtent(sourceContents);
		ModelExtent primitives = new BasicModelExtent(loadUMLPrimitives(sourceContents.get(0).eResource().getResourceSet()));
		ModelExtent target = new BasicModelExtent();
		IStatus transformationStatus = transform(source, primitives, target);
		if (transformationStatus.getSeverity() != Diagnostic.OK) {
			return Collections.emptyList();
		}
		return target.getContents();
	}

	public IStatus transform(ModelExtent source, ModelExtent primitives, ModelExtent target) {
		ExecutionContextImpl context = new ExecutionContextImpl();
		context.setConfigProperty("keepModeling", true);
		TransformationExecutor executor = new TransformationExecutor(TRANSFORMATION_URI);
		ExecutionDiagnostic result = executor.execute(context, new ModelExtent[] { source, target, primitives });
		return BasicDiagnostic.toIStatus(result);
	}
	
	private static List<EObject> loadUMLPrimitives(ResourceSet rs) throws IOException {
		URI primitivesURI = URI.createURI(UMLResource.ECORE_PRIMITIVE_TYPES_LIBRARY_URI);
		Resource r = rs.getResource(primitivesURI, true);
		return r.getContents();
	}

}
