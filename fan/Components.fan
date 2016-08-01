using afIoc::Inject
using afIocConfig::Config
using afEfanXtra::EfanComponent
using afEfanXtra::InitRender
using afEfanXtra::TemplateLocation
using afBedSheet::FileHandler
using afDuvet::HtmlInjector
using afGoogleAnalytics::GoogleAnalytics

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

	@Inject abstract FileHandler 		fileHander
	@Inject abstract HtmlInjector		injector
	@Inject abstract GoogleAnalytics	gooAnal
	
	@InitRender
	Void init(Str pageTitle) {
		this.pageTitle = pageTitle
		injector.injectStylesheet.fromServerFile(File(`etc/web/css/bootstrap.min.css`))
		gooAnal.renderPageView
	}
	
	Uri asset(Uri localFile) {
		fileHander.fromServerFile(File(localFile)).clientUrl
	}
}

** (efan component) Renders the 'pod.fandoc'.
@TemplateLocation { url=`doc/pod.fandoc`}
const mixin Overview : EfanComponent { }
