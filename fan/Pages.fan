using afIoc::Inject
using afPillow::Page
using afPillow::Pages
using afPillow::PageContext
using afPillow::PageEvent
using afPillow::PageMeta
using afEfanXtra::EfanComponent
using afEfanXtra::InitRender
using afBedSheet::Text
using afBedSheet::ValueEncoder
using afBedSheet::HttpRequest
using afBedSheet::Redirect

** (Pillow page) The index / documentation page.
@Page
const mixin IndexPage : EfanComponent {
	@Inject	abstract Pages				pages

	Str version() {
		IndexPage#.pod.version.toStr
	}
	
	Uri bedNapUrl() {
		pages[BednapPage#].pageUrl
	}
}

** (Pillow page) The main application page.
@Page
const mixin BednapPage : EfanComponent {
	@Inject abstract VisitorBookService	visitorBook
	@Inject abstract SampleData 		sampleData
	@Inject	abstract HttpRequest		httpRequest
	@Inject	abstract Pages				pages
	@Inject	abstract PageMeta			pageMeta

	abstract Visitor sample
	
	// ---- Rendering -----------------------------------------------------------------------------

	@InitRender
	Void initRender() {
		sample = sampleData.createSampleVisitor
	}

	Uri createUri() {
		pageMeta.eventUrl(#create.name)
	}

	Uri viewVisitorUri(Visitor visitor) {
		pages[VisitorPage#].withContext([visitor]).pageUrl
	}
	
	Uri deleteVisitorUri(Visitor visitor) {
		pageMeta.eventUrl(#delete.name, [visitor])
	}
	
	Str version() {
		IndexPage#.pod.version.toStr
	}

	
	
	// ---- Events --------------------------------------------------------------------------------
		
	@PageEvent { httpMethod="POST" }
	Redirect create() {
		visitor := Visitor() {
			it.name			= httpRequest.body.form["name"]
			it.comment		= httpRequest.body.form["comment"]
			it.visitedOn	= DateTime.now
		}
		visitorBook.add(visitor)
		
		return Redirect.afterPost(pageMeta.pageUrl)
	}

	@PageEvent
	Redirect delete(Visitor visitor) {
		visitorBook.delete(visitor)		
		return Redirect.afterPost(pageMeta.pageUrl)
	}
}

** (Pillow page) Displays a `Visitor` entity in full.
@Page
const mixin VisitorPage : EfanComponent {
	@Inject	abstract Pages				pages

	@PageContext
	abstract Visitor visitor
	
	Uri bedNapUrl() {
		pages[BednapPage#].pageUrl
	}
}

** Returns the given source file as plain text.
** Note this is not a Pillow Page but a *Route Handler*.
const class SourceCodePage {
	// Ensure a plain text Mime Type, as most browsers don't know what 'text/fandoc' is!
	Obj service(Uri file) {
		return Text.fromPlain(file.toFile.readAllStr)
	}
}

** Converts `Visitor` objects to and from a 'Str'.
** By registering this ValueEncoder (in `AppModule`) methods, such as 
** '@InitRender' above, can take Visitor entities as InitRender arguments.
const class VisitorValueEncoder : ValueEncoder {
	@Inject private const VisitorBookService visitorBook
	
	new make(|This|in) { in(this) }
	
	override Str toClient(Obj? value) {
		visitor := (Visitor) value
		return visitor.id.toStr
	}

	override Obj? toValue(Str clientValue) {
		return visitorBook.get(clientValue.toInt)
	}	
}
