action "a" {
	uses="./x"
	runs="a b c d"
}

action "b" {
	uses="./x"
	runs=["a", "b c", "d"]
}

action "c" {
	uses="./x"
	args="a b c d"
}

action "d" {
	uses="./x"
	args=["a", "b c", "d"]
}

action "e" {
	uses="./x"
	runs="a b c d"
	args="w x y z"
}

action "f" {
	uses="./x"
	runs=["a", "b c", "d"] args=["w", "x y", "z"]
}

action "g" {
	uses="./x"
	args=""  # blank args is OK
}

# ASSERT {
#   "result":       "success",
#   "numActions":   7,
#   "numWorkflows": 0
# }
