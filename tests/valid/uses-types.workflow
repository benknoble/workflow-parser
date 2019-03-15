action "a" {
	uses="foo/bar@dev"
}

action "b" {
	uses="foo/bar/path@1.0.0"
}

action "c" {
	uses="./xyz"
}

action "d" {
	uses="./"
}

action "e" {
	uses="docker://alpine"
}

# ASSERT {
#   "result":       "success",
#   "numActions":   5,
#   "numWorkflows": 0
# }
