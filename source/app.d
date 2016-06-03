import std.getopt;
import std.regex;
import std.stdio;

int main(string[] args) {
	bool snipAfter;
	auto helpInfo = getopt(
		args,
		"after|a", &snipAfter
	);

	if (args.length != 2) {
		usage(args[0]);
		return 1;
	}

	auto r = regex(args[1]);
	foreach (line; stdin.byLine) {
		if (line.matchFirst(r)) {
			if (snipAfter) {
				writeln(line);
			}
			return 0;
		}
		writeln(line);
	}

	return 0;
}

void usage(string name) {
	writeln("usage: %s snip_pattern");
}
