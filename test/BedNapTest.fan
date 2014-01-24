using afButter
using afBounce
using afIoc
using afIocEnv

internal class BedNapTest : Test {
	BedServer? 	server
	BedClient? 	client
	
	override Void setup() {
		server	= BedServer(AppModule#.pod).addModule(WebTestModule#).startup
		server.injectIntoFields(this)
		client = server.makeClient
	}

	override Void teardown() {
		server?.shutdown
	}
}

class WebTestModule {
    @Contribute { serviceType=ServiceOverride# }
    static Void contributeServiceOverride(MappedConfig config) {
        config["IocEnv"] = IocEnv.fromStr("Testing")
    }
}
