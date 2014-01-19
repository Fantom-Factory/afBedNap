using afIoc
using afButter

internal class TestIndexPage : BedNapTest {

	Void testExamplePage() {
		response := client.get(`/`)
		verifyEq(response.statusCode, 200)
	}
}
