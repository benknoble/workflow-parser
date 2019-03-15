# Invalid file, because GITHUB_* variables are reserved.

action "a" {
	uses="./a"
	env={   # first error here
		GITHUB_FOO="nope"
		GITHUB_TOKEN="yup"
	}
}
action "b" {
	uses="./b"
	secrets = [   # second error here
		"GITHUB_BAR",
		"GITHUB_TOKEN"
	]
}

# ASSERT {
#   "result":       "failure",
#   "numActions":   2,
#   "numWorkflows": 0,
#   "errors":[
#     { "line": 5, "severity": "ERROR", "message": "environment variables and secrets beginning with `github_' are reserved" },
#     { "line": 12, "severity": "ERROR", "message": "environment variables and secrets beginning with `github_' are reserved" }
#   ]
# }
