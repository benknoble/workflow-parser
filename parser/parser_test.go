package parser

import (
	"encoding/json"
	"fmt"
	"io/ioutil"
	"regexp"
	"strings"
	"testing"

	"github.com/actions/workflow-parser/model"
	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/require"
)

func TestParseEmptyConfig(t *testing.T) {
	workflow, err := parseString("")
	assertParseSuccess(t, err, 0, 0, workflow)
	workflow, err = parseString("{}")
	assertParseSuccess(t, err, 0, 0, workflow)
}

func TestSeveritySuppression(t *testing.T) {
	fixture(t, "invalid/bad-attribute.workflow")
	fixture(t, "invalid/no-uses.workflow")
}

func TestActionsAndAttributes(t *testing.T) {
	workflow, _ := fixture(t, "valid/actions-and-attributes.workflow")

	actionA := workflow.Actions[0]
	assert.Equal(t, "a", actionA.Identifier)
	assert.Equal(t, 0, len(actionA.Needs))
	assert.Equal(t, &model.UsesPath{Path: "x"}, actionA.Uses)
	assert.Equal(t, &model.StringCommand{Value: "cmd"}, actionA.Runs)
	assert.Equal(t, map[string]string{"PATH": "less traveled by", "HOME": "where the heart is"}, actionA.Env)

	actionB := workflow.Actions[1]
	assert.Equal(t, "b", actionB.Identifier)
	assert.Equal(t, &model.UsesPath{Path: "y"}, actionB.Uses)
	assert.Equal(t, []string{"a"}, actionB.Needs)
	assert.Equal(t, &model.ListCommand{Values: []string{"foo", "bar"}}, actionB.Args)
	assert.Equal(t, []string{"THE", "CURRENCY", "OF", "INTIMACY"}, actionB.Secrets)
}

func TestStringEscaping(t *testing.T) {
	workflow, _ := fixture(t, "valid/escaping.workflow")
	assert.Equal(t, `./x " y \ z`, workflow.Actions[0].Uses.String())
}

func TestFileVersion0(t *testing.T) {
	fixture(t, "valid/version-0.workflow")
}

func TestFileVersion42(t *testing.T) {
	fixture(t, "invalid/version-42.workflow")
}

func TestFileVersionMustComeFirst(t *testing.T) {
	fixture(t, "invalid/version-must-come-first.workflow")
}

func TestUnscopedVariableNames(t *testing.T) {
	workflow, _ := fixture(t, "valid/no-interpolation.workflow")
	assert.Equal(t, []string{"${value}"}, workflow.Actions[0].Runs.Split())
}

func TestActionCollision(t *testing.T) {
	fixture(t, "invalid/action-collision.workflow")
}

func TestBadHCL(t *testing.T) {
	fixture(t, "invalid/bad-hcl-1.workflow")
	fixture(t, "invalid/bad-hcl-2.workflow")
	fixture(t, "invalid/bad-hcl-3.workflow")
	fixture(t, "invalid/bad-hcl-4.workflow")
	fixture(t, "invalid/bad-hcl-5.workflow")
}

func TestCircularDependencySelf(t *testing.T) {
	fixture(t, "invalid/circular-dependency-self.workflow")
}

func TestCircularDependencyOther(t *testing.T) {
	fixture(t, "invalid/circular-dependency-others.workflow")
}

func TestFlowMapping(t *testing.T) {
	workflow, _ := fixture(t, "valid/flow-mapping.workflow")
	assert.Equal(t, "push", workflow.Workflows[0].On)
	assert.ElementsMatch(t, []string{"a", "b"}, workflow.Workflows[0].Resolves)
}

func TestFlowOneResolve(t *testing.T) {
	workflow, _ := fixture(t, "valid/one-resolve.workflow")
	assert.Equal(t, "push", workflow.Workflows[0].On)
	assert.Len(t, workflow.Workflows[0].Resolves[0], 1)
	assert.Equal(t, "a", workflow.Workflows[0].Resolves[0])
}

func TestFlowNoResolves(t *testing.T) {
	workflow, _ := fixture(t, "valid/no-resolves.workflow")
	assert.Equal(t, "push", workflow.Workflows[0].On)
	assert.Len(t, workflow.Workflows[0].Resolves, 0)
	assert.Empty(t, workflow.Workflows[0].Resolves)
}

