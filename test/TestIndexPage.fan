using afIoc
using afButter

internal class TestIndexPage : BedNapTest {

	@Inject	VisitorBookService?	bookService
	
	Void testIndexRendersOkay() {
		response := client.get(`/`)
		verifyEq(response.statusCode, 200)
		
		h1	:= client.selectCss("h1")
		h1.verifyTextContains("Bed Nap Hotel")

		h2	:= client.selectCss("h2.panel-title")
		h2[0].verifyText("Add a comment")
		h2[1].verifyText("Visitor Comments")
		
		overview	:= client.selectCss("#overview")
		overview.verifyText("Overview")
	}
	
	Void testListRendering() {
		bookService.clear

		bookService.add(Visitor() {
			it.id			= 1
			it.name			= "Emma"
			it.comment		= "Groovy"
			it.visitedOn	= DateTime.now
		})
		bookService.add(Visitor() {
			it.id			= 2
			it.name			= "of-9"
			it.comment		= "Awesome"
			it.visitedOn	= DateTime.now.plus(1sec)
		})
		
		response := client.get(`/`)
		verifyEq(response.statusCode, 200)

		tableRows := client.selectCss("table > tbody > tr")
		tableRows.verifySize(2)

		row1 := tableRows[0].find("td")
		row1[0].verifyText("of-9")
		row1[2].verifyText("Awesome")
		
		row2 := tableRows[1].find("td")
		row2[0].verifyText("Emma")
		row2[2].verifyText("Groovy")
	}

	Void testAddComment() {
		bookService.clear
		
		client.followRedirects.enabled = false
		response := client.postForm(`/make`, ["name" : "Judge Dredd", "comment" : "I am the law!"])
		verifyEq(response.statusCode, 303)
		verifyEq(response.headers.location, `/`)
		
		verifyEq(bookService.all.size, 1)
		verifyEq(bookService.all[0].name, "Judge Dredd")
		verifyEq(bookService.all[0].comment, "I am the law!")
	}
}
