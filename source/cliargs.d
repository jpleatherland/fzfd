module cliargs;

import std.getopt;
import std.regex;
import std.stdio;
import std.variant;
import std.typecons;

alias Pattern = Algebraic!(string, Regex!char);

Tuple!(int, Pattern) extractArgs(string[] args)
{
	int depth = 0;
	string patternStr;
	bool isRegex = false;

	getopt(args, "d|depth", &depth, "pattern", &patternStr, "r|regex", &isRegex);

	writeln("Depth: ", depth);
	writeln("Pattern: ", patternStr);
	writeln("Is Regex: ", isRegex);

	if (isRegex)
	{
		try
		{
			Regex!char pattern = regex(patternStr);
			return Tuple!(int, Pattern)(depth, Pattern(pattern));
		}
		catch (Exception e)
		{
			writeln("Invalid regex pattern: ", e.msg);
			throw e;
		}
	}

	if (patternStr.length == 0 && args.length > 1)
	{
		return Tuple!(int, Pattern)(depth, Pattern(args[1]));
	}

	throw new Exception("No valid pattern provided. Please specify a pattern or a regex.");
}