func TestUses(t *testing.T) {
	workflow, _ := fixture(t, "valid/uses-types.workflow")
	cases := []struct {
		Name string
		Uses model.Uses
	}{
		{Name: "a", Uses: &model.UsesRepository{Repository: "foo/bar", Ref: "dev"}},
		{Name: "b", Uses: &model.UsesRepository{Repository: "foo/bar", Path: "path", Ref: "1.0.0"}},
		{Name: "c", Uses: &model.UsesPath{Path: "xyz"}},
		{Name: "d", Uses: &model.UsesPath{Path: ""}},
		{Name: "e", Uses: &model.UsesDockerImage{Image: "alpine"}},
	}

	for _, tc := range cases {
		a := workflow.GetAction(tc.Name)
		if assert.NotNil(t, a) {
			assert.Equal(t, tc.Uses, a.Uses)
		}
	}
}

func TestUsesFailures(t *testing.T) {
	fixture(t, "invalid/bad-uses.workflow")
}

func TestGetCommand(t *testing.T) {
	workflow, _ := fixture(t, "valid/command-types.workflow")
	cases := []struct {
		Name       string
		Runs, Args model.Command
	}{
		{Name: "a", Runs: &model.StringCommand{Value: "a b c d"}},
		{Name: "b", Runs: &model.ListCommand{Values: []string{"a", "b c", "d"}}},
		{Name: "c", Args: &model.StringCommand{Value: "a b c d"}},
		{Name: "d", Args: &model.ListCommand{Values: []string{"a", "b c", "d"}}},
		{Name: "e", Runs: &model.StringCommand{Value: "a b c d"}, Args: &model.StringCommand{Value: "w x y z"}},
		{Name: "f", Runs: &model.ListCommand{Values: []string{"a", "b c", "d"}}, Args: &model.ListCommand{Values: []string{"w", "x y", "z"}}},
	}

	for _, tc := range cases {
		a := workflow.GetAction(tc.Name)
		if assert.NotNil(t, a) {
			assert.Equal(t, tc.Runs, a.Runs)
			assert.Equal(t, tc.Args, a.Args)
		}
	}
}

func TestGetCommandFailure(t *testing.T) {
	fixture(t, "invalid/bad-commands.workflow")
}

func TestBadEnv(t *testing.T) {
	_, err := fixture(t, "invalid/bad-env.workflow")
	pe := extractParserError(t, err)
	assert.Equal(t, "e", pe.Actions[4].Identifier)
	assert.Equal(t, 3, len(pe.Actions[4].Env))
	assert.Equal(t, "bar", pe.Actions[4].Env["^"])

	assert.Equal(t, "g", pe.Actions[6].Identifier)
	assert.Equal(t, map[string]string{"x": "bar"}, pe.Actions[6].Env)
}

func TestBadSecrets(t *testing.T) {
	_, err := fixture(t, "invalid/bad-secrets.workflow")
	pe := extractParserError(t, err)
	assert.Equal(t, "d", pe.Actions[3].Identifier)
	assert.Equal(t, []string{"-", "^", "9", "a", "0_o", "o_0"}, pe.Actions[3].Secrets)

	assert.Equal(t, "e", pe.Actions[4].Identifier)
	assert.Equal(t, map[string]string{"x": "foo"}, pe.Actions[4].Env)
	assert.Equal(t, []string{"x"}, pe.Actions[4].Secrets)

	assert.Equal(t, "f", pe.Actions[5].Identifier)
	assert.Equal(t, []string{"x", "y", "x"}, pe.Actions[5].Secrets)
}

func TestUsesCustomActionsTransformed(t *testing.T) {
	workflow, err := parseString(`action "a" { uses="./foo" }`)
	assertParseSuccess(t, err, 1, 0, workflow)
	action := workflow.GetAction("a")
	require.NotNil(t, action)
	require.Equal(t, &model.UsesPath{Path: "foo"}, action.Uses)
}

func TestUsesCustomActionsShortPath(t *testing.T) {
	workflow, err := parseString(`action "a" { uses="./" }`)
	assertParseSuccess(t, err, 1, 0, workflow)
	action := workflow.GetAction("a")
	require.NotNil(t, action)
	require.Equal(t, &model.UsesPath{}, action.Uses)
}

