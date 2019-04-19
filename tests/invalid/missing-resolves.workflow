# Invalid file, because action `resolves` is the wrong type or missing.

workflow "a" {
	on = "push"
}

workflow "b" {
	resolves = "d"
}

workflow "c" {
	resolves = 42
}

# ASSERT {
#   "result":       "failure",
#   "numActions":   0,
#   "numWorkflows": 3,
#   "errors":[
#     { "line": 7, "severity": "ERROR", "message": "workflow `b' must have an `on' attribute" },
#     { "line": 8, "severity": "ERROR", "message": "workflow `b' resolves unknown action `d'" },
#     { "line": 11, "severity": "ERROR", "message": "workflow `c' must have an `on' attribute" },
#     { "line": 12, "severity": "ERROR", "message": "expected list or string, got number" },
#     { "line": 12, "severity": "ERROR", "message": "invalid format for `resolves' in workflow `c', expected list of strings" }
#   ]
# }
