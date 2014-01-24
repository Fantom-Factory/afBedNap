using afIoc
using afButter
using afSizzle

internal class TestIndexPage : BedNapTest {

	@Inject	VisitorBookService?	bookService
	
	Void testIndexRendersOkay() {
		response := client.get(`/`)
		verifyEq(response.statusCode, 200)
		
		h1	:= client.selectCss("h1").first
		verifyEq(h1.text.writeToStr, "Bed Nap Hotel")

		h2	:= client.selectCss("h2.panel-title")
		verifyEq(h2[0].text.writeToStr, "Add a comment")
		verifyEq(h2[1].text.writeToStr, "Visitor Comments")
		
		overview	:= client.selectCss("#overview").first
		verifyEq(overview.text.writeToStr.trim, "Overview")
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
		verifyEq(tableRows.size, 2)
		
		row1 := Sizzle().selectFromElem(tableRows[0], "td")
		verifyEq(row1[0].text.writeToStr, "of-9")
		verifyEq(row1[2].text.writeToStr, "Awesome")

		row2 := Sizzle().selectFromElem(tableRows[1], "td")
		verifyEq(row2[0].text.writeToStr, "Emma")
		verifyEq(row2[2].text.writeToStr, "Groovy")
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
