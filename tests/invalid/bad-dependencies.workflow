# Invalid file, because `needs` is the wrong type or points to nonexistent
# actions.

action "a" {
	uses="./x"
	needs=["z"]
}

action "b" {
	uses="./x"
	needs=42
}

action "c" {
	uses="./x"
	needs={}
}

# ASSERT {
#   "result":       "failure",
#   "numActions":   3,
#   "numWorkflows": 0,
#   "errors":[
#     { "line": 6, "severity": "ERROR", "message": "action `a' needs nonexistent action `z'" },
#     { "line": 11, "severity": "ERROR", "message": "expected list or string, got number" },
#     { "line": 16, "severity": "ERROR", "message": "expected list, got object" }
#   ]
# }
