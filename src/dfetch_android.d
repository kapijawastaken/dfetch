import std.stdio;
import std.process;
import std.string;
import std.regex;
import std.file;
import std.conv;
import std.format;
import std.array;
import std.math;
import std.algorithm;
import std.uni;

int main() {
  // vars
  string logos  = environment["HOME"] ~ ".local/share/dfetch/logos/";
  string user   = environment["USER"] ~ "@" ~ executeShell("hostname").output.strip;
  string kernel = executeShell("uname -r").output.strip;
  string shell  = environment["SHELL"].replaceAll(regex(r"^.*/"), "");
  string distro = "Android";
    
  // uptime
  string uptime = executeShell("uptime -p").output.strip.replace(",", "").replaceFirst("up ", "");
  string pluralize(int count, string singular, string plural = null) {
    if (plural is null) {
        plural = singular ~ "s";
    }
    return count == 1 ? format("%d %s", count, singular) : format("%d %s", count, plural);
  }
  auto parts = matchAll(uptime, regex(r"(\d+)\s+(year|month|week|day|hour|minute)"));
  string[] formattedParts;
  foreach (match; parts) {
    int count = to!int(match[1]);
    string unit = match[2];
    formattedParts ~= pluralize(count, unit);
  }
  uptime = formattedParts.join(" ").replace("ute", "");

  // reset formatting
  write("\x1b[0m");
  return 0;
}
