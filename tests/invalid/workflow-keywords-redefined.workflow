workflow "a" {
	on="push"
	on="push"
	resolves=["c"]
}

workflow "b" {
	on="push"
	resolves=["b"]
	resolves=["c"]
}

# ASSERT {
#   "result":       "failure",
#   "numActions":   0,
#   "numWorkflows": 2,
#   "errors":[
#     { "line": 3, "severity": "ERROR", "message": "`on' redefined in workflow `a'" },
#     { "line": 4, "severity": "ERROR", "message": "workflow `a' resolves unknown action `c'" },
#     { "line": 10, "severity": "ERROR", "message": "`resolves' redefined in workflow `b'" },
#     { "line": 10, "severity": "ERROR", "message": "workflow `b' resolves unknown action `c'" }
#   ]
# }
