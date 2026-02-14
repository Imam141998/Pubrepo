# Clinical SDTM Template – Project Setup Documentation

## 1. Purpose

The purpose of this project is to create a standardized folder structure for SDTM and ADaM programming using R.

This template enables:

- Structured organization of study files
- Clear separation of raw, derived, and output data
- Reproducible execution
- Easy scalability across multiple studies

This project does not contain clinical data. It defines the structural framework only.

---

## 2. Folder Structure

template_study/
│
├── data/
│ ├── raw/ # Raw input datasets
│ ├── sdtm/ # Derived SDTM datasets
│ └── adam/ # Derived ADaM datasets
│
├── programs/
│ ├── sdtm/ # SDTM derivation scripts
│ └── adam/ # ADaM derivation scripts
│
├── metadata/ # Specifications and mapping files
├── output/ # Final exported files (XPT, tables)
├── logs/ # Execution logs
│
├── config.yml # Study configuration file
├── run_sdtm.R # SDTM execution script
├── run_adam.R # ADaM execution script

---

## 3. Project Creation Process

Step 1 – Create a New RStudio Project

Open RStudio

Click File → New Project

Select New Directory

Choose New Project

Select your root directory (e.g., F:/Project)

Name the project:

template_study


Click Create Project

This ensures the working directory is properly isolated.

Step 2 – Create the Standard Folder Structure

After the project is created, run the following code in the R console:

dirs <- c(
  "data/raw",
  "data/sdtm",
  "data/adam",
  "programs/sdtm",
  "programs/adam",
  "metadata",
  "output",
  "logs"
)

for (d in dirs) {
  dir.create(d, recursive = TRUE)
}


This automatically creates the required directory structure.

Step 3 – Create Configuration File

Create a file named:

config.yml


Add the following content:

study_id: "STUDYXXX"

paths:
  raw: "data/raw"
  sdtm: "data/sdtm"
  adam: "data/adam"
  output: "output"


Save the file in the project root directory.

Step 4 – Create Execution Scripts

Create:

run_sdtm.R
run_adam.R


Example minimal run_sdtm.R:

library(yaml)

config <- yaml::read_yaml("config.yml")

cat("Running SDTM for:", config$study_id, "\n")

Step 5 – Add Modular Domain Scripts

Inside:

programs/sdtm/


Create a file such as:

dm.R


Example content:

derive_dm <- function(raw_dm, config) {
  raw_dm
}

Resulting Structure

After completing the steps above, the final structure should be:

template_study/
│
├── data/
│   ├── raw/
│   ├── sdtm/
│   └── adam/
├── programs/
│   ├── sdtm/
│   └── adam/
├── metadata/
├── output/
├── logs/
│
├── config.yml
├── run_sdtm.R
├── run_adam.R
└── template_study.Rproj

 Conclusion

This project demonstrates how clinical programming can adopt structured software engineering practices.

The focus is on:

Standardization

Reproducibility

Scalability

Clean organization

This template serves as a foundational framework for SDTM and ADaM development in R.
