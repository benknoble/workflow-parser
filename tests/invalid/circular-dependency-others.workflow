# Invalid file, because there are circular dependencies

// simple cycle: a -> b -> a
action "a" { uses="./x" needs=["b", "g"] }
action "b" { uses="./x" needs=["a", "f"] }

// three-node cycle with unrelated lead-in: z -> c -> e -> d -> c
action "z" { uses="./x" needs="c" }
action "c" { uses="./x" needs=["e"] }
action "d" { uses="./x" needs="c" }
action "e" { uses="./x" needs=["d"] }

// two-hop cycle overlapping the first one: b -> f -> b
action "f" { uses="./x" needs="b" }

// two-hop cycle overlapping the first one: a -> g -> a
action "g" { uses="./x" needs=["a", "i"] }

// one-hop (self) cycle: h -> h
action "h" { uses="./x" needs="h" }

// cycle that reuses a reported edge: a -> g -> i -> a
action "i" { uses="./x" needs="a" }

# Each unique cycle should be reported exactly once, at the first point
# (reading top to bottom, left to right) that the cycle is apparent to the
# parser.

# ASSERT {
#   "result":       "failure",
#   "numActions":   10,
#   "numWorkflows": 0,
#   "errors":[
#     { "line": 5,  "severity": "FATAL", "message": "circular dependency on `a'" },
#     { "line": 10, "severity": "FATAL", "message": "circular dependency on `c'" },
#     { "line": 14, "severity": "FATAL", "message": "circular dependency on `b'" },
#     { "line": 17, "severity": "FATAL", "message": "circular dependency on `a'" },
#     { "line": 20, "severity": "FATAL", "message": "circular dependency on `h'" },
#     { "line": 23, "severity": "FATAL", "message": "circular dependency on `a'" }
#   ]
# }
