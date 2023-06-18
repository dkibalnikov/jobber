# Jobber

Jobber simplifies background jobs usage in interactive manner. Once long run code is being identified select it and pass to background job while continue to work with script. **Working environment as well as loaded packages will be replicated to background job automatically**. So, be careful to use the Jobber for working environment full of heavy objects. 

## Addin
Use addin to launch job in background. Consider using RStudio shortcuts which are really handy. 

![](/man/figures/addin.png)

## Installation

```R
devtools::install_github("dkibalnikov/jobber")
```
 ## Other packages 
 
- [job](https://lindeloev.github.io/job/)
- [callr](https://callr.r-lib.org/)
