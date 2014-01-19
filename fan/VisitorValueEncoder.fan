using afIoc::Inject
using afBedSheet::ValueEncoder

const class VisitorValueEncoder : ValueEncoder {
	@Inject private const VisitorBookService visitorBook
	
	new make(|This|in) { in(this) }
	
	override Str toClient(Obj value) {
		visitor := (Visitor) value
		return visitor.id.toStr
	}

	override Obj toValue(Str clientValue) {
		return visitorBook.get(clientValue.toInt)
	}	
}
