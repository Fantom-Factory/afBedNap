using build

class Build : BuildPod {

	new make() {
		podName = "afBedNap"
		summary = "An online Fantom regular expression editor"
		version = Version("0.0.1")

		meta	= [
			"org.name"		: "Alien-Factory",
			"org.uri"		: "http://www.alienfactory.co.uk/",
			"proj.name"		: "Fantom-Factory",
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

			// core Ioc
			"afIoc 1.5+", 
			"afIocConfig 1.0+", 
			"afIocEnv 1.0+", 

			// web stuff
			"afBedSheet 1.2.4.1+", 
			"afEfanXtra 1.0.6+",
			"afPillow 0+",
			"afSlim 1.1+",
	
			// for testing
			"afButter 0+",
			"afBounce 0+",
			"afSizzle 0+"
		]

		srcDirs = [`test/app-tests/`, `fan/`, `fan/pages/`, `fan/components/`]
		resDirs = [`etc/`, `etc/components/`, `etc/pages/`, `etc/samples/`, `etc/web/`, `etc/web/css/`, `etc/web/images/`]
//		resDirs = [`etc/`, `etc/samples/`]

		docApi = false
		docSrc = false
	}
}
