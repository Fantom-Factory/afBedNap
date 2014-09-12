using concurrent
using afIoc
using afIocConfig
using afIocEnv
using afBedSheet
using afEfanXtra
using afSlim
using afGoogleAnalytics

** The [afIoc]`http://repo.status302.com/doc/afIoc/#overview` module class.
const class AppModule {

	static Void defineServices(ServiceDefinitions defs) {
		defs.add(IdGenerator#)
		defs.add(VisitorBookService#)

		defs.add(SampleData#)
	}
 
	@Contribute { serviceType=Routes# }
	static Void contributeRoutes(Configuration config) {
		config.add(Route(`/src/***`, SourceCodePage#service))
	}
 
	@Contribute { serviceType=ValueEncoders# }
	static Void contributeValueEncoders(Configuration config) {
		config[Visitor#] = config.autobuild(VisitorValueEncoder#)
	}

	@Contribute { serviceType=ActorPools# }
	static Void contributeActorPools(Configuration config) {
		config["afBedNap.visitorBook"] = ActorPool() { it.name = "afBedNap.visitorBook" }
	}
 
	@Contribute { serviceType=RegistryStartup# }
	static Void contributeRegistryStartup(Configuration config, SampleData sampleData) {
		config.add |->| { sampleData.createSampleData() }
	}

	@Contribute { serviceType=ApplicationDefaults# }
	static Void contributeAppDefaults(Configuration config, IocEnv env) {
		if (env.isProd)
			config[BedSheetConfigIds.host]				= "http://bednap.fantomfactory.org"
		config[GoogleAnalyticsConfigIds.accountNumber]	= Env.cur.vars["afGoogleAnalytics.accNo"] ?: ""
		config[GoogleAnalyticsConfigIds.accountDomain]	= "//bednap.fantomfactory.org"
	}

	
	
	// ---- Serve Up Files from `etc/web/` --------------------------------------------------------
	
	@Contribute { serviceType=FileHandler# }
	static Void contributeFileHandler(Configuration config) {
		config[`/`] = `etc/web/`
	}

	
	
	// ---- Add efan Template Directories ---------------------------------------------------------
	
	@Contribute { serviceType=TemplateDirectories# }
	static Void contributeEfanDirs(Configuration config) {
		addRecursive(config, `etc/pages/`.toFile)
		addRecursive(config, `etc/components/`.toFile)
	}
	
	static Void addRecursive(Configuration config, File dir) {
		if (!dir.isDir)
			throw Err("`${dir.normalize}` is not a directory")
		dir.walk { if (it.isDir) config.add(it) }
	}
	
	
	
	// ---- Use Slim Templates --------------------------------------------------------------------
	
	@Build { serviceId="slim" }
	static Slim buildSlim() {
		Slim(TagStyle.xhtml)
	}

	@Contribute { serviceType=TemplateConverters# }
	internal static Void contributeEfanTemplateConverters(Configuration config, Slim slim) {
		config["slim"] = |File file -> Str| { slim.parseFromFile(file) }
	}
}
