workflow "foo" {
	on = "push"
	resolves = ["a", "b", "c", "d", "e"]
}

# commas on none
action "a" {
	uses="./x"
	env={
		FOO="1",
		BAR="2",
		BAZ="3",
	}
}

# commas on all
action "b" {
	uses="./x"
	env={
		FOO="1",
		BAR="2",
		BAZ="3",
	}
}

# commas on all but the last
action "c" {
	uses="./x"
	env={
		FOO="1",
		BAR="2",
		BAZ="3"
	}
}

# commas on some plus last
action "d" {
	uses="./x"
	env={
		FOO="1",
		BAR="2"
		BAZ="3",
	}
}

# commas on some but not last
action "e" {
	uses="./x"
	env={
		FOO="1"
		BAR="2",
		BAZ="3"
	}
}

# ASSERT {
#   "result":       "success",
#   "numActions":   5,
#   "numWorkflows": 1
# }
