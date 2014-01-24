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
		
		said := client.selectCss("p.lead").first
		verifyEq(said.text.writeToStr, "Judge Dredd said:")

		quote := client.selectCss("blockquote p").first
		verifyEq(quote.text.writeToStr, "I am the law!")
	}
}