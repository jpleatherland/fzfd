import cliargs;

import std.stdio;
import std.regex;
import std.exception;

unittest
{
	string[] args = ["program", "--depth=3", "abc"];
	auto result = extractArgs(args);
	assert("abc".match(result.pattern));
	assert(result.depth == 3);

	auto result1 = extractArgs(["program", "-d", "2", "abc.*"]);
	assert(result1.depth == 2);
	assert("abcdef".match(result1.pattern));

	auto result2 = extractArgs(["program", "--depth", "1", "--pattern", "hello"]);
	assert(result2.depth == 1);
	assert("hello".match(result2.pattern));

	auto result3 = extractArgs(["program", "--depth", "3", "fallback"]);
	assert(result3.depth == 3);
	assert("fallback".match(result3.pattern));

	assertThrown!Exception(extractArgs(["program", "--pattern", "[unterminated"]));
	assertThrown!Exception(extractArgs(["program", "--depth", "1"]));
}
