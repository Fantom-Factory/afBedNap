using afIoc::Inject
using afIoc::ConcurrentCache
using afBedSheet::Redirect
using afBedSheet::HttpRequest
using afPillow::Pages

const class VisitorBookService {
			private const ConcurrentCache 	visitorBook		:= ConcurrentCache()
	static 	private const |Obj, Obj->Int|	sortByVisitedOn := |v1, v2->Int| { ((Visitor) v1).visitedOn <=> ((Visitor) v2).visitedOn }
	
	@Inject	private const HttpRequest		httpRequest
	@Inject	private const Pages				pages
	@Inject	private const IdGenerator 		idGenerator

	
	new make(|This|in) { in(this) }
	
	Visitor[] all() {
		visitorBook.vals.sortr(sortByVisitedOn)
	}
	
	Visitor get(Int id) {
		visitorBook.get(id)
	}
	
	Void add(Visitor visitor) {
		id := idGenerator.nextId
		visitorBook.set(id, visitor.withId(id))
	}
	
	Redirect makeVisitor() {
		visitor := Visitor() {
			it.name			= httpRequest.form["name"]
			it.comment		= httpRequest.form["comment"]
			it.visitedOn	= DateTime.now
		}
		
		add(visitor)
		
		return Redirect.afterPost(pages.clientUri(IndexPage#))
	}
}
