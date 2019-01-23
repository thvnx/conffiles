#!/usr/bin/env perl
# vim:ts=4:sw=4:expandtab
# © 2012 Michael Stapelberg, Public Domain

# This script is a simple wrapper which prefixes each i3status line with custom
# information. To use it, ensure your ~/.i3status.conf contains this line:
#     output_format = "i3bar"
# in the 'general' section.
# Then, in your ~/.i3/config, use:
#     status_command i3status | ~/i3status/contrib/wrapper.pl
# In the 'bar' section.

use strict;
use warnings;
# You can install the JSON module with 'cpan JSON' or by using your
# distribution’s package management system, for example apt-get install
# libjson-perl on Debian/Ubuntu.
use JSON;

my ($alkal, $alkol, $lastupdate) = ("ALKAL (waiting Euronext opening)", "#333333", 0);

sub get_alkal {
  my $alkal = "ALKAL";
  my $alkol = "#BEBEBE";
  open my $input, "-|", "wget -N -O - https://www.boursorama.com/bourse/forum/1rPALKAL/ 2>/dev/null";
  while (<$input>) {
    if ($_ =~ /Cours\ KALRAY/) {
      $_ =~ /.*variation&quot;:(.).*last&quot;:([0-9\.]+).*/ || next;
      $alkal = $alkal . " $2";
      if($1 eq '-') {$alkol = "#DF0101"} else {$alkol = "#076E4E"};
    }
  }
  close $input;

  return ($alkal, $alkol)
}

# Don’t buffer any output.
$| = 1;

# Skip the first line which contains the version header.
print scalar <STDIN>;

# The second line contains the start of the infinite array.
print scalar <STDIN>;

# Read lines forever, ignore a comma at the beginning if it exists.
while (my ($statusline) = (<STDIN> =~ /^,?(.*)/)) {
    # Decode the JSON-encoded line.
    my @blocks = @{decode_json($statusline)};

    # Prefix our own information (you could also suffix or insert in the
    # middle).
    my ($sec, $min, $hour, $mday, $mon, $year, $wday, $yday, $isdst) = localtime();
    my $refresh = time() - $lastupdate;

    if($refresh > 60 and (($hour => 8) and ($hour < 18))) {
      ($alkal, $alkol) = get_alkal();
      $lastupdate = time();
    }

    @blocks = ({
	full_text => "$alkal",
	color => "$alkol",
	name => 'alkal'
    }, @blocks);

    # Output the line as JSON.
    print encode_json(\@blocks) . ",\n";
}
