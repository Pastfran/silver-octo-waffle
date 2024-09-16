nextflow.enable.dsl = 2

//params.accession = null; nicht nötig, weil unten schon default im if workflow vergeben

params.store = "${launchDir}/store"
params.url =  "https://gitlab.com/dabrowskiw/cq-examples/-/raw/master/data/hepatitis_combined.fasta?inline=false"

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
	wget ${params.url} -O sample.fasta
	"""
}

process combineFile {
	storeDir params.store
	input: 
		path infiles
	output: 
		path "combined.fasta" 
	script: 
	"""
	cat *.fasta > combined.fasta
	"""
}

workflow {
if (!params.accession) {params.accession = 'M21012' 
	print("Default accessionnumber M21012 is used.")}
a = downloadReference(Channel.from(params.accession)) 
b = downloadSample()
c = a.concat(b)
d = c.collect()
combineFile(d)
}