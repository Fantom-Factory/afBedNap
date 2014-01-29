using afIoc

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
		
		response := client.get(`/visitor/666`)
		verifyEq(response.statusCode, 200)
		
		said := client.selectCss("p.lead")
		said.verifyText("Judge Dredd said:")

		quote := client.selectCss("blockquote p")
		quote.verifyText("I am the law!")
	}
}