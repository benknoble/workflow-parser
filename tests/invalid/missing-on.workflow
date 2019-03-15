workflow "foo" {
	resolves = "a"
}

workflow "bar" {
	on = 42
	resolves = "a"
}

action "a" {
	uses="./x"
}

# ASSERT {
#   "result":       "failure",
#   "numActions":   1,
#   "numWorkflows": 2,
#   "errors":[
#     { "line": 1, "severity": "ERROR", "message": "workflow `foo' must have an `on' attribute" },
#     { "line": 5, "severity": "ERROR", "message": "workflow `bar' must have an `on' attribute" },
#     { "line": 6, "severity": "ERROR", "message": "expected string, got number" },
#     { "line": 6, "severity": "ERROR", "message": "invalid format for `on' in workflow `bar'" }
#   ]
# }
