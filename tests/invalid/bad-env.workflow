# Invalid file, because `env` is the wrong type or has bad key names.

action "a" {
	uses="./x"
	env=[]
}

action "b" {
	uses="./x"
	env="foo"
}

action "c" {
	uses="./x"
	env=42
}

action "d" {
	uses="./x"
	env=12.34
}

action "e" {
	uses="./x"
	env={
		"x"="foo"
		"^"="bar"
		a_="baz"
	}
}
action "f" {
	uses="./y"
	env={
		a.="qux"
	}
}
action "g" {
	uses="./x"
	env={
		x="foo"
		x="bar"
	}
}

# ASSERT {
#   "result":       "failure",
#   "numActions":   7,
#   "numWorkflows": 0,
#   "errors":[
#     { "line": 5, "severity": "ERROR", "message": "expected object, got list" },
#     { "line": 10, "severity": "ERROR", "message": "expected object, got string" },
#     { "line": 15, "severity": "ERROR", "message": "expected object, got number" },
#     { "line": 20, "severity": "ERROR", "message": "expected object, got float" },
#     { "line": 25, "severity": "ERROR", "message": "environment variables and secrets must contain only a-z, a-z, 0-9, and _ characters, got `^'" },
#     { "line": 33, "severity": "ERROR", "message": "environment variables and secrets must contain only a-z, a-z, 0-9, and _ characters, got `a.'" },
#     { "line": 39, "severity": "ERROR", "message": "environment variable `x' redefined" }
#   ]
# }
