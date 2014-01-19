using afPillow
using afEfanXtra

const mixin VisitorPage : Page {

	abstract Visitor visitor
	
	@InitRender
	Void initRender(Visitor visitor) {
		this.visitor = visitor
	}
	
}
