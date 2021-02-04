# Extract R code and also include documentation
library(knitr)

getwd()
setwd("/Users/chengtzuhsuan/Statistical-Data-Analysis-for-Business-and-Management/")

purl("/Users/chengtzuhsuan/Statistical-Data-Analysis-for-Business-and-Management/asd1901/assignment1.Rmd", 
     output = "assignment1.R", documentation = 2)

purl("./asd1902/assignment2.Rmd", 
     output = "./asd1902/assignment2.R", documentation = 2)

purl("./asd1903/assignment3.Rmd", 
     output = "./asd1903/assignment3.R", documentation = 2)

purl("./asd1904/assignment4.Rmd", 
     output = "./asd1904/assignment4.R", documentation = 2)

purl("./asd1905/assignment5.Rmd", 
     output = "./asd1904/assignment5.R", documentation = 2)