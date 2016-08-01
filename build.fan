using build
using fanr

class Build : BuildPod {

	new make() {
		podName = "afBedNap"
		summary = "A simple BedSheet application; use it to kickstart your own Bed Apps!"
		version = Version("0.1.0")

		meta = [
			"proj.name"		: "Bed Nap",
			"proj.uri"		: "http://bednap.fantomfactory.org/",
			"afIoc.module"	: "afBedNap::AppModule",
			"repo.tags"		: "app",
			"repo.public"	: "false"
		]

		depends = [	
			"sys        1.0.68 - 1.0", 
			"concurrent 1.0.68 - 1.0",
			"util       1.0.68 - 1.0",
			"fandoc     1.0.68 - 1.0",

			// UPDATE /etc/fan/build.fan.efan
			// ---- Core ------------------------
			"afConcurrent 1.0.14 - 1.0", 
			"afIoc        3.0.2  - 3.0", 
			"afIocConfig  1.1.0  - 1.1", 
			"afIocEnv     1.1.0  - 1.1", 

			// UPDATE /etc/fan/build.fan.efan
			// ---- Web -------------------------
			"afBedSheet        1.5.2  - 1.5", 
			"afEfan            1.5.2  - 1.5",
			"afEfanXtra        1.2.0  - 1.2",
			"afPillow          1.1.2  - 1.1",
			"afSlim            1.2.0  - 1.2",
			"afColdFeet        1.4.0  - 1.4",
			"afDuvet           1.1.2  - 1.1",
			"afGoogleAnalytics 0.1.4  - 0.1",

			// UPDATE /etc/fan/build.fan.efan
			// ---- Test ------------------------
			"afBounce 1.1.2  - 1.1",
			"afButter 1.2.2  - 1.2",
			"afSizzle 1.0.2  - 1.0",
			"xml      1.0.68 - 1.0"
		]

		srcDirs = [`fan/`, `test/`]
		resDirs = [`doc/`, `etc/`, `etc/components/`, `etc/fan/`, `etc/pages/`, `etc/samples/`, `etc/web/`, `etc/web/css/`]

		// we want include test dirs, so override with empty csv
		meta["afBuild.testDirs"] = "ignore"
		
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
		installFromRepo(pods, "http://eggbox.fantomfactory.org/fanr/")
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
