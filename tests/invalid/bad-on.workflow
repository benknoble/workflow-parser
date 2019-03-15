# Invalid file, because `on` is redefined, assigned to the wrong type, and
# assigned to a non-existent event.

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
#     { "line": 5, "severity": "ERROR", "message": "workflow `foo' has unknown `on' value `hsup'" },
#     { "line": 7, "severity": "ERROR", "message": "`on' redefined in workflow `foo'" },
#     { "line": 7, "severity": "ERROR", "message": "expected string, got number" },
#     { "line": 7, "severity": "ERROR", "message": "invalid format for `on' in workflow `foo', expected string" }
#   ]
# }
