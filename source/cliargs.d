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
	bool isRegex = false;

	getopt(args, "depth|d", &depth, "pattern", &patternStr, "regex|r", &isRegex);

	if (patternStr.length == 0 && args.length > 1)
		patternStr = args[1];

	if (patternStr.length == 0)
		throw new Exception("No valid pattern provided. Please specify a pattern or a regex.");

	if (isRegex)
	{
		Regex!char rePattern;
		try
		{
			rePattern = regex(patternStr);
		}
		catch (Exception e)
		{
			// Tip: prefer `throw;` to preserve the original stack trace
			// (but either way, this path never returns)
			writeln("Invalid regex pattern: ", e.msg);
			throw e;
		}
		return FuzzyFindParameters(depth, Pattern(rePattern));
	}
	else
	{
		return FuzzyFindParameters(depth, Pattern(patternStr));
	}
}
