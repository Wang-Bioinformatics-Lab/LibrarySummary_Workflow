run:
	nextflow run ./nf_workflow.nf -resume -c nextflow.config

init_modules:
	git submodule update --init --recursive