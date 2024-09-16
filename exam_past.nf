nextflow.enable.dsl = 2

params.reference = null
params.store = "${LaunchDir}/store"

process downloadReference {
	StoreDir params.store
	input:
		val accession 
	output:
		path "${accession}_reference.fasta"
	script: 
	"""
	wget wget "https://eutils.ncbi.nlm.nih.gov/entrez/eutils/efetch.fcgi?db=nuccore&id=${accession}M21012&rettype=fasta&retmode=text" -O ${accession}_reference.fasta
	"""
}

process downloadSample {
	storDir params.store
	input: 
		path sample
	output: 
		path "${sample}_sample.fasta"
	script: 
	"""
	wget "https://gitlab.com/dabrowskiw/cq-examples/-/raw/master/data/hepatitis_combined.fasta?inline=false" -O ${sample}_sample.fasta
	"""
}

workflow {
if {!params.reference} (params.reference = "M21012" 
	print("Default accessionnumber M21012 is used. "))

}