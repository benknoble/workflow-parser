package parser

func isValidOn(on string) bool {
	if isSchedule(on) {
		return true
	} else {
		return isAllowedEventType(on)
	}
}