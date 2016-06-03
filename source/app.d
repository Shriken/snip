import std.getopt;
import std.regex;
import std.stdio;

int main(string[] args) {
	int offset = 0;
	auto helpInfo = getopt(
		args,
		"offset|o", "Offset from match to start snipping", &offset,
	);

	if (args.length != 2 || helpInfo.helpWanted) {
		usage(args[0]);
		return args.length != 2 ? 1 : 0;
	}

	auto r = regex(args[1]);
	if (offset < 0) {
		char[][] linesBuf;
		linesBuf.length = -offset;
		size_t index = 0;
		foreach (line; stdin.byLine) {
			if (line.matchFirst(r)) {
				break;
			}
			if (linesBuf[index] !is null) {
				writeln(linesBuf[index]);
			}
			linesBuf[index] = line;
			index = (index + 1) % (-offset);
		}
	} else {
		foreach (line; stdin.byLine) {
			if (line.matchFirst(r)) {
				if (offset > 0) {
					writeln(line);
				}
				break;
			}
			writeln(line);
		}
		foreach (i; 0 .. offset - 1) {
			write(stdin.readln());
		}
	}

	return 0;
}

void usage(string name) {
	writeln("usage: %s snip_pattern");
}
