import std.stdio;
import std.getopt;
import core.runtime;
import std.regex;
import std.typecons;
import std.sumtype;
import std.file;
import cliargs;
import fuzzyfind;
import types;

void main(string[] args)
{
	string[] results;
	FuzzyFindParameters extractedArgs;
	try
	{
		extractedArgs = extractArgs(args);
	}
	catch (Exception e)
	{
		writeln("Error: ", e.msg);
		return;
	}

	extractedArgs.dir = getcwd();
	results = fuzzyFind(extractedArgs);

	foreach (result; results)
	{
		writeln(result);
	}

}
