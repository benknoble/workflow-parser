# Invalid file, full of things that are legal in HCL but not in .workflow
# files.

action "a" "b" { }
hello "a" { }
action "" { }
action "b" { uses { } }
action "c" { uses="./foo" }

# ASSERT {
#   "result":       "failure",
#   "numActions":   2,
#   "numWorkflows": 0,
#   "errors":[
#     { "line": 4, "severity": "ERROR", "message": "invalid toplevel declaration" },
#     { "line": 5, "severity": "ERROR", "message": "invalid toplevel keyword" },
#     { "line": 6, "severity": "ERROR", "message": "invalid format for identifier" },
#     { "line": 7, "severity": "ERROR", "message": "each attribute of action `b' must be an assignment" },
#     { "line": 7, "severity": "ERROR", "message": "expected string, got object" },
#     { "line": 7, "severity": "ERROR", "message": "action `b' must have a `uses' attribute" }
#   ]
# }
