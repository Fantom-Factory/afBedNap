using afEfanXtra::EfanComponent
using afEfanXtra::EfanTemplate
using afEfanXtra::InitRender

const mixin FileTree : EfanComponent {
	Str link(Uri file) {
		"""<a href="/src/${file}">${file.name}</a>"""
	}
}

const mixin Footer : EfanComponent { }

const mixin Layout : EfanComponent {
	abstract Str? pageTitle

	@InitRender
	Void init(Str pageTitle) {
		this.pageTitle = pageTitle
	}
}

@EfanTemplate { uri=`/doc/pod.fandoc`}
const mixin Overview : EfanComponent { }
