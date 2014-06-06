## Overview 

`BedNap` is a simple [BedSheet](http://www.fantomfactory.org/pods/afBedSheet) application with master / detail screens that can be used as a template to kickstart your own Bed Apps.

`BedNap` exists so developers can browse the source code and see for themselves how easy it is to piece together a working application with [BedSheet](http://www.fantomfactory.org/pods/afBedSheet) and other libraries. `Bed Nap` also features acceptance tests that probe the generated HTML and verifies the markup.

## Quick Start 

### 1. Install 

Install `Bed Nap` with the [Fantom Repository Manager](http://fantom.org/doc/docFanr/Tool.html#install):

    C:\> fanr install -r http://repo.status302.com/fanr/ afBedNap

### 2. Create 

Create your own working web application by replicating `Bed Nap` in to a working directory. Do this with the following command, where `podname` is the name of your web application.

    C:\> fan afBedNap -copyto C:\projects\ -podname myBedApp
    
    Copied 21 files to 'C:\projects\myBedApp'
    Bed App 'myBedApp' has been created!

This creates a copy of `Bed Nap` in `C:\projects\myBedApp` with the name `myBedApp`.

### 3. Run 

You can now build, test and run your new web app straight away!

To build, move in to the directory you've just created and run:

    C:\projects\myBedApp> fan build.fan
    
    compile [myBedApp]
      Compile [myBedApp]
        FindSourceFiles [10 files]
        WritePod [file:/C:/Apps/Fantom/fan/lib/fan/myBedApp.pod]
    BUILD SUCCESS [451ms]!

Test the app with [fant](http://fantom.org/doc/docTools/Fant.html):

    C:\projects\myBedApp> fant myBedApp
    
    ***
    *** All tests passed! [2 tests, 4 methods, 19 verifies]
    ***

Run the web application with:

    C:\projects\myBedApp> fan myBedApp
    
       ___    __                 _____        _
      / _ |  / /_____  _____    / ___/__  ___/ /_________  __ __
     / _  | / // / -_|/ _  /===/ __// _ \/ _/ __/ _  / __|/ // /
    /_/ |_|/_//_/\__|/_//_/   /_/   \_,_/__/\__/____/_/   \_, /
               Alien-Factory BedSheet v1.3.6, IoC v1.6.2 /___/
    
    BedSheet started up in 1,809ms

And point your web browser at: [http://localhost:8069/](http://localhost:8069/)

### 4. Repeat 

Feel free to modify the fantom source, web templates, and tests. To see the results, just rebuild the pod with `fan build.fan` and refresh your browser!

## Source Code 

If you can't wait to download `Bed Nap` and create your own working web application, you can browse the source code below. Click on a file to view it:

<%# This .fandoc file is used as an efan template for the Overview component %>

<%# View this app at [http://bednap.fantomfactory.org/](http://bednap.fantomfactory.org/) to see the File Tree %>

<% app.renderFileTree() %>

You can also view the source code over at BitBucket at: [https://bitbucket.org/AlienFactory/afbednap/src](https://bitbucket.org/AlienFactory/afbednap/src)

