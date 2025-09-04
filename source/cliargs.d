module cliargs;

import std.getopt;
import std.regex;
import std.file;
import std.stdio;
import std.typecons;
import std.exception : collectException;
import types;

FuzzyFindParameters extractArgs(string[] args)
{
	int depth = 0;
	string patternStr;
	string path;

	getopt(args, "depth|d", &depth, "pattern", &patternStr, "path|p", &path);

	if (patternStr.length == 0 && args.length > 1)
		patternStr = args[1];

	if (patternStr.length == 0)
		throw new Exception("No valid pattern provided. Please specify a pattern or a regex.");

	PatternType pattern;
	if (looksLikeRegex(patternStr))
	{
		try
		{
			auto rePattern = regex(patternStr);
			pattern = PatternType(rePattern);
			writeln("Using regex pattern: ", patternStr);
		}
		catch (Exception)
		{
			pattern = PatternType(patternStr);
			writeln("Invalid regex, using string pattern: ", patternStr);
		}
	}
	else
	{
		pattern = PatternType(patternStr);
		writeln("Using string pattern: ", patternStr);
	}
	if (path.length == 0)
		path = getcwd();

	return FuzzyFindParameters(depth, pattern, path);
}

private bool looksLikeRegex(string s)
{
	// Heuristic: starts and ends with /, or contains common regex metacharacters
	if (s.length > 2 && s[0] == '/' && s[$ - 1] == '/')
		return true;
	foreach (c; s)
	{
		if (c == '.' || c == '*' || c == '+' || c == '?' || c == '[' || c == ']' || c == '(' || c == ')' || c == '^' || c == '$' || c == '|')
			return true;
	}
	return false;
}
