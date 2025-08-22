module types;

import std.typecons;
import std.sumtype;
import std.regex;

struct FuzzyFindParameters
{
	int depth;
	Regex!char pattern;
	string dir;
}
