module cliargs;

import std.getopt;
import std.regex;
import std.stdio;
import std.typecons;
import types;

FuzzyFindParameters extractArgs(string[] args)
{
	int depth = 0;
	string patternStr;

	getopt(args, "depth|d", &depth, "pattern", &patternStr);

	if (patternStr.length == 0 && args.length > 1)
		patternStr = args[1];

	if (patternStr.length == 0)
		throw new Exception("No valid pattern provided. Please specify a pattern or a regex.");

	Regex!char rePattern;
	try
	{
		rePattern = regex(patternStr);
	}
	catch (Exception e)
	{
		writeln("Invalid regex pattern: ", e.msg);
		throw e;
	}
	return FuzzyFindParameters(depth, rePattern);
}
