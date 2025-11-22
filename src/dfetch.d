import std.stdio;
import std.process;
import std.string;
import std.regex;
import std.file;

int main() {
  // vars
  string logos = environment["HOME"] ~ "/.local/share/dfetch/logos/";
  string user;
  if (exists("/etc/hostname")) {
    user = environment["USER"] ~ "@" ~ readText("/etc/hostname").strip;
  }
  else if (exists("/etc/HOSTNAME")) {
    user = environment["USER"] ~ "@" ~ readText("/etc/HOSTNAME").strip;
  }
  else {
    user = environment["USER"] ~ "@" ~ executeShell("hostname").output.strip;
  }
  string kernel = readText("/proc/sys/kernel/osrelease").strip;
  string shell = environment["SHELL"].replaceAll(regex(r"^.*/"), "");
  string distro = readText("/etc/os-release").replaceAll(regex(r"(?m)^(?!PRETTY_NAME=).*"), "").strip.replace("PRETTY_NAME=", "").replace("\"", "");
  // FIXME: rewrite this so no shell cmds are used, theyre slow.
  writeln(user);
  return 0;
}
