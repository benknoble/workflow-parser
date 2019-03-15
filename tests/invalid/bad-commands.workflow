action "a" { uses="./x" runs=42 }
action "b" { uses="./x" runs={} }
action "c" { uses="./x" runs="" }
action "d" { uses="./x" args=42 }
action "e" { uses="./x" args={} }

# ASSERT {
#   "result":       "failure",
#   "numActions":   5,
#   "numWorkflows": 0,
#   "errors":[
#     { "line": 1, "severity": "ERROR", "message": "expected string, got number" },
#     { "line": 1, "severity": "ERROR", "message": "the `runs' attribute must be a string or a list" },
#     { "line": 2, "severity": "ERROR", "message": "expected string, got object" },
#     { "line": 2, "severity": "ERROR", "message": "the `runs' attribute must be a string or a list" },
#     { "line": 3, "severity": "ERROR", "message": "`runs' value in action `c' cannot be blank" },
#     { "line": 4, "severity": "ERROR", "message": "expected string, got number" },
#     { "line": 4, "severity": "ERROR", "message": "the `args' attribute must be a string or a list" },
#     { "line": 5, "severity": "ERROR", "message": "expected string, got object" },
#     { "line": 5, "severity": "ERROR", "message": "the `args' attribute must be a string or a list" }
#   ]
# }
