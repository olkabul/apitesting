Feature: operations with allele properties

Background: 
    Given url "https://api.cpicpgx.org/v1"

Scenario: Verify that each ethnicity frequency is lower than 1 or null
    * def schema = read('classpath:CPIC/helpers/schemas/allele.json')
    Given path 'allele'
    Given param genesymbol = "eq.CYP2D6"
    Given param name = "eq.*1"
    When method get
    Then status 200
    And match response == schema
    * def allFrequencies = karate.map(response, function(x){ return x.frequency })
    And def isValidFrequency = function(x) { return x < 1 || x === null }
    And def frequenciesValid = karate.forEach(allFrequencies, isValidFrequency)
    And def invalidFrequiencies = karate.filter(frequenciesValid, function(x){ return x === false })
    And match invalidFrequiencies == []


Scenario: For each ethnicity, verify that the sum of frequencies in all CYP2D6 alleles is lower than 1
    * def ethnicities = ["Latino", "American", "European", "Oceanian", "East Asian", "Near Eastern", "Central/South Asian", "Sub-Saharan African", "African American/Afro-Caribbean"]
    Given path 'allele'
    Given param genesymbol = "eq.CYP2D6"
    When method get
    Then status 200
    * def alleles = response
    * def frequenciesValid = true
    * def totalFrequencies = {}
    * karate.forEach(alleles, function(allele) { 
        * def frequencies = allele.frequency
        * def sum = 0
        * karate.forEach(ethnicities, function(ethnicity) {
            * if (frequencies[ethnicity] != null) {
                * sum += frequencies[ethnicity]}})
        * totalFrequencies[allele.name] = sum
        * if (sum >= 1) {
            * frequenciesValid = false}})
    * print totalFrequencies
    * print frequenciesValid
    And match frequenciesValid == true

Scenario: Verify citations or strength is “No Evidence”
    Given path 'allele'
    Given param genesymbol = "eq.CYP2D6"
    When method get
    Then status 200
    * def alleles = response
    * def isValid = true
    * karate.forEach(alleles, function(allele) {
        * if (allele.findings != null) {
            * def findings = allele.findings
            * karate.forEach(findings, function(finding) {
                * if (finding.citations == null && finding.evidenceStrength != "No Evidence") {
                    * isValid = false}})}})
    And match isValid == true
    