version=0
action "a" { uses="./foo" }

# ASSERT {
#   "result":       "success",
#   "numActions":   1,
#   "numWorkflows": 0
# }
