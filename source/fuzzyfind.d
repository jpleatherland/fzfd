module fuzzyfind;

import types;

import std.stdio;
import std.path;
import std.typecons;
import std.file;
import std.regex;
import std.algorithm.searching;
import std.sumtype : sumTypeMatch = match;

string[] fuzzyFind(FuzzyFindParameters params)
{
	const string root = absolutePath(params.dir);
	return fuzzyFindImpl(params, root);
}

private string[] fuzzyFindImpl(FuzzyFindParameters params, const string root)
{
	string[] matches;
	//do not follow symlinks, let depth control traversal
	foreach (DirEntry entry; dirEntries(params.dir, SpanMode.shallow, false))
	{
		auto hit = fuzzyMatch(baseName(entry.name), params.pattern);

		if (hit)
		{
			matches ~= relativePath(entry.name, root);
		}

		if (entry.isDir() && params.depth > 0)
		{
			try
			{
				matches ~= fuzzyFindImpl(FuzzyFindParameters(params.depth - 1, params.pattern, entry
						.name), root);
			}
			catch (FileException)
			{
				// skip unreadable subdir
			}
		}
	}

	return matches;

}

private bool orderedMatch(string target, string pattern)
{
	size_t i = 0;
	foreach (char c; target)
	{
		if (i < pattern.length && c == pattern[i])
		{
			i++;
		}
	}
	return i == pattern.length;
}

private bool fuzzyMatch(string target, PatternType pattern)
{
	return pattern.sumTypeMatch!(
		(Regex!char re) => !matchFirst(target, re).empty,
		(string raw) => orderedMatch(target, raw)
	);
}
