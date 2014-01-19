using afIoc::Inject
using afPillow::Page
using afEfanXtra::InitRender

const mixin IndexPage : Page {

	@Inject abstract VisitorBookService	visitorBook
	@Inject abstract SampleData sampleData

	abstract Visitor sample
	
	@InitRender
	Void initRender() {
		sample = sampleData.createSampleVisitor
	}
	
}
