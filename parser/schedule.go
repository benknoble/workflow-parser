package parser

import (
	"regexp"
)

var scheduleRegex = regexp.MustCompile(`\Aschedule\([^)]*\)\z`)

func IsSchedule(onString string) bool {
	return scheduleRegex.MatchString(onString)
}

