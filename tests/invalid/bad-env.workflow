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
#     { "line": 3, "severity": "ERROR", "message": "expected object, got list" },
#     { "line": 8, "severity": "ERROR", "message": "expected object, got string" },
#     { "line": 13, "severity": "ERROR", "message": "expected object, got number" },
#     { "line": 18, "severity": "ERROR", "message": "expected object, got float" },
#     { "line": 23, "severity": "ERROR", "message": "environment variables and secrets must contain only a-z, a-z, 0-9, and _ characters, got `^'" },
#     { "line": 31, "severity": "ERROR", "message": "environment variables and secrets must contain only a-z, a-z, 0-9, and _ characters, got `a.'" },
#     { "line": 37, "severity": "ERROR", "message": "environment variable `x' redefined" }
#   ]
# }
