1. The 2bP tests list.docx contains list of critical and additional tests I would execute for the ./allele endpoint. 
2. The allele.feature covers 3 scenarious: 
   - For each allele in the CYC2D6 gene, verify that each ethnicity frequency is lower than 1 or null
   - For each ethnicity, verify that the sum of frequencies in all CYP2D6 alleles is lower than 1
   - For each allele, verify that if there are findings, then there is at least one citations OR the evidence strength is “No Evidence”

