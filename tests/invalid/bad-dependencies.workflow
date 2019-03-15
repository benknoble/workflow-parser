action "a" {
	uses="./x"
	needs=["z"]
}

action "b" {
	uses="./x"
	needs=42
}

# ASSERT {
#   "result":       "failure",
#   "numActions":   2,
#   "numWorkflows": 0,
#   "errors":[
#     { "line": 3, "severity": "ERROR", "message": "action `a' needs nonexistent action `z'" },
#     { "line": 8, "severity": "ERROR", "message": "expected list, got number" }
#   ]
# }
