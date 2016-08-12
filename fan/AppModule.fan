using concurrent
using afIoc
using afIocConfig
using afIocEnv
using afConcurrent
using afBedSheet
using afEfanXtra
using afSlim
using afGoogleAnalytics

** The [afIoc]`pod:afIoc` module class.
const class AppModule {

	Void defineServices(RegistryBuilder bob) {
		bob.addService(IdGenerator#)
		bob.addService(VisitorBookService#)

		bob.addService(SampleData#)
	}
 
	@Contribute { serviceType=Routes# }
	Void contributeRoutes(Configuration config) {
		config.add(Route(`/src/***`, SourceCodePage#service))
	}
 
	@Contribute { serviceType=ValueEncoders# }
	Void contributeValueEncoders(Configuration config) {
		config[Visitor#] = config.build(VisitorValueEncoder#)
	}

	@Contribute { serviceType=ActorPools# }
	Void contributeActorPools(Configuration config) {
		config["afBedNap.visitorBook"] = ActorPool() { it.name = "afBedNap.visitorBook" }
	}
 
	Void onRegistryStartup(Configuration config, SampleData sampleData) {
		config.add |->| { sampleData.createSampleData() }
	}

	@Contribute { serviceType=ApplicationDefaults# }
	Void contributeAppDefaults(Configuration config, IocEnv env) {
		if (env.isProd)
			config[BedSheetConfigIds.host]				= "http://bednap.fantomfactory.org"
	}

	
	
	// ---- Serve Up Files from `etc/web/` --------------------------------------------------------
	
	@Contribute { serviceType=FileHandler# }
	Void contributeFileHandler(Configuration config) {
		config[`/`] = `etc/web/`
	}

	
	
	// ---- Add efan Template Directories ---------------------------------------------------------
	
	@Contribute { serviceType=TemplateDirectories# }
	Void contributeEfanDirs(Configuration config) {
		addRecursive(config, `etc/pages/`.toFile)
		addRecursive(config, `etc/components/`.toFile)
	}
	
	Void addRecursive(Configuration config, File dir) {
		if (!dir.isDir)
			throw Err("`${dir.normalize}` is not a directory")
		dir.walk { if (it.isDir) config.add(it) }
	}
}
