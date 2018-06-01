# Generations and Protest in Eastern Germany: Between Revolution and Apathy
## Codebook (final dataset: `ess.dta`)
Philippe Joly (2018)

---

### Variable List

| Variable      | Description
| ------------- | ---------------------------------------------------------
| dweight       | Design weight
| petition      | Signed petition, last 12 months
| boycott       | Boycotted certain products, last 12 months
| demonstration | Taken part in lawful public demonstration, last 12 months
| land          | Land
| eastintv      | Place of Interview, Eastern/Western Germany
| age           | Age of respondent
| age10         | Age of respondent (10 years)
| eastsoc       | Region of early socialization, Eastern/Western Germany
| period        | Period (survey round)
| cohort        | Birth cohort
| female        | Gender
| edu3          | Highest level of education
| unemp         | Unemployed
| union         | Member of trade union or similar organisation
| city          | Size of town/city
| class5        | Final Oesch class position - 5 classes

---

### `dweight`
**Type**: numeric

**Description**: Design weight

**Range**: [0.418, 1.324]

**Unique values**: 42

---

### `petition`
**Type**: factor

**Description**: Signed petition, last 12 months

**Coding**:

0. Not done
1. Have done

---

### `boycott`
**Type**: factor

**Description**: Boycotted certain products, last 12 months

**Coding**:

0. Not done
1. Have done

---

### `demonstration`
**Type**: factor

**Description**: Taken part in lawful public demonstration, last 12 months

**Coding**:

0. Not done
1. Have done

---

### `land`
**Type**: factor

**Description**: Land

**Coding**:

1. Baden-Wuerttemberg
2. Bayern
3. Berlin
4. Brandenburg
5. Bremen
6. Hamburg
7. Hessen
8. Mecklenburg-Vorpommern
9. Niedersachsen
10. Nordrhein-Westfalen
11. Rheinland-Pfalz
12. Saarland
13. Sachsen
14. Sachsen-Anhalt
15. Schleswig-Holstein
16. Thueringen

---

### `eastintv`
**Type**: factor

**Description**: Place of interview: Eastern, Western Germany

**Coding**:

0. Western Germany
1. Eastern Germany

---

### `age`
**Type**: numeric

**Description**: Age of respondent

**Range**: [15,100]

**Unique values**: 85

---

### `age10`
**Type**: numeric

**Description**: Age of respondent (10 years)

**Range**: [1.5,10]

**Unique values**: 85

---

### `eastsoc`
**Type**: factor

**Description**: Region of early socialization, Eastern/Western Germany

**Coding**:

0. Western Germany
1. Eastern Germany

---

### `period`
**Type**: numeric

**Description**: Period (survey round)

**Range**: [2002,2016]

**Unique values**: 8

---

### `cohort`
**Type**: numeric

**Description**: Birth cohort

**Range**: [1920,1985]

**Unique values**: 14

---

### `female`
**Type**: factor

**Description**: Gender

**Coding**:

0. Man
1. Woman

---

### `edu3`
**Type**: factor

**Description**: Highest level of education

**Coding**:

1. Lower
2. Middle
3. Higher

**Note**: _Lower_ corresponds to ES-ISCED I (less than lower secondary) OR ES-ISCED II (lower secondary); _Middle_ corresponds to  ES-ISCED IIIb (lower tier upper secondary) OR ES-ISCED IIIa (upper tier upper secondary) OR ES-ISCED IV (advanced vocational, sub-degree); _Higher_ corresponds to  ES-ISCED V1 (lower tertiary education, BA level) OR ES-ISCED V2 (higher tertiary education, >= MA level)

---

### `unemp`
**Type**: factor

**Description**: Unemployed

**Coding**:

0. No
1. Yes

---

### `union`
**Type**: factor

**Description**: Member of trade union or similar organisation

**Coding**:

0. No
1. Yes, currently or previously

---

### `city`
**Type**: factor

**Description**: Size of town/city

**Coding**:

1. Farm or home in countryside
2. Country village
3. Town or small city
4. Suburbs or outskirts of big city
5. A big city

---

### `class5`
**Type**: factor

**Description**: Final Oesch class position - 5 classes

**Coding**:

1. Higher-grade service class
2. Lower-grade service class
3. Small business owners
4. Skilled workers
5. Unskilled workers