using afEfanXtra::EfanComponent
using afEfanXtra::EfanTemplate
using afEfanXtra::InitRender

** (efan component) Displays the source code tree.
const mixin FileTree : EfanComponent {
	Str link(Uri file) {
		"""<a href="/src/${file}">${file.name}</a>"""
	}
}

** (efan component) Displays a simple footer. 
const mixin Footer : EfanComponent { }

** (efan component) A simple page layout component.
const mixin Layout : EfanComponent {
	abstract Str? pageTitle

	@InitRender
	Void init(Str pageTitle) {
		this.pageTitle = pageTitle
	}
}

** (efan component) Renders the 'pod.fandoc'.
@EfanTemplate { uri=`doc/pod.fandoc`}
const mixin Overview : EfanComponent { }
