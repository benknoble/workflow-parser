# Invalid file, because `bananas` is not a valid attribute.

action "a" {
	uses = "./x"
	bananas = "are the best"
}

# ASSERT {
#   "result":       "failure",
#   "numActions":   1,
#   "numWorkflows": 0,
#   "errors":[
#     { "line": 5, "severity": "WARN", "message": "unknown action attribute `bananas'" }
#   ]
# }
