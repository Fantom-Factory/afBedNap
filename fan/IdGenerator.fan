using concurrent::AtomicInt

const class IdGenerator {
	private const AtomicInt lastId	:= AtomicInt()
	
	Int nextId() {
		return lastId.incrementAndGet
	}
}
