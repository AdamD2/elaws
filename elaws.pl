#!/usr/bin/perl -w
#
# Elaws - A simple terminal based program to fetch and display an eponymous law
# https://en.wikipedia.org/wiki/List_of_eponymous_laws
#
# Author: Adam Douglas <adam_douglas2@hotmail.com>
# License: GNU GPL v3
#

$url = "https://en.wikipedia.org/wiki/List_of_eponymous_laws";
$version = "Elaws version: 0.2.\nUsage: ./elaws.pl\n./elaws.pl -h for help.\n";
$help = "Usage: ./elaws [-v] [-h] [-l] [\$number]\nv - Version\nh - Help
l - Verbose\n\$number - Number of laws to print or 1 by default\n";
$verbose = "Welcome to elaws, a simple terminal based program to fetch and 
display an eponymous law.\n
https://en.wikipedia.org/wiki/List_of_eponymous_laws\n\n";

main();

sub main {
    my $num_laws = 1;
    my @laws;
    my $number;
    my %random_numbers;

    # Process command line arguments
    foreach $arg (@ARGV) {
        if ($arg eq "-v" or $arg eq "--version") {
            print $version;
            exit;
        } elsif ($arg eq "-h" or $arg eq "--help") {
            print $help;
            exit;
        } elsif ($arg eq "-l" or $arg eq "--verbose") {
            print $verbose;
        } elsif ($arg =~ /^[-]?\d+$/) {
            if ($arg >= 0) {
                $num_laws = $arg;
            } else {
                die "Cannot print a negative number of laws.\n";
            }
        }
    }

    open F, "wget -q -O- $url|" or die "Could not access the source.\n";

    # Fetch each law and add it to an array 
    while ($line = <F>) {
        if ($line =~ /<li>(.*)<\/li>/) {
            $line =~ s/<[^>]*>//g;

            push @laws, $line;
        }
    }

    close F;

    # Display as many laws as specified by a command line argument
    # or 1 by default
    for (my $i = 0; $i < $num_laws; $i++) {
        # Check the bounds
        if (0 < @laws and $num_laws < @laws) {
            # Generate a unique random number
            $number = int(rand(@laws));
            while (defined $random_numbers{$number}) {
                $number = int(rand(@laws));
            }
            $random_numbers{$number} = 1;

            # Print the law associated with that number
            print $laws[$number] . "\n";
        } else {
            die "Invalid number of laws.";
        }
    }
}
