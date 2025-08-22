import cliargs;

import std.stdio;
import std.sumtype;
import std.regex;
import std.regex : regexMatch = match;
import std.exception;

unittest
{
	string[] args = ["program", "--depth=3", "abc"];
	auto result = extractArgs(args);
	result[1].match!(
		(Regex!char r) => writeln("regex: ", r),
		(string s) => assert("abc" == s)
	);
	assert(result[0] == 3);

	//Test regex pattern
	auto result1 = extractArgs(["program", "-d", "2", "abc.*", "--regex"]);
	auto pattern1 = result1[1];
	auto depth1 = result1[0];
	assert(depth1 == 2);
	pattern1.match!(
		(Regex!char r) => assert("abcdef".regexMatch(r)),
		(string s) => assert(false, "Expected regex, got string")
	);

	// Test literal pattern
	auto result2 = extractArgs(["program", "--depth", "1", "--pattern", "hello"]);
	auto depth2 = result2[0];
	auto pattern2 = result2[1];
	assert(depth2 == 1);
	pattern2.match!(
		(Regex!char r) => assert(false, "Expected string, got regex: "),
		(string s) => assert(s == "hello")
	);

	// Test fallback to positional pattern
	auto result3 = extractArgs(["program", "--depth", "3", "fallback"]);
	auto depth3 = result3[0];
	auto pattern3 = result3[1];
	assert(depth3 == 3);
	pattern3.match!(
		(Regex!char r) => assert(false, "Expected string, got regex"),
		(string s) => assert(s == "fallback")
	);

	// Test invalid regex
	assertThrown!Exception(extractArgs([
			"program", "--pattern", "[unterminated", "--regex"
		]));
	// Test missing pattern
	assertThrown!Exception(extractArgs(["program", "--depth", "1"]));
}
