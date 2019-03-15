# Invalid file, because `uses` is required.

action "a" {}

# ASSERT {
#   "result":       "failure",
#   "numActions":   1,
#   "numWorkflows": 0,
#   "errors":[
#     { "line": 3, "severity": "ERROR", "message": "action `a' must have a `uses' attribute" }
#   ]
# }
