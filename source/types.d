module types;

import std.typecons;
import std.sumtype;
import std.regex;
import std.sumtype;

alias PatternType = SumType!(Regex!char, string);

struct FuzzyFindParameters
{
	int depth;
	PatternType pattern;
	string dir;
}