func TestTwoFlows(t *testing.T) {
	workflow, _ := fixture(t, "valid/two-flows.workflow")

	assert.Equal(t, "push", workflow.Workflows[0].On)
	assert.Len(t, workflow.Workflows[0].Resolves[0], 1)
	assert.Equal(t, []string{"a"}, workflow.Workflows[0].Resolves)
	assert.Len(t, workflow.GetWorkflows("push"), 1)

	assert.Equal(t, "pull_request", workflow.Workflows[1].On)
	assert.Len(t, workflow.Workflows[1].Resolves[0], 1)
	assert.Equal(t, []string{"a","b"}, workflow.Workflows[1].Resolves)
	assert.Len(t, workflow.GetWorkflows("pull_request"), 1)

	assert.Len(t, workflow.GetWorkflows("blah"), 0)
}

func TestNeeds(t *testing.T) {
	workflow, _ := fixture(t, "valid/needs.workflow")
	needsValues := workflow.Actions[0].Needs
	assert.Equal(t, []string{"b"}, needsValues)
	needsValues = workflow.Actions[1].Needs
	assert.Equal(t, []string{"c", "d"}, needsValues)
	needsValues = workflow.Actions[2].Needs
	assert.Equal(t, 0, len(needsValues))
}

func TestFlowMissingOn(t *testing.T) {
	fixture(t, "invalid/missing-on.workflow")
}

func TestFlowOnUnexpectedValue(t *testing.T) {
	workflow, err := parseString(`
		workflow "foo" {
			on = "hsup"
			resolves = "a"
			on = 42
		}
		action "a" {
			uses="./x"
		}`)
	assertParseError(t, err, 1, 1, workflow,
		"line 3: workflow `foo' has unknown `on' value `hsup'",
		"line 5: `on' redefined in workflow `foo'",
		"line 5: expected string, got number",
		"line 5: invalid format for `on' in workflow `foo', expected string")
	pe := extractParserError(t, err)
	assert.Equal(t, "hsup", pe.Workflows[0].On)
}

func TestFlowResolvesTypeError(t *testing.T) {
	workflow, err := parseString(`workflow "foo" { on = "push" resolves = 42 } action "a" { uses="./x" }`)
	assertParseError(t, err, 1, 1, workflow,
		"expected list, got number",
		"invalid format for `resolves' in workflow `foo', expected list of strings")
}

func TestFlowMissingAction(t *testing.T) {
	workflow, err := parseString(`workflow "foo" { on = "push" resolves = ["a", "b"] } action "a" { uses="./x" }`)
	assertParseError(t, err, 1, 1, workflow, "workflow `foo' resolves unknown action `b'")
}

func TestUsesMissingCheck(t *testing.T) {
	workflow, err := parseString(`action "a" { }`)
	assertParseError(t, err, 1, 0, workflow, "action `a' must have a `uses' attribute")
}

func TestUsesAttributeBlankCheck(t *testing.T) {
	workflow, err := parseString(`action "a" { uses="" }`)
	assertParseError(t, err, 1, 0, workflow,
		"`uses' value in action `a' cannot be blank")
}

func TestUsesDuplicatesCheck(t *testing.T) {
	workflow, err := parseString(`action "a" { uses="./x" uses="./y" }`)
	assertParseError(t, err, 1, 0, workflow, "`uses' redefined in action `a'")
}

func TestCommandDuplicatesCheck(t *testing.T) {
	workflow, err := parseString(`action "a" { uses="./x" runs="x" runs="y" }`)
	assertParseError(t, err, 1, 0, workflow, "`runs' redefined in action `a'")
	if pe, ok := err.(*Error); ok {
		require.Equal(t, &model.StringCommand{Value: "y"}, pe.Actions[0].Runs)
	}
	workflow, err = parseString(`action "a" { uses="./x" args="x" args="y" }`)
	assertParseError(t, err, 1, 0, workflow, "`args' redefined in action `a'")
	if pe, ok := err.(*Error); ok {
		require.Equal(t, &model.StringCommand{Value: "y"}, pe.Actions[0].Args)
	}
	workflow, err = parseString(`action "a" { uses="./x" runs="x" runs=17 }`)
	assertParseError(t, err, 1, 0, workflow,
		"`runs' redefined in action `a'",
		"expected string, got number",
		"the `runs' attribute must be a string or a list")
	if pe, ok := err.(*Error); ok {
		require.Equal(t, &model.StringCommand{Value: "x"}, pe.Actions[0].Runs)
	}
}

