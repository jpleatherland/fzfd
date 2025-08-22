import types;
import fuzzyfind;
import std.stdio;
import std.algorithm;
import std.file;
import std.regex;

unittest
{
	// assert depth string match
	FuzzyFindParameters params = FuzzyFindParameters(1, Pattern("types"), getcwd());
	string[] results = fuzzyFind(params);
	assert(results.length > 0);

	// assert no depth
	FuzzyFindParameters params2 = FuzzyFindParameters(0, Pattern("types"), getcwd());
	string[] results2 = fuzzyFind(params2);
	assert(results2.length == 0);

	// assert regex match
	FuzzyFindParameters params3 = FuzzyFindParameters(1, Pattern(regex("t.*s")), getcwd());
	string[] results3 = fuzzyFind(params3);
	assert(results3.length == 5);
}
