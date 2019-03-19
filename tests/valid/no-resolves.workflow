workflow "foo" {
	on = "push"
}

# ASSERT {
#   "result":       "success",
#   "numActions":   0,
#   "numWorkflows": 1
# }
