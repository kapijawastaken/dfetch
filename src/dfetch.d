import std.stdio;
import std.process;
import std.string;
import std.regex;
import std.file;

int main() {
  // vars
  string logos = environment["HOME"] ~ "/.local/share/dfetch/logos/";
  //string user = environment["USER"] ~ "@" ~ executeShell("hostname").output.strip;
  //string kernel = executeShell("uname -r").output.strip;
  string shell = environment["SHELL"].replaceAll(regex(r"^.*/"), "");
  string distro = readText("/etc/os-release").replaceAll(regex(r"(?m)^(?!PRETTY_NAME=).*"), "").strip.replace("PRETTY_NAME=", "").replace("\"", "");
  // FIXME: rewrite this so no shell cmds are used, theyre slow.
  writeln(distro);
  return 0;
}
