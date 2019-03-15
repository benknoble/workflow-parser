"version"=42
action "a" { uses="./foo" }

# ASSERT {
#   "result":       "failure",
#   "numActions":   1,
#   "numWorkflows": 0,
#   "errors":[
#     { "line": 1, "severity": "ERROR", "message": "`version = 42` is not supported" }
#   ]
# }
