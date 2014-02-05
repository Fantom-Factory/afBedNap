using concurrent::AtomicInt
using afIoc::Inject
using afIoc::ConcurrentCache
using afPillow::Pages

** (Service) For creating and retrieving visitor entities.
const class VisitorBookService {
			private const ConcurrentCache 	visitorBook		:= ConcurrentCache()
	static 	private const |Obj, Obj->Int|	sortByVisitedOn := |v1, v2->Int| { ((Visitor) v1).visitedOn <=> ((Visitor) v2).visitedOn }
	
	@Inject	private const IdGenerator 		idGenerator

	
	new make(|This|in) { in(this) }
	
	Visitor[] all() {
		visitorBook.vals.sortr(sortByVisitedOn)
	}
	
	Visitor get(Int id) {
		visitorBook.get(id)
	}
	
	Void add(Visitor visitor) {
		id := visitor.id ?: idGenerator.nextId
		visitorBook.set(id, visitor.withId(id))
	}
	
	Void clear() {
		 visitorBook.clear
	}	
}

** (Service) Generates a sequence of numbers to be used as `Visitor` IDs.
const class IdGenerator {
	private const AtomicInt lastId	:= AtomicInt()
	
	Int nextId() {
		return lastId.incrementAndGet
	}
}
