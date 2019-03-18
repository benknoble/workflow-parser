workflow "foo" {
	on = "push"
	resolves = "a"
}

action "a" {
	uses="./x"
}

# ASSERT {
#   "result":       "success",
#   "numActions":   1,
#   "numWorkflows": 1
# }
