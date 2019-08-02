workflow "foo" {
	on=<<EOF
		push
	EOF
	resolves=["a"]
}

action "a" {
	uses=<<EOF
		./x
	EOF
	runs=<<EOF
		cmd;
		2;
		3
	EOF
	env={
		a="b"
		c=<<EOF
			foo
		EOF
	}
}
action "b" {
	uses=<<EOF
		./y
	EOF
	needs=["a"]
	args=<<EOF
		foo
		bar
		baz
	EOF
}

# ASSERT {
#   "result":       "success",
#   "numActions":   2,
#   "numWorkflows": 1
# }
