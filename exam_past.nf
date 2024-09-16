nextflow.enable.dsl = 2
// export NXF_SINGULARITY_HOME_MOUNT=true vorher laufen lassen! 
//params.accession = null; nicht nötig, weil unten schon default im if workflow vergeben

params.store = "${launchDir}/store"
params.url =  "https://gitlab.com/dabrowskiw/cq-examples/-/raw/master/data/hepatitis_combined.fasta?inline=false"
params.out = "${launchDir}/output"
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

process sequenceAlign {
	storeDir params.store
	container "https://depot.galaxyproject.org/singularity/mafft%3A7.520--hec16e2b_1"
	input: 
		path infile 
	output: 
		path "alignment.fasta"
	script: 
	"""
	mafft $infile > alignment.fasta
	"""
}

process sequenceClean {
	publishDir params.out, mode: "copy", overwrite: true 
	container "https://depot.galaxyproject.org/singularity/trimal%3A1.5.0--h4ac6f70_1"
	input:
		path infileclean 
	output: 
		path "${infileclean.getSimpleName()}_out.html"
		path "${infileclean.getSimpleName()}_out.fasta"
	script: 
	"""
	 trimal -in $infileclean -out ${infileclean.getSimpleName()}_out.fasta -htmlout ${infileclean.getSimpleName()}_out.html -automated1
	"""
		
}
workflow {
if (!params.accession) {params.accession = 'M21012' 
	print("Default accessionnumber M21012 is used.")}

a = downloadReference(Channel.from(params.accession)) 
b = downloadSample()
c = a.concat(b)
d = c.collect()
e = combineFile(d)
f = sequenceAlign(e)
g = sequenceClean(f)
}