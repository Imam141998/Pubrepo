# CRO Macro Catalog

This repository contains the CRO macro catalog packaged as a compiled SAS macro library.

## Setup & Usage

The macro catalog is available as a `SASMACR.sas7bcat` file.  
To enable the macros, assign the macro library and set the required SAS options as shown below:

```sas
libname macrocat "Path\sasmacr.sas7bcat";
options mstored sasmstore=macrocat;
## Disclaimer

This repository is intended for macro testing and validation purposes only.  
Not for direct use in production or clinical reporting.
