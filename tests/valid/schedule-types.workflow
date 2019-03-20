action "a" {
	uses="./x"
}

workflow "b" {
	on = "schedule(* * * * * *)"
	resolves = "a"
}

workflow "c" {
	on = "schedule(0 0 15 */3 *)"
	resolves = "a"
}

workflow "d" {
	on = "schedule(@daily)"
	resolves = "a"
}

workflow "e" {
	on = "schedule(@every 1h30m)"
	resolves = "a"
}

# ASSERT {
#   "result":       "success",
#   "numActions":   1,
#   "numWorkflows": 4
# }
