library(yaml)

config <- yaml::read_yaml("config.yml")

print(config$study_id)
print(config$paths$raw)