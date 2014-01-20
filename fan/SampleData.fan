using afIoc::Inject
using afIocConfig::Config

const class SampleData {
	private const Str[] names		:= loadList("names.txt") 
	private const Str[] comments	:= loadList("comments.txt") 
	
	@Inject	
	private const VisitorBookService visitorBook

	@Inject	@Config { id="afIocEnv.isTest" }
	private const Bool isTest
	
	new make(|This|in) { in(this) }
	
	Void createSampleData() {
		if (isTest) return

		(1..((3..7).random)).each {
			visitor := createSampleVisitor()
			visitorBook.add(visitor)
		}
	}
 
	Visitor createSampleVisitor() {
		return Visitor() {
			randomDays		:= Duration((1..(365 * 30)).random.toStr + "day")
			it.name			= names.random
			it.comment		= comments.random
			it.visitedOn	= DateTime.now.minus(randomDays)
		}
	}

	private Str[] loadList(Str filename) {
		typeof.pod.file(`/etc/samples/${filename}`).readAllLines.exclude { it.isEmpty || it.startsWith("#")}
	}
}
