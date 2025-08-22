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
	string[] matches;
	//do not follow symlinks, let depth control traversal
	foreach (DirEntry entry; dirEntries(params.dir, SpanMode.shallow, false))
	{
		auto hit = matchFirst(baseName(entry.name), params.pattern);

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
