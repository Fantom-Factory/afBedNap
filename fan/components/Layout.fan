using afEfanXtra

const mixin Layout : EfanComponent {
	
	abstract Str? pageTitle

	@InitRender
	Void init(Str pageTitle) {
		this.pageTitle = pageTitle
	}

}
