using afButter
using afBounce
using afIoc
using afIocEnv

internal abstract class BedNapTest : Test {
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

internal class WebTestModule {
    @Contribute { serviceType=ServiceOverrides# }
    static Void contributeServiceOverride(MappedConfig config) {
        config["IocEnv"] = IocEnv.fromStr("Testing")
    }
}
