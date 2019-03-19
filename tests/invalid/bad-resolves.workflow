# Invalid file, because `resolves` is redefined and assigned to the wrong
# type.

workflow "foo" {
	on = "push"
	resolves = 42
}

workflow "bar" {
	on = "push"
	resolves = "a"
	resolves = "b"
}

action "a" {
	uses="./x"
}

action "b" {
	uses="./x"
}

# ASSERT {
#   "result":       "failure",
#   "numActions":   2,
#   "numWorkflows": 2,
#   "errors":[
#     { "line": 6, "severity": "ERROR", "message": "expected list, got number" },
#     { "line": 6, "severity": "ERROR", "message": "invalid format for `resolves' in workflow `foo', expected list of strings" },
#     { "line": 12, "severity": "ERROR", "message": "`resolves' redefined in workflow `bar'" }
#   ]
# }
