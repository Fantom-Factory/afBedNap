using build
using fanr

class Build : BuildPod {

	new make() {
		podName = "afBedNap"
		summary = "A simple BedSheet application; use it kickstart your own Bed Apps!"
		version = Version("0.0.3")

		meta	= [
			"org.name"		: "Alien-Factory",
			"org.uri"		: "http://www.alienfactory.co.uk/",
			"proj.name"		: "Bed Nap",
			"proj.uri"		: "http://bednap.fantomfactory.com/",
			"vcs.uri"		: "https://bitbucket.org/AlienFactory/afbednap",
			"license.name"	: "BSD 2-Clause License",	
			"repo.private"	: "true"

			,"afIoc.module"	: "afBedNap::AppModule"
		]

		depends = [	
			"sys 1.0", 
			"concurrent 1.0",
			"util 1.0",
			"fandoc 1.0",

			// core Ioc
			"afIoc 1.5.2+", 
			"afIocConfig 1.0.2+", 
			"afIocEnv 1.0.0+", 

			// web stuff
			"afBedSheet 1.3.0+", 
			"afEfan 1.3.6.2+",
			"afEfanXtra 1.0.8+",
			"afPillow 0+",
			"afSlim 1.1.2+",
	
			// for testing
			"afButter 0.0.2+",
			"afBounce 0.0.4+",
			"afSizzle 0.0.2+",
			"xml 1.0",
		]

		srcDirs = [`test/`, `fan/`]
		resDirs = [`doc/`, `etc/`, `etc/components/`, `etc/fan/`, `etc/pages/`, `etc/samples/`, `etc/web/`, `etc/web/css/`]

		docApi = false
		docSrc = false
	}
	
	@Target { help = "Heroku pre-compile hook, use to install dependencies" }
	Void herokuPreCompile() {
		repo := "http://repo.status302.com/fanr/"
		depends.each {
			status := fanr::Main().main("install -y -r ${repo} ${Depend(it).name}".split)
			// abort build if something went wrong
			if (status != 0) Env.cur.exit(status)			
		}
	}
	
	@Target { help = "Compile to pod file and associated natives" }
	override Void compile() {
		resDirs = resDirs.addAll(srcDirs)
		super.compile
	}
}
