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

int main() {
  // vars
  string logos = environment["HOME"] ~ "/.local/share/dfetch/logos/";
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
  string output = executeShell("free").output.strip;
  string memLine = output.splitLines().filter!(line => line.startsWith("Mem:")).front.strip;
  auto parts = memLine.split();
  double total = to!double(parts[1]) / (1024 * 1024);
  double used  = to!double(parts[2]) / (1024 * 1024);
  total = round(total * 10) / 10.0;
  used  = round(used * 10) / 10.0;
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

  writeln(memory);
  return 0;
}
