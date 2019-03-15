# Invalid file, because a string is not terminated.

action "foo" { uses=" }

# ASSERT {
#   "result":       "failure",
#   "numActions":   0,
#   "numWorkflows": 0,
#   "errors":[
#     { "severity": "FATAL", "message": "literal not terminated" }
#   ]
# }
