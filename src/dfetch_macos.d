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
  string logos = environment["HOME"] ~ ".local/share/dfetch/logos/";
  string user;
  if (exists("/etc/hostname"))
    user = environment["USER"] ~ "@" ~ readText("/etc/hostname").strip.replaceAll(regex(r"\..*"), "");

  else if (exists("/etc/HOSTNAME"))
    user = environment["USER"] ~ "@" ~ readText("/etc/HOSTNAME").strip.replaceAll(regex(r"\..*"), "");

  else if (environment["HOSTNAME"] !is null)
    user = environment["USER"] ~ "@" ~ environment["HOSTNAME"];

  else
    user = environment["USER"] ~ "@" ~ executeShell("hostname").output.strip;

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

  // uptime array
  string[] time;
  if (years > 0) time ~= format("%d %s", years, years == 1 ? "year" : "years");
  if (months > 0) time ~= format("%d %s", months, months == 1 ? "month" : "months");
  if (weeks > 0) time ~= format("%d %s", weeks, weeks == 1 ? "week" : "weeks");
  if (days > 0) time ~= format("%d %s", days, days == 1 ? "day" : "days");
  if (hours > 0) time ~= format("%d %s", hours, hours == 1 ? "hour" : "hours");
  if (minutes > 0) time ~= format("%d %s", minutes, minutes == 1 ? "min" : "mins");
  string uptime = time.length == 0 ? "0 mins" : time.join(" ");

  // memory
  string meminfo = readText("/proc/meminfo");
  auto memTotal = meminfo.matchFirst(regex(r"MemTotal:\s+(\d+)"));
  auto memAvail = meminfo.matchFirst(regex(r"MemAvailable:\s+(\d+)"));
  double total = to!double(memTotal[1]) / (1024 * 1024);
  double used = total - (to!double(memAvail[1]) / (1024 * 1024));
  string memory = format("%.1f GB / %.1f GB", used, total);

  // arrays for all colours
  string[] purple_distros = ["Rhino", "Gentoo", "EndeavourOS", "CRUX", "KISS", "Devuan"];
  string[] cyan_distros = ["Arch", "NixOS", "Mageia", "Artix", "CachyOS", "Archcraft"];
  string[] green_distros = ["Manjaro", "Mint", "Tumbleweed", "Void", "CentOS", "Ubuntu MATE", "Leap"];
  string[] blue_distros = ["Alpine", "Slackware", "Fedora", "Solus", "Kubuntu", "Lubuntu", "OpenMandriva", "KaOS", "SteamOS", "Silverblue", "Nitrux"];
  string[] red_distros = ["Debian", "Red Hat", "antiX"];
  string[] yellow_distros = ["Guix", "PikaOS"];

  // variables for the arrays
  auto purple_distro = purple_distros.find!(d => matchFirst(distro, regex(r"(?i)\b" ~ d ~ r"\b")));
  auto cyan_distro   = cyan_distros.find!(d => matchFirst(distro, regex(r"(?i)\b" ~ d ~ r"\b")));
  auto green_distro  = green_distros.find!(d => matchFirst(distro, regex(r"(?i)\b" ~ d ~ r"\b")));
  auto blue_distro   = blue_distros.find!(d => matchFirst(distro, regex(r"(?i)\b" ~ d ~ r"\b")));
  auto red_distro    = red_distros.find!(d => matchFirst(distro, regex(r"(?i)\b" ~ d ~ r"\b")));
  auto yellow_distro = yellow_distros.find!(d => matchFirst(distro, regex(r"(?i)\b" ~ d ~ r"\b")));

  // print function
  void print(string color, string color_distro) {
    writeln("\x1b[1m" ~ color ~ user ~ "\n--------------------");
    writeln("\x1b[1m" ~ color ~ "distro\x1b[0m " ~ distro);
    writeln("\x1b[1m" ~ color ~ "kernel\x1b[0m " ~ kernel);
    writeln("\x1b[1m" ~ color ~ "shell\x1b[0m " ~ shell);
    writeln("\x1b[1m" ~ color ~ "uptime\x1b[0m " ~ uptime);
    writeln("\x1b[1m" ~ color ~ "memory\x1b[0m " ~ memory);
    string ascii = readText(logos ~ color_distro.toLower);
    writeln(ascii);
  }

  // the legendary if statement
  if (!purple_distro.empty)
    print("\x1b[35m", purple_distro.front);
  else if (!cyan_distro.empty)
    print("\x1b[36m", cyan_distro.front);
  else if (!green_distro.empty)
    print("\x1b[32m", green_distro.front);
  else if (!blue_distro.empty)
    print("\x1b[34m", blue_distro.front);
  else if (!red_distro.empty)
    print("\x1b[31m", red_distro.front);
  else if (!yellow_distro.empty)
    print("\x1b[33m", yellow_distro.front);
  else if (distro.canFind("Alma")) {
    writeln("\x1b[1m\x1b[34m" ~ user);
    writeln("\x1b[1m\x1b[36m--------------------");
    writeln("\x1b[1m\x1b[32m" ~ "distro\x1b[0m " ~ distro);
    writeln("\x1b[1m\x1b[32m" ~ "kernel\x1b[0m " ~ kernel);
    writeln("\x1b[1m\x1b[33m" ~ "shell\x1b[0m " ~ shell);
    writeln("\x1b[1m\x1b[31m" ~ "uptime\x1b[0m " ~ uptime);
    writeln("\x1b[1m\x1b[31m" ~ "memory\x1b[0m " ~ memory);
    string ascii = readText(logos ~ "alma");
    writeln(ascii);
  } else {
    writeln("\x1b[1m" ~ user ~ "\n--------------------");
    writeln("\x1b[1m" ~ "distro\x1b[0m " ~ distro);
    writeln("\x1b[1m" ~ "kernel\x1b[0m " ~ kernel);
    writeln("\x1b[1m" ~ "shell\x1b[0m " ~ shell);
    writeln("\x1b[1m" ~ "uptime\x1b[0m " ~ uptime);
    writeln("\x1b[1m" ~ "memory\x1b[0m " ~ memory);
    string ascii = readText(logos ~ "linux");
    writeln(ascii);
  }
  // reset formatting
  write("\x1b[0m");
  return 0;
}
