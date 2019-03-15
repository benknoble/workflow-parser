action "a" { uses="./foo" }
version=0

# ASSERT {
#   "result":       "failure",
#   "numActions":   1,
#   "numWorkflows": 0,
#   "errors":[
#     { "line": 2, "severity": "ERROR", "message": "`version` must be the first declaration" }
#   ]
# }
