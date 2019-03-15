# Invalid file, because there is a missing block.

action "foo"

# ASSERT {
#   "result":       "failure",
#   "numActions":   0,
#   "numWorkflows": 0,
#   "errors":[
#     { "severity": "FATAL", "message": "expected start of object ('{') or assignment ('=')" }
#   ]
# }
