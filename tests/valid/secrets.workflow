action "a" {
	uses="./a"
	secrets=["A", "B", "C", "D", "E"]
}

action "b" {
	uses="./b"
	secrets=["D", "E", "F", "G", "H", "I", "J", "K"]
}

# ASSERT {
#   "result":       "success",
#   "numActions":   2,
#   "numWorkflows": 0
# }
