using afIoc::Inject
using afEfanXtra::EfanComponent
using afEfanXtra::EfanLocation
using afEfanXtra::InitRender
using afBedSheet::FileHandler
using afDuvet::HtmlInjector

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

	@Inject abstract FileHandler 	fileHander
	@Inject abstract HtmlInjector	injector
	
	@InitRender
	Void init(Str pageTitle) {
		this.pageTitle = pageTitle
		injector.injectStylesheet.fromServerFile(File(`etc/web/css/bootstrap.min.css`))
	}
	
	Uri asset(Uri localFile) {
		fileHander.fromServerFile(File(localFile)).clientUrl
	}
}

** (efan component) Renders the 'pod.fandoc'.
@EfanLocation { url=`fan://afBedNap/doc/pod.fandoc`}
const mixin Overview : EfanComponent { }