func TestFlowKeywordsRedefined(t *testing.T) {
	workflow, err := parseString(`workflow "a" { on="push" on="push" resolves=["c"] }`)
	assertParseError(t, err, 0, 1, workflow,
		"`on' redefined in workflow `a'",
		"resolves unknown action `c'")
	workflow, err = parseString(`workflow "a" { on="push" resolves=["b"] resolves=["c"] }`)
	assertParseError(t, err, 0, 1, workflow,
		"`resolves' redefined in workflow `a'",
		"resolves unknown action `c'")
}

func TestNonExistentExplicitDependency(t *testing.T) {
	workflow, err := parseString(`action "a" { uses="./x" needs=["b"] }`)
	assertParseError(t, err, 1, 0, workflow, "action `a' needs nonexistent action `b'")
}

func TestBadDependenciesList(t *testing.T) {
	workflow, err := parseString(`action "a" { uses="./x" needs=42 }`)
	assertParseError(t, err, 1, 0, workflow, "expected list, got number")
}

func TestActionExtraKeywords(t *testing.T) {
	workflow, err := parseString(`action "a" "b" { }`)
	assertParseError(t, err, 0, 0, workflow, "invalid toplevel declaration")
}

func TestInvalidKeyword(t *testing.T) {
	workflow, err := parseString(`hello "a" { }`)
	assertParseError(t, err, 0, 0, workflow, "invalid toplevel keyword")
}

func TestInvalidActionIdentifier(t *testing.T) {
	workflow, err := parseString(`action "" { }`)
	assertParseError(t, err, 0, 0, workflow, "invalid format for identifier")
}

func TestInvalidAttribute(t *testing.T) {
	workflow, err := parseString(`action "a" { uses { } }`)
	assertParseError(t, err, 1, 0, workflow,
		"each attribute of action `a' must be an assignment",
		"expected string, got object",
		"action `a' must have a `uses' attribute")
}

func TestContinueAfterBadAssignment(t *testing.T) {
	workflow, err := parseString(`action "a" { uses { } } action "b" { uses="./foo" }`)
	assertParseError(t, err, 2, 0, workflow,
		"each attribute of action `a' must be an assignment",
		"expected string, got object",
		"action `a' must have a `uses' attribute")
	require.Nil(t, workflow)
	pe := extractParserError(t, err)
	require.Equal(t, 2, len(pe.Actions))
	assert.Equal(t, "a", pe.Actions[0].Identifier)
	assert.Equal(t, "b", pe.Actions[1].Identifier)
}

func TestTooManySecrets(t *testing.T) {
	workflow, err := parseString(`
		action "a" { uses="./a" secrets=["A", "B", "C", "D", "E", "F", "G", "H", "I", "J"] }
	`)
	assertParseSuccess(t, err, 1, 0, workflow)
	require.NotNil(t, workflow)
	assert.Equal(t, 10, len(workflow.Actions[0].Secrets))

	workflow, err = parseString(`
		action "a" { uses="./a" secrets=["A", "B", "C", "D", "E"] }
		action "b" { uses="./b" secrets=["D", "E", "F", "G", "H", "I", "J"] }
	`)
	assertParseSuccess(t, err, 2, 0, workflow)
	require.NotNil(t, workflow)
	assert.Equal(t, 5, len(workflow.Actions[0].Secrets))
	assert.Equal(t, 7, len(workflow.Actions[1].Secrets))

	workflow, err = parseString(`
		action "a" { uses="./a" secrets=["S1", "S2", "S3", "S4", "S5", "S6", "S7", "S8", "S9", "S10", "S11", "S12", "S13", "S14", "S15", "S16", "S17", "S18", "S19", "S20", "S21", "S22", "S23", "S24", "S25", "S26", "S27", "S28", "S29", "S30", "S31", "S32", "S33", "S34", "S35", "S36", "S37", "S38", "S39", "S40"] }
		action "b" { uses="./b" secrets=["S35", "S36", "S37", "S38", "S39", "S40", "S41", "S42", "S43", "S44", "S45", "S46", "S47", "S48", "S49", "S50", "S51", "S52", "S53", "S54", "S55", "S56", "S57", "S58", "S59", "S60", "S61", "S62", "S63", "S64", "S65", "S66", "S67", "S68", "S69", "S70", "S71", "S72", "S73", "S74", "S75", "S76", "S77", "S78", "S79", "S80", "S81", "S82", "S83", "S84", "S85", "S86", "S87", "S88", "S89", "S90", "S91", "S92", "S93", "S94", "S95", "S96", "S97", "S98", "S99", "S100", "S101"] }
		action "c" { uses="./b" secrets=["S90", "S91", "S92", "S93", "S94", "S95", "S96", "S97", "S98", "S99", "S100", "S101", "S102", "S103", "S104", "S105", "S106", "S107", "S108", "S109", "S110"] }
	`)
	assertParseError(t, err, 3, 0, workflow, "all actions combined must not have more than 100 unique secrets")
}

