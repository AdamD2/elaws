#!/usr/bin/perl -w
#
# Elaws - A simple terminal based program to fetch and display an eponymous law
# https://en.wikipedia.org/wiki/List_of_eponymous_laws
#
# Author: Adam Douglas <adam_douglas2@hotmail.com>
# License: GNU GPL v3
#

$url = "https://en.wikipedia.org/wiki/List_of_eponymous_laws";

main();

sub main {
    open F, "wget -q -O- $url|" or die "Could not access the source.";
    my @laws;

    # Fetch each law and add it as a string into an array
    while ($line = <F>) {
        if ($line =~ /<li>(.*)<\/li>/) {
            $line =~ s/<[^>]*>//g;

            push @laws, $line;
        }
    }

    # Check that there is at least one law to choose from
    if (@laws > 0) {
        # Generate a random number
        my $number = int(rand(@laws));

        # Print the law associated with that number
        print $laws[$number];
    }
}
