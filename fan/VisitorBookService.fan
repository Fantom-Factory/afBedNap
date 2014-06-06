using concurrent::AtomicInt
using afConcurrent::SynchronizedMap
using afIoc::ActorPools
using afIoc::Inject
using afPillow::Pages

** (Service) For creating and retrieving visitor entities.
const class VisitorBookService {
			private const SynchronizedMap 	visitorBook
	static 	private const |Obj, Obj->Int|	sortByVisitedOn := |v1, v2->Int| { ((Visitor) v1).visitedOn <=> ((Visitor) v2).visitedOn }
	
	@Inject	private const IdGenerator 		idGenerator
	
	new make(ActorPools actorPools, |This|in) { 
		in(this)
		visitorBook = SynchronizedMap(actorPools["afBedNap.visitorBook"])
	}
	
	Visitor[] all() {
		visitorBook.vals.sortr(sortByVisitedOn)
	}
	
	Visitor get(Int id) {
		visitorBook.get(id)
	}
	
	Visitor add(Visitor visitor) {
		id := visitor.id ?: idGenerator.nextId
		visitorBook.set(id, visitor.withId(id))
		return visitor
	}
	
	Void delete(Visitor visitor) {
		visitorBook.remove(visitor.id)
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
