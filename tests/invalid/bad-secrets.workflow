action "a" {
	uses="./x"
	secrets={}
}

action "b" {
	uses="./x"
	secrets="foo"
}

action "c" {
	uses="./x"
	secrets=42
}

action "d" {
	uses="./x"
	secrets=[ "-", "^", "9", "a", "0_o", "o_0" ]
}

action "e" {
	uses="./x"
	env={x="foo"}
	secrets=["x"]
}

action "f" {
	uses="./x"
	secrets=["x", "y", "x"]
}

# ASSERT {
#   "result":       "failure",
#   "numActions":   6,
#   "numWorkflows": 0,
#   "errors":[
#     { "line": 3, "severity": "ERROR", "message": "expected list, got object" },
#     { "line": 8, "severity": "ERROR", "message": "expected list, got string" },
#     { "line": 13, "severity": "ERROR", "message": "expected list, got number" },
#     { "line": 18, "severity": "ERROR", "message": "environment variables and secrets must contain only a-z, a-z, 0-9, and _ characters, got `-'" },
#     { "line": 18, "severity": "ERROR", "message": "environment variables and secrets must contain only a-z, a-z, 0-9, and _ characters, got `^'" },
#     { "line": 18, "severity": "ERROR", "message": "environment variables and secrets must contain only a-z, a-z, 0-9, and _ characters, got `9'" },
#     { "line": 18, "severity": "ERROR", "message": "environment variables and secrets must contain only a-z, a-z, 0-9, and _ characters, got `0_o'" },
#     { "line": 24, "severity": "ERROR", "message": "secret `x' conflicts with an environment variable with the same name" },
#     { "line": 29, "severity": "ERROR", "message": "secret `x' redefined" }
#   ]
# }
