using util

class Main : AbstractMain {

	@Arg { help="The HTTP port to run the app on" }
	private Int port

	@Opt { help="Set to true for proxy" }
	private Bool proxy

	override Int run() {
		return afBedSheet::Main().main("${proxyStr} ${this.typeof.pod.name} $port".split)
	}

	private Str proxyStr() { proxy ? "-proxy" : ""	}
}
