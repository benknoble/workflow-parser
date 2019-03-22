# Invalid file, full of things that are legal in HCL but not in .workflow
# files.  The Go parser currently allows all of these.

"action" "d" {}
action "e" { "uses"="./x" }
action "f" { env={"FOO"="BAR"} }


# ASSERT {
#   "result":       "failure",
#   "numActions":   2,
#   "numWorkflows": 0,
#   "errors":[
#     { "line": 4, "severity": "ERROR", "message": "expected identifier, got string" },
#     { "line": 5, "severity": "ERROR", "message": "expected identifier, got string" },
#     { "line": 6, "severity": "ERROR", "message": "expected identifier, got string" }
#   ]
# }
