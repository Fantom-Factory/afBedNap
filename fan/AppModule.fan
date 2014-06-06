using concurrent
using afIoc
using afIocConfig
using afBedSheet
using afEfanXtra
using afSlim

** The [afIoc]`http://repo.status302.com/doc/afIoc/#overview` module class.
const class AppModule {

	static Void bind(ServiceBinder binder) {
		binder.bind(IdGenerator#)
		binder.bind(VisitorBookService#)

		binder.bind(SampleData#)
	}
 
	@Contribute { serviceType=Routes# }
	static Void contributeRoutes(OrderedConfig config) {
		config.add(Route(`/src/***`, SourceCodePage#service))
	}
 
	@Contribute { serviceType=ValueEncoders# }
	static Void contributeValueEncoders(MappedConfig config) {
		config[Visitor#] = config.autobuild(VisitorValueEncoder#)
	}
 
	@Contribute { serviceType=RegistryStartup# }
	static Void contributeRegistryStartup(OrderedConfig config, SampleData sampleData) {
		config.add |->| { sampleData.createSampleData() }
	}

	@Contribute { serviceType=ActorPools# }
	static Void contributeActorPools(MappedConfig config) {
		config["afBedNap.visitorBook"] = ActorPool()
	}

	
	
	// ---- Serve Up Files from `etc/web/` --------------------------------------------------------
	
	@Contribute { serviceType=FileHandler# }
	static Void contributeFileHandler(MappedConfig config) {
		config[`/`] = `etc/web/`
	}

	
	
	// ---- Add efan Template Directories ---------------------------------------------------------
	
	@Contribute { serviceType=TemplateDirectories# }
	static Void contributeEfanDirs(OrderedConfig config) {
		addRecursive(config, `etc/pages/`.toFile)
		addRecursive(config, `etc/components/`.toFile)
	}
	
	static Void addRecursive(OrderedConfig config, File dir) {
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
	internal static Void contributeEfanTemplateConverters(MappedConfig config, Slim slim) {
		config["slim"] = |File file -> Str| { slim.parseFromFile(file) }
	}
}
