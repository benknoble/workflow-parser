# Invalid file, because `runs` is the wrong type or redefined.

action "a" { uses="./x" runs=42 }
action "b" { uses="./x" runs={} }
action "c" { uses="./x" runs="" }
action "d" { uses="./x" args=42 }
action "e" { uses="./x" args={} }
action "f" { uses="./x" runs="x" runs="y" }
action "g" { uses="./x" args="x" args="y" }
action "h" { uses="./x" runs="x" runs=17 }

# ASSERT {
#   "result":       "failure",
#   "numActions":   8,
#   "numWorkflows": 0,
#   "errors":[
#     { "line": 3, "severity": "ERROR", "message": "expected string, got number" },
#     { "line": 3, "severity": "ERROR", "message": "the `runs' attribute must be a string or a list" },
#     { "line": 4, "severity": "ERROR", "message": "expected string, got object" },
#     { "line": 4, "severity": "ERROR", "message": "the `runs' attribute must be a string or a list" },
#     { "line": 5, "severity": "ERROR", "message": "`runs' value in action `c' cannot be blank" },
#     { "line": 6, "severity": "ERROR", "message": "expected string, got number" },
#     { "line": 6, "severity": "ERROR", "message": "the `args' attribute must be a string or a list" },
#     { "line": 7, "severity": "ERROR", "message": "expected string, got object" },
#     { "line": 7, "severity": "ERROR", "message": "the `args' attribute must be a string or a list" },
#     { "line": 8, "severity": "ERROR", "message": "`runs' redefined in action `f'" },
#     { "line": 9, "severity": "ERROR", "message": "`args' redefined in action `g'" },
#     { "line": 10, "severity": "ERROR", "message": "`runs' redefined in action `h'" },
#     { "line": 10, "severity": "ERROR", "message": "expected string, got number" },
#     { "line": 10, "severity": "ERROR", "message": "the `runs' attribute must be a string or a list" }
#   ]
# }
