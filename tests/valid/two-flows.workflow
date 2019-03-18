workflow "foo" {
	on = "push"
	resolves = "a"
}

workflow "bar" {
	on = "pull_request"
	resolves = [ "a", "b" ]
}

action "a" {
	uses="./x"
}

action "b" {
	uses="./y"
}

# ASSERT {
#   "result":       "success",
#   "numActions":   2,
#   "numWorkflows": 2
# }
