# Invalid file, because it has an illegal character

this is definitely not valid HCL!

# ASSERT {
#   "result":       "failure",
#   "numActions":   0,
#   "numWorkflows": 0,
#   "errors":[
#     { "line": 3, "severity": "FATAL", "message": "illegal char" }
#   ]
# }
