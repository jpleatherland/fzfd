import std.stdio;
import std.getopt;
import core.runtime;
import std.regex;

void main(string[] args)
{
	try
	{
		
	}
	catch (Exception e)
	{
		writeln("Error: ", e.msg);
		return;
	}

	int depth = 0;
	string patternStr;
	Regex!char pattern;
	bool isRegex;

	getopt(args, "d|depth", &depth, "pattern", &patternStr, "r|regex", &isRegex);

	if (isRegex)
	{
		try
		{
			pattern = regex(patternStr);
		}
		catch (Exception e)
		{
			writeln("Invalid regex pattern: ", e.msg);
			return;
		}
	}

	if (patternStr.length == 0 && args.length > 1)
	{
		patternStr = args[1];
	}

	string[] results;
	writeln("Depth: ", depth);
	writeln("Pattern: ", pattern);
	if (args.length > 1)
	{
		results = fuzzyFind(args[1 .. $]);
	}
	else
	{
		writeln("No command line arguments provided.");
	}

	foreach (result; results)
	{
		writeln("Found: ", result);
	}

}

string[] fuzzyFind(string[])
{
	string[] results;

	// Implement your fuzzy search logic here
	// For now, we will just return the pattern as a single result
	// results ~= pattern;
	return results;
}
