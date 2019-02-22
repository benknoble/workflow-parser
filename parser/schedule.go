package parser

import (
	"regexp"
)

var scheduleRegex = regexp.MustCompile(`\Aschedule\([^)]*\)\z`)

func isSchedule(onString string) bool {
	return scheduleRegex.MatchString(onString)
}

