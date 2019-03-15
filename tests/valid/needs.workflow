action "a" {
	uses="./w"
	needs="b"
}

action "b" {
	uses="./x"
	needs=["c", "d"]
}

action "c" {
	uses="./y"
}

action "d" {
	uses="./y"
}

# ASSERT {
#   "result":       "success",
#   "numActions":   4,
#   "numWorkflows": 0
# }
