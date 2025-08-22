module fuzzyfind;

import types;

import std.stdio;
import std.path;
import std.typecons;
import std.file;
import std.algorithm.searching;
import std.sumtype;
import std.regex : regexMatch = match;
import std.regex;

string[] fuzzyFind(FuzzyFindParameters params)
{
	string[] matches;
	//do not follow symlinks, let depth control traversal
	foreach (DirEntry entry; dirEntries(params.dir, SpanMode.shallow, false))
	{
		string entryBaseName = baseName(entry.name);

		bool hit = params.pattern.match!(
			(Regex!char r) =>
				cast(bool) matchFirst(entryBaseName, r),
				(string s) => canFind(entryBaseName, s)
		);

		if (hit)
		{
			matches ~= relativePath(entry.name, params.dir);
		}

		if (entry.isDir() && params.depth > 0)
		{
			try
			{

				matches ~= fuzzyFind(FuzzyFindParameters(params.depth - 1, params.pattern, entry
						.name));
			}
			catch (FileException)
			{
				// skip unreadable subdir
			}
		}
	}

	return matches;
}
