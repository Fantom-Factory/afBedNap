
const class Visitor {
	
	const Int?		id
	const Str		name
	const DateTime	visitedOn
	const Str		comment
	
	new make(|This| in) {
		in(this)
	}
	
	Str commentAbbr() {
		return (comment.size < 50) ? comment : comment[0..50] + "..."
	}
	
	Visitor withId(Int id) {
		return Visitor() {
			it.id			= id
			it.name			= this.name
			it.visitedOn	= this.visitedOn
			it.comment		= this.comment
		}
	}
}
