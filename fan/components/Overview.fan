using fandoc::HtmlDocWriter
using fandoc::DocElem
using fandoc::Doc
using fandoc::FandocParser
using afEfanXtra::EfanComponent
using afEfanXtra::EfanTemplate

@EfanTemplate { uri=`fan://afEfanXtra/res/viaRenderMethod.efan`}
const mixin Overview : EfanComponent {
	
	Str render() {
		poddoc 	:= `doc/pod.fandoc`.toFile.readAllStr //?: "Could not find '/doc/pod.fandoc'"
		fandoc	:= FandocParser().parseStr(poddoc)
		return printDoc(fandoc.children)
	}
	
	private Str printDoc(DocElem[] doc) {
		buf	:= StrBuf()
		dw	:= PlainHtmlWriter(buf.out)
		doc.each { it.write(dw) }
		return buf.toStr			
	}
}

class PlainHtmlWriter : HtmlDocWriter {
	new make(OutStream out := Env.cur.out) : super(out) { }
	override Void docStart(Doc doc) { } 
	override Void docEnd(Doc doc) { }
}
