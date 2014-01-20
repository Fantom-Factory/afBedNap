using util
using afEfan

class Main : AbstractMain {

	@Opt { help="The directory to copy Bed Nap to" }
	private File? copyto

	@Opt { help="The name of your new application" }
	private Str? podname

	override Int usage(OutStream out := Env.cur.out) {
		help := """
		           Bed Nap v${this.typeof.pod.version}
		           --------------
		           Bed Nap is a simple BedSheet application; use it as a template to
		           kickstart your own Bed Apps.
		           
		           Start by copying the Bed Nap source into a working directory. Example:
		           
		             fan afBedNap -copyto C:\\projects\\ -podname myBedApp"""
		out.printLine(help)
		return super.usage(out)
	}
	
	override Int run() {
		if (podname != null || copyto != null)
			return installBedNap
		
		if (!helpOpt)
			return err("Missing arguments")
		return 0
	}
	
	Int installBedNap() {
		if (copyto == null || podname == null)
			return err("Both -copyto and -podname options need to be specified")
		
		if (!isPodNameLegal)
			return err("'${podname}' is not a legal podname - [A-Za-z0-9] only")
		
		if (!copyto.exists || !copyto.isDir)
			return err("`${copyto.osPath}` is not a directory")
		
		copyto = copyto.createDir(podname)
		
		fileCount := 0
		this.typeof.pod.files
			.exclude { it.uri.path.size <= 1 || ["fcode", "doc"].contains(it.uri.path[0]) || it.ext == "efan" }
			.each {
				newFile := copyto + it.uri.pathOnly.toStr[1..-1].toUri
				it.copyTo(newFile, ["overwrite":true])
				fileCount++
			}
		this.typeof.pod.file(`/doc/pod.fandoc`, false).copyInto(copyto.createDir("doc"), ["overwrite":true])
		
		buildFile	:= this.typeof.pod.file(`/etc/fan/build.fan.efan`)
		mainFile	:= this.typeof.pod.file(`/etc/fan/Main.fan.efan` )
		buildStr	:= Efan().renderFromFile(buildFile, ["podname":podname])
		mainStr		:= Efan().renderFromFile(mainFile,  ["podname":podname])
		(copyto + `build.fan`   ).out.print(buildStr).close
		(copyto + `fan/Main.fan`).out.print(mainStr ).close
		fileCount += 2
		
		Env.cur.out.printLine("Copied $fileCount files to '${copyto.normalize.osPath}'")
		Env.cur.out.printLine("Bed App '$podname' has been created!")
		return 0
	}
	
	Bool isPodNameLegal() {
		!podname.isEmpty && podname[0].isAlpha && podname.all { it.isAlphaNum }
	}
	
	Int err(Str reason) {
		usage
		Env.cur.out.printLine(reason)
		return 1
	}
}
