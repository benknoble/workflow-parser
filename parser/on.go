package parser

func isValidOn(on string) bool {
	if IsSchedule(on) {
		return true
	} else {
		return isAllowedEventType(on)
	}
}