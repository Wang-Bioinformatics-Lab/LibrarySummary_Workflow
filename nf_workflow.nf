#!/usr/bin/env nextflow
nextflow.enable.dsl=2

// 
params.input_libraries = "$baseDir/data/"

//This publish dir is mostly  useful when we want to import modules in other workflows, keep it here usually don't change it
params.publishdir = "$launchDir"
TOOL_FOLDER = "$moduleDir/bin"
MODULES_FOLDER = "$TOOL_FOLDER/NextflowModules"

// GNPS2 Boiler Plate
params.task = "" // This is the GNPS2 task if it is necessary

// COMPATIBILITY NOTE: The following might be necessary if this workflow is being deployed in a slightly different environemnt
// checking if outdir is defined,
// if so, then set publishdir to outdir
if (params.outdir) {
    _publishdir = params.outdir
}
else{
    _publishdir = params.publishdir
}

// Augmenting with nf_output
_publishdir = "${_publishdir}/nf_output"

// A lot of useful modules are already implemented and added to the nextflow modules, you can import them to use
// the publishdir is a key word that we're using around all our modules to control where the output files will be saved
include {summaryLibrary} from "$MODULES_FOLDER/nf_library_search_modules.nf" addParams(publishdir: _publishdir)

workflow {
    libraries_ch = Channel.fromPath(params.input_libraries + "/*.mgf")
    
    library_summary_ch = summaryLibrary(libraries_ch)

    // merge summary files as tsv
    library_summary_ch.collectFile(name: 'librarysummary.tsv', keepHeader: true, storeDir: _publishdir + "/librarysummary")
}
