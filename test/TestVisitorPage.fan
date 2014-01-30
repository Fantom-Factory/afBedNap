using afIoc
using afBounce

internal class TestVisitorPage: BedNapTest {

	@Inject	VisitorBookService?	bookService

	Void testVisitorPage() {
		bookService.clear
		
		bookService.add(Visitor() {
			it.id			= 666
			it.name			= "Judge Dredd"
			it.comment		= "I am the law!"
			it.visitedOn	= DateTime.now
		})
		
		client.get(`/visitor/666`)
		
		said := Element("p.lead")
		said.verifyTextEq("Judge Dredd said:")

		quote := Element("blockquote p")
		quote.verifyTextEq("I am the law!")
	}
}