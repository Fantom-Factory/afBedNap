using afIoc::Inject
using afPillow::Page
using afEfanXtra::InitRender
using afBedSheet::Text
using afBedSheet::ValueEncoder

** (Pillow page) The main application page.
const mixin IndexPage : Page {
	@Inject abstract VisitorBookService	visitorBook
	@Inject abstract SampleData sampleData

	abstract Visitor sample
	
	@InitRender
	Void initRender() {
		sample = sampleData.createSampleVisitor
	}
}

** Returns the given source file as plain text.
** Note this is not a Pillow Page but a Route Request handler.
const class SourceCodePage {
	// Ensure a plain text Mime Type, as most browsers don't know what 'text/fandoc' is!
	Obj service(Uri file) {
		return Text.fromPlain(file.toFile.readAllStr)
	}
}

** (Pillow page) Displays a `Visitor` entity in full.
const mixin VisitorPage : Page {
	abstract Visitor visitor
	
	@InitRender
	Void initRender(Visitor visitor) {
		this.visitor = visitor
	}
}

** Converts `Visitor` objects to and from a 'Str'.
** By registering this ValueEncoder (in `AppModule`) methods, such as 
** '@InitRender' above, can take Visitor entities as InitRender arguments.
const class VisitorValueEncoder : ValueEncoder {
	@Inject private const VisitorBookService visitorBook
	
	new make(|This|in) { in(this) }
	
	override Str toClient(Obj value) {
		visitor := (Visitor) value
		return visitor.id.toStr
	}

	override Obj toValue(Str clientValue) {
		return visitorBook.get(clientValue.toInt)
	}	
}
