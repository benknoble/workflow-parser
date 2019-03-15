# Invalid file, because `bananas` is not a valid attribute.

workflow "a" {
	on="push"
	bar="2"
}

action "b" {
	uses = "./x"
	bananas = "are the best"
}

# ASSERT {
#   "result":       "failure",
#   "numActions":   1,
#   "numWorkflows": 1,
#   "errors":[
#     { "line": 5, "severity": "WARN", "message": "unknown workflow attribute `bar'" },
#     { "line": 10, "severity": "WARN", "message": "unknown action attribute `bananas'" }
#   ]
# }
