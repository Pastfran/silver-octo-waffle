nextflow.enable.dsl = 2

params.accession = "M21012"
params.store = "${launchDir}/store"

process downloadReference {
	storeDir params.store
	input:
		val accession 
	output:
		path "${accession}_reference.fasta"
	script: 
	"""
	wget "https://eutils.ncbi.nlm.nih.gov/entrez/eutils/efetch.fcgi?db=nuccore&id=${accession}&rettype=fasta&retmode=text" -O ${accession}_reference.fasta
	"""
}

process downloadSample {
	storeDir params.store
	output: 
		path "sample.fasta"
	script: 
	"""
	wget "https://gitlab.com/dabrowskiw/cq-examples/-/raw/master/data/hepatitis_combined.fasta?inline=false" -O sample.fasta
	"""
}

workflow {
//if (!params.reference) {params.accession = "M21012" 
//	print("Default accessionnumber M21012 is used.")}
// else ()
a = downloadReference(Channel.from(params.accession)) 


b = downloadSample()

}