func TestUnknownAttributes(t *testing.T) {
	workflow, err := parseString(`action "a" { uses="./a" foo="1" } workflow "b" { on="push" bar="2" }`)
	assertParseError(t, err, 1, 1, workflow,
		"unknown action attribute `foo'",
		"unknown workflow attribute `bar'")
}

func TestReservedVariables(t *testing.T) {
	workflow, err := parseString(`
		action "a" {
			uses="./a"
			env={
				GITHUB_FOO="nope"
				GITHUB_TOKEN="yup"
			}
		}
		action "b" {
			uses="./b"
			secrets = [
				"GITHUB_BAR",
				"GITHUB_TOKEN"
			]
		}
	`)
	assertParseError(t, err, 2, 0, workflow,
		// the `env=` line in `a`
		"line 4: environment variables and secrets beginning with `github_' are reserved",
		// the `secrets=` line in `b`
		"line 11: environment variables and secrets beginning with `github_' are reserved")
	pe := extractParserError(t, err)
	assert.Equal(t, "nope", pe.Actions[0].Env["GITHUB_FOO"])
	assert.Equal(t, "yup", pe.Actions[0].Env["GITHUB_TOKEN"])
	assert.Equal(t, []string{"GITHUB_BAR", "GITHUB_TOKEN"}, pe.Actions[1].Secrets)
}

func TestUsesForm(t *testing.T) {
	cases := []struct {
		action   string
		expected model.Uses
	}{
		{
			action:   `action "a" { uses = "docker://alpine" }`,
			expected: &model.UsesDockerImage{},
		},
		{
			action:   `action "a" { uses = "./actions/foo" }`,
			expected: &model.UsesPath{},
		},
		{
			action:   `action "a" { uses = "name/owner/path@5678ac" }`,
			expected: &model.UsesRepository{},
		},
		{
			action:   `action "a" { uses = "name/owner@5678ac" }`,
			expected: &model.UsesRepository{},
		},
		{
			action:   `action "a" { uses = "" }`,
			expected: &model.UsesInvalid{},
		},
		{
			action:   `action "a" { uses = "foo@" }`,
			expected: &model.UsesInvalid{},
		},
		{
			action:   `action "a" { uses = "foo" }`,
			expected: &model.UsesInvalid{},
		},
	}

	for _, tc := range cases {
		workflow, err := Parse(strings.NewReader(tc.action), WithSuppressErrors())
		require.NoError(t, err)
		assert.IsType(t, tc.expected, workflow.Actions[0].Uses)
	}
}

func TestMultilineErrors(t *testing.T) {
	_, err := parseString(`
		workflow "a" {
			on = 17        # three errors
			resolves = "b"
		}
		action "b" {
			uses="c"       # one error
		}
	`)
	require.Error(t, err)
	expect := "unable to parse and validate\n" +
		"  Line 2: Workflow `a' must have an `on' attribute\n" +
		"  Line 3: Expected string, got number\n" +
		"  Line 3: Invalid format for `on' in workflow `a', expected string\n" +
		"  Line 7: The `uses' attribute must be a path, a Docker image, or owner/repo@ref"
	assert.Equal(t, expect, err.Error())

	require.IsType(t, &Error{}, err)
	pe := err.(*Error)
	assert.Len(t, pe.Errors, 4)
}

/********** helpers **********/

func assertParseSuccess(t *testing.T, err error, nactions int, nflows int, workflow *model.Configuration) {
	assert.NoError(t, err)
	require.NotNil(t, workflow)

	assert.Equal(t, nactions, len(workflow.Actions), "actions")
	assert.Equal(t, nflows, len(workflow.Workflows), "workflows")
}

func assertParseError(t *testing.T, err error, nactions int, nflows int, workflow *model.Configuration, errors ...string) {
	require.Error(t, err)
	assert.Nil(t, workflow)

	if pe, ok := err.(*Error); ok {
		assert.Equal(t, nactions, len(pe.Actions), "actions")
		assert.Equal(t, nflows, len(pe.Workflows), "workflows")

		if len(pe.Errors) > 0 {
			t.Log("Actual errors:  ", pe.Errors)
		}
		for _, e := range pe.Errors {
			assert.NotEqual(t, 0, e.Pos.Line, "error position not set")
		}
		assert.Equal(t, len(errors), len(pe.Errors), "errors")
		for i := range errors {
			if i >= len(pe.Errors) {
				break
			}
			assert.Contains(t, strings.ToLower(pe.Errors[i].Error()), errors[i])
		}

		return
	}

	assert.Fail(t, "expected parser error, but got %T", err)
}

