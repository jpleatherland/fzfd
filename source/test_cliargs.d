module test_cliargs;

import cliargs;
import std.regex;
import std.stdio;
import std.exception;

unittest
{
	// Test regex pattern
	string[] args1 = ["program", "--depth=2", "--pattern=abc.*", "--regex"];
	auto result1 = extractArgs(args1);
	auto depth1 = result1[0];
	auto pattern1 = result1[1];
	assert(depth1 == 2);

	if (pattern1.type == typeid(Regex!char))
	{
		auto r = pattern1.visit!();
		assert(match("abcdef", r).hit, "Expected regex match");
	}
	else
	{
		assert(false, "Expected regex, got string");
	}

	// Test literal pattern
	string[] args2 = ["program", "--depth=1", "--pattern=hello"];
	auto result2 = extractArgs(args2);
	auto depth2 = result2[0];
	auto pattern2 = result2[1];
	assert(depth2 == 1);

	if (pattern2.type == typeid(string))
	{
		auto s = pattern2.get!string;
		assert(s == "hello");
	}
	else
	{
		assert(false, "Expected string, got regex");
	}

	// Test fallback to positional pattern
	string[] args3 = ["program", "--depth=3", "fallback"];
	auto result3 = extractArgs(args3);
	auto depth3 = result3[0];
	auto pattern3 = result3[1];
	assert(depth3 == 3);

	if (pattern3.type == typeid(string))
	{
		auto s = pattern3.get!string;
		assert(s == "fallback");
	}
	else
	{
		assert(false, "Expected string, got regex");
	}

	// Test invalid regex
	bool threw = false;
	try
	{
		string[] args4 = ["program", "--pattern=[unterminated", "--regex"];
		extractArgs(args4);
	}
	catch (Exception e)
	{
		threw = true;
	}
	assert(threw, "Expected exception for invalid regex");

	// Test missing pattern
	threw = false;
	try
	{
		string[] args5 = ["program", "--depth=1"];
		extractArgs(args5);
	}
	catch (Exception e)
	{
		threw = true;
	}
	assert(threw, "Expected exception for missing pattern");
}
