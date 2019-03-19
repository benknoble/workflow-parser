# Invalid file, because action `b` is undefined.

workflow "foo" {
	on = "push"
	resolves = ["a", "b"]
}

action "a" {
	uses="./x"
}

# ASSERT {
#   "result":       "failure",
#   "numActions":   1,
#   "numWorkflows": 1,
#   "errors":[
#     { "line": 5, "severity": "ERROR", "message": "workflow `foo' resolves unknown action `b'" }
#   ]
# }
