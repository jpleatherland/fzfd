module types;

import std.typecons;
import std.sumtype;
import std.regex;

alias Pattern = SumType!(string, Regex!char);
struct FuzzyFindParameters
{
	int depth;
	Pattern pattern;
	string dir;
}
