# Clinical SDTM Template (R-Based Framework)

## Overview

This repository contains a reusable SDTM/ADaM project template designed to standardize clinical programming structure using R.

The goal is to provide:

- Consistent folder organization
- Config-driven execution
- Modular domain programming
- Scalable multi-study design
- Reproducible workflow

This project does not contain clinical data. It demonstrates structural and architectural setup only.

## Project Structure

```
template_study/
│
├── data/
│   ├── raw/
│   ├── sdtm/
│   └── adam/
│
├── programs/
│   ├── sdtm/
│   └── adam/
│
├── metadata/
├── output/
├── logs/
│
├── config.yml
├── run_sdtm.R
├── run_adam.R
└── template_study.Rproj
```


## How to Create This Structure

Step-by-step instructions are available in:

**PROJECT_SETUP_DOCUMENTATION.md**

---

## Key Concepts Demonstrated

- Architecture-driven design
- Configuration-controlled execution
- Modular domain scripting
- Study-level scalability

---

## Intended Use

1. Copy the template
2. Rename project
3. Update config.yml
4. Execute run scripts

---

## Future Enhancements

- SDTM validation integration
- XPT export automation
- Define.xml integration
- Logging framework

