using build
using fanr

class Build : BuildPod {

	new make() {
		podName = "afBedNap"
		summary = "A simple BedSheet application; use it to kickstart your own Bed Apps!"
		version = Version("0.0.9")

		meta = [
			"org.name"		: "Alien-Factory",
			"org.uri"		: "http://www.alienfactory.co.uk/",
			"proj.name"		: "Bed Nap",
			"proj.uri"		: "http://bednap.fantomfactory.com/",
			"vcs.uri"		: "https://bitbucket.org/AlienFactory/afbednap",
			"license.name"	: "The MIT Licence",	
			"repo.private"	: "true",

			"tags"			: "templating, testing, web",
			"afIoc.module"	: "afBedNap::AppModule"
		]

		depends = [	
			"sys 1.0", 
			"concurrent 1.0",
			"util 1.0",
			"fandoc 1.0",

			// core Ioc
			"afConcurrent 1.0.0+", 
			"afIoc 1.6.0+", 
			"afIocConfig 1.0.4+", 
			"afIocEnv 1.0.4+", 

			// web stuff
			"afBedSheet 1.3.6+", 
			"afEfan 1.3.8+",
			"afEfanXtra 1.0.14+",
			"afPillow 1.0.4+",
			"afSlim 1.1.2+",
	
			// for testing
			"afBounce 1.0.0+",
			"afButter 0.0.6+",
			"afSizzle 1.0.0+",
			"xml 1.0",
		]

		srcDirs = [`test/`, `fan/`]
		resDirs = [`licence.txt`, `doc/`, `etc/`, `etc/components/`, `etc/fan/`, `etc/pages/`, `etc/samples/`, `etc/web/`, `etc/web/css/`]

		docApi = true
		docSrc = true
	}
	
	@Target { help = "Heroku pre-compile hook, use to install dependencies" }
	Void herokuPreCompile() {
		pods := depends.findAll |Str dep->Bool| {
			depend := Depend(dep)
			pod := Pod.find(depend.name, false)
			return (pod == null) ? true : !depend.match(pod.version)
		}
		installFromRepo(pods, "http://repo.status302.com/fanr/")
	}

	@Target { help = "Compile to pod file and associated natives" }
	override Void compile() {
		resDirs = resDirs.addAll(srcDirs)
		super.compile
	}
	
	private Void installFromRepo(Str[] pods, Str repo) {
		cmd := "install -errTrace -y -r ${repo}".split.add(pods.join(","))
		log.info("")
		log.info("Installing pods...")
		log.indent
		log.info("> fanr " + cmd.join(" ") { it.containsChar(' ') ? "\"$it\"" : it })
		status := fanr::Main().main(cmd)
		log.unindent
		// abort build if something went wrong
		if (status != 0) Env.cur.exit(status)
	}
}
