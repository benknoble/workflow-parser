# Invalid file, because `uses` is the wrong type, redefined, or otherwise
# incorrect.

action "a" { uses="" }
action "b" { uses="foo" }
action "c" { uses="foo/bar" }
action "d" { uses="foo@bar" }
action "e" { uses={a="b"} }
action "f" { uses=["x"] }
action "g" { uses=42 }
action "h" { }
action "i" { uses="./x" uses="./x" }
action "j" { uses="./x" uses="./y" }

# ASSERT {
#   "result":       "failure",
#   "numActions":   10,
#   "numWorkflows": 0,
#   "errors":[
#     { "line": 4, "severity": "ERROR", "message": "`uses' value in action `a' cannot be blank" },
#     { "line": 5, "severity": "ERROR", "message": "the `uses' attribute must be a path, a docker image, or owner/repo@ref" },
#     { "line": 6, "severity": "ERROR", "message": "the `uses' attribute must be a path, a docker image, or owner/repo@ref" },
#     { "line": 7, "severity": "ERROR", "message": "the `uses' attribute must be a path, a docker image, or owner/repo@ref" },
#     { "line": 8, "severity": "ERROR", "message": "expected string, got object" },
#     { "line": 8, "severity": "ERROR", "message": "action `e' must have a `uses' attribute" },
#     { "line": 9, "severity": "ERROR", "message": "expected string, got list" },
#     { "line": 9, "severity": "ERROR", "message": "action `f' must have a `uses' attribute" },
#     { "line": 10, "severity": "ERROR", "message": "expected string, got number" },
#     { "line": 10, "severity": "ERROR", "message": "action `g' must have a `uses' attribute" },
#     { "line": 11, "severity": "ERROR", "message": "action `h' must have a `uses' attribute" },
#     { "line": 12, "severity": "ERROR", "message": "`uses' redefined in action `i'" },
#     { "line": 13, "severity": "ERROR", "message": "`uses' redefined in action `j'" }
#   ]
# }
