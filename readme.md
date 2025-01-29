# Nextflow Exam  

This Nextflow script was created by me for the exam **"Next Generation Sequencing"** as part of a further education training.  

## **Background**  
A group works with **Hepatitis delta virus (HDV)**. For analysis, a **comparison** between the reference genome and the sample genome is needed.  

## **Required Analysis**  
1. Align all genomes from the sequencing run to the reference genome.  
2. Clean up the alignment (remove low-quality regions).  
3. Provide a simple visualization of the alignment.  

## **Pipeline Steps**  
1. **Initial Setup:**  
   - Set **Nextflow DSL 2**.  
   - Set environment variable for **Singularity container**.  
   - Define store directory, URL, and output directory.  

2. **Download Reference Genome from NCBI GenBank**  
   - Uses an input accession (`--accession`).  
   - **Default accession:** `M21012`.  
   - **Output file:** `${accession}_reference.fasta`.  
   - **Stored in:** `params.store`.  

3. **Download Sample Genome from a URL**  
   - The URL can be changed using `params.url`.  
   - **Output file:** `sample.fasta`.  
   - **Stored in:** `params.store`.  

4. **Combine the Reference and Sample Genomes into One FASTA File for Alignment**  
   - **Output file:** `${accession}_combined.fasta`.  
   - **Stored in:** `params.store`.  

5. **Run MAFFT Aligner on the Combined FASTA File (Using a Singularity Container)**  
   - **Output file:** `${infile.getSimpleName()}_alignment.fasta`.  
   - **Stored in:** `params.store`.  

6. **Clean the Alignment Using TrimAl with `-automated1` (Using a Singularity Container)**  
   - **Output files:**  
     - `${infileclean.getSimpleName()}_out.fasta` (cleaned FASTA file).  
     - `${infileclean.getSimpleName()}_out.html` (visualization report).  
   - **Stored in:** `params.out` (published directory).  
