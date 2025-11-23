import std.stdio;
import std.process : executeShell, environment;
import std.string : strip, replace;
import std.regex : regex, replaceAll;
import std.file : exists, readText;
import std.conv : to;

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
  
  // uptime math
  int seconds = readText("/proc/uptime").replaceAll(regex(r"\..+"), "").strip.to!int;
  int years = seconds / 31536000;
  int months = (seconds % 31536000) / 2592000;
  int weeks = ((seconds % 31536000) % 2592000) / 604800;
  int days = (seconds % 31536000) / 86400;
  int hours = (seconds % 86400) / 3600;
  int minutes = (seconds % 3600) / 60;
  writeln(seconds);
  return 0;
}
