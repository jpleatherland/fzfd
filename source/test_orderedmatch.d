unittest
{
	import std.file : mkdir, write, rmdirRecurse;
	import std.stdio : writeln;
	import std.path : buildPath, baseName;
	import std.algorithm : sort, map;
	import std.array : array;
	import std.conv : to;
	import std.regex : regex;
	import fuzzyfind : fuzzyFind;
	import types;

	// Setup temporary test directory
	string tempDir = buildPath("temp_fuzzy_test");
	mkdir(tempDir);

	// Create test files
	string[] testFiles = [
		"toast.txt",
		"t_s_t.log",
		"testingstuff.md",
		"stt.txt",
		"ts.txt",
		"tst.txt",
		"random.txt"
	];

	foreach (file; testFiles)
	{
		write(buildPath(tempDir, file), "dummy content");
	}

	// Run fuzzyFind with pattern "tst"
	auto params = FuzzyFindParameters(1, PatternType("tst"), tempDir);
	auto results = fuzzyFind(params).sort.array;
	auto resultsBaseNames = results.map!(x => baseName(x)).array;

	// Clean up
	rmdirRecurse(tempDir);

	// Expected matches (in sorted order)
	string[] expected = [
		"t_s_t.log",
		"testingstuff.md",
		"toast.txt",
		"ts.txt",
		"tst.txt"
	].sort.array;

	assert(resultsBaseNames == expected, "fuzzyFind did not return expected matches");
}
