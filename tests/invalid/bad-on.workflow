workflow "foo" {
	on = "hsup"
	resolves = "a"
	on = 42
}

action "a" {
	uses="./x"
}

# ASSERT {
#   "result":       "failure",
#   "numActions":   1,
#   "numWorkflows": 1,
#   "errors":[
#     { "line": 2, "severity": "ERROR", "message": "workflow `foo' has unknown `on' value `hsup'" },
#     { "line": 4, "severity": "ERROR", "message": "`on' redefined in workflow `foo'" },
#     { "line": 4, "severity": "ERROR", "message": "expected string, got number" },
#     { "line": 4, "severity": "ERROR", "message": "invalid format for `on' in workflow `foo', expected string" }
#   ]
# }
