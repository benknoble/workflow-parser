# Invalid file, because action `a` is redefined.

action "a" { uses="./x" }
action "a" { uses="./x" }

# ASSERT {
#   "result":       "failure",
#   "numActions":   2,
#   "numWorkflows": 0,
#   "errors":[
#     { "line": 4, "severity": "ERROR", "message": "identifier `a' redefined" }
#   ]
# }
