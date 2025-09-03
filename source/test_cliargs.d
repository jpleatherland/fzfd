module test_cliargs;

import std.exception : assertThrown;
import std.sumtype : visit = match;
import std.regex;
import cliargs; // your module
import types; // defines PatternType, FuzzyFindParameters

// Helper: check if PatternType holds a Regex
private bool isRegexVariant(PatternType p)
{
	return p.visit!(
		(Regex!char) => true,
		(string) => false
	);
}

// Helper: extract string if variant is string
private string patternAsString(PatternType p)
{
	return p.visit!(
		(Regex!char) => "<regex>",
		(string s) => s
	);
}

unittest
{
	// 1) Missing pattern -> should throw
	assertThrown!Exception(extractArgs(["prog"]));
	assertThrown!Exception(extractArgs([]));
}

unittest
{
	// 2) Positional pattern only (valid regex)
	auto p = extractArgs(["prog", "abc"]);
	assert(p.depth == 0);
	assert("abc".match(patternAsString(p.pattern)));
}

unittest
{
	// 3) --pattern option
	auto p = extractArgs(["prog", "--pattern", "^foo$"]);
	assert(p.depth == 0);
	assert(isRegexVariant(p.pattern));
}

unittest
{
	// 4) --pattern with equals
	auto p = extractArgs(["prog", "--pattern=bar"]);
	assert("bar".match(patternAsString(p.pattern)));
}

unittest
{
	// 5) --depth long option
	auto p = extractArgs(["prog", "--depth", "3", "abc"]);
	assert(p.depth == 3);
}

unittest
{
	// 6) -d short option
	auto p = extractArgs(["prog", "-d", "2", "abc"]);
	assert(p.depth == 2);
}

unittest
{
	// 7) Invalid regex falls back to string
	auto p = extractArgs(["prog", "["]);
	assert(!isRegexVariant(p.pattern));
	assert(patternAsString(p.pattern) == "[");
}

unittest
{
	// 8) --pattern takes precedence over positional
	auto p = extractArgs(["prog", "--pattern", "^x$", "^y$"]);
	assert(isRegexVariant(p.pattern));
}

unittest
{
	// 9) Depth order doesn't matter
	auto a = extractArgs(["prog", "--depth", "4", "abc"]);
	auto b = extractArgs(["prog", "abc", "--depth", "4"]);
	assert(a.depth == 4 && b.depth == 4);
}

unittest
{
	// 10) Negative depth allowed (no validation in code)
	auto p = extractArgs(["prog", "--depth", "-1", "abc"]);
	assert(p.depth == -1);
}
