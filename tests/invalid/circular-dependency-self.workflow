# Invalid file, because `a` depends on itself

action "a" {
	uses="./x"
	needs=["a"]
}

# ASSERT {
#   "result":       "failure",
#   "numActions":   1,
#   "numWorkflows": 0,
#   "errors":[
#     { "line": 5, "severity": "FATAL", "message": "circular dependency" }
#   ]
# }
