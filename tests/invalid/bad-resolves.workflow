workflow "foo" {
	on = "push"
	resolves = 42
}

action "a" {
	uses="./x"
}

# ASSERT {
#   "result":       "failure",
#   "numActions":   1,
#   "numWorkflows": 1,
#   "errors":[
#     { "line": 3, "severity": "ERROR", "message": "expected list, got number" },
#     { "line": 3, "severity": "ERROR", "message": "invalid format for `resolves' in workflow `foo', expected list of strings" }
#   ]
# }
