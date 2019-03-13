workflow "on push" {
	on = "push"
	resolves = "go-ci"
}

action "go-ci" {
	uses = "cedrickring/golang-action@25af2baab25bb2180c31398c7095b8999e34b15a"
}