func assertSyntaxError(t *testing.T, err error, workflow *model.Configuration, errMsg string) {
	assert.Error(t, err)
	require.Nil(t, workflow)

	if pe, ok := err.(*Error); ok {
		assert.Nil(t, pe.Actions)
		assert.Nil(t, pe.Workflows)
		require.Len(t, pe.Errors, 1, "syntax errors should yield only one error")
		se := pe.Errors[0]
		assert.NotEqual(t, 0, se.Pos.Line, "error position not set")
		assert.Contains(t, strings.ToLower(se.Error()), errMsg)
		return
	}

	assert.Fail(t, "expected parser error, but got %T", err)
}

func parseString(workflowFile string, options ...OptionFunc) (*model.Configuration, error) {
	return Parse(strings.NewReader(workflowFile), options...)
}

func extractParserError(t *testing.T, err error) *Error {
	if pe, ok := err.(*Error); ok {
		return pe
	}

	require.Fail(t, "expected parser error, but got %T", err)
	return nil
}

type parseErrorExpectation struct {
	Line     int
	Severity string
	Message  string
}

type parseExpectation struct {
	Result       string
	NumActions   int
	NumWorkflows int
	Errors       []parseErrorExpectation
}

var assertStartRegexp = regexp.MustCompile(`^#\s*ASSERT\s*{\s*$`)
var assertEndRegexp = regexp.MustCompile(`^#\s*}`)

func parseAssertions(t *testing.T, str string) []parseExpectation {
	var current string
	var ret []parseExpectation
	for _, line := range strings.Split(str, "\n") {
		if !strings.HasPrefix(line, "#") {
			continue
		}
		if current == "" {
			if assertStartRegexp.MatchString(line) {
				current = "{"
			}
		} else {
			current += line[1:]
			if assertEndRegexp.MatchString(line) {
				t.Log("JSON:", current)
				var pe parseExpectation
				err := json.Unmarshal([]byte(current), &pe)
				t.Log(pe)
				require.NoError(t, err)
				ret = append(ret, pe)
				current = ""
			}
		}
	}

	return ret
}

func fixture(t *testing.T, filename string) (*model.Configuration, error) {
	t.Logf("Fixture: %s", filename)
	bytes, err := ioutil.ReadFile("../tests/" + filename)
	require.NoError(t, err)

	type suppressionLevel struct {
		ignore string
		args   []OptionFunc
	}
	levels := []suppressionLevel{
		{"WARN|ERROR", []OptionFunc{WithSuppressErrors()}},
		{"WARN", []OptionFunc{WithSuppressWarnings()}},
		// "" should be last, so fixture() can return the non-suppressed workflow
		{"", nil},
	}

	str := string(bytes)
	assertions := parseAssertions(t, str)
	assert.True(t, len(assertions) > 0)

	var workflow *model.Configuration
	for _, level := range levels {
		t.Logf("suppressing `%s'", level.ignore)
		workflow, err = parseString(str, level.args...)
		for _, a := range assertions {
			switch a.Result {
			case "failure":
				messages := make([]string, 0, len(a.Errors))
				suppressed := 0
				for _, pe := range a.Errors {
					if !strings.Contains(level.ignore, pe.Severity) {
						if pe.Line > 0 {
							messages = append(messages, fmt.Sprintf("line %d: %s", pe.Line, pe.Message))
						} else {
							messages = append(messages, pe.Message)
						}
					} else {
						suppressed++
					}
				}
				if suppressed == 0 && level.ignore != "" {
					continue
				}
				t.Log("Expected errors:", messages)
				if len(messages) > 0 {
					assertParseError(t, err, a.NumActions, a.NumWorkflows, workflow, messages...)
				} else {
					assertParseSuccess(t, err, a.NumActions, a.NumWorkflows, workflow)
				}
			case "success":
				assertParseSuccess(t, err, a.NumActions, a.NumWorkflows, workflow)
			default:
				t.Errorf("Do not know how to assert a parse result of type `%s`", a.Result)
			}
		}
	}
	return workflow, err
}
