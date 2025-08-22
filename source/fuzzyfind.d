module fuzzyfind;

import types;

import std.stdio;
import std.path;
import std.typecons;
import std.file;
import std.algorithm.searching;
import std.regex;

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
		auto hit = matchFirst(baseName(entry.name), params.pattern);

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
