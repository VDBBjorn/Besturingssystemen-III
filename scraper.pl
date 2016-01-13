#!/usr/bin/perl
use 5.010;
use strict;
use warnings;

use HTML::Entities;
use Mojo::UserAgent;
use LWP::Simple;
use File::Path qw(make_path);

$username = "Interim P";
$password = "Interim P";

if (@ARGV != 2){
	say STDERR "Gebruik: perl intranet_scraper.pl [reeks_nummer] [hoogste_nummer_oefening] [type: .pl of .ps1]";
	exit 1;
}
my ($reeks_no,$aantal_oef,$url_postfix) = @ARGV;


##### IO SETUP ########################################

# Directories
my $dir_output = 'output';

# Create directories
make_path $dir_output unless -d $dir_output;


##### SCRAPER SETUP ###################################

# FIFO queue for URLs
my @urls;
my $url_prefix = "https://$username:$password\@intranet.tiwi.ugent.be/Besturingssystemen-III/Labo/p$reeks_no/";

for my $i (1..$aantal_oef){
	my $url = $url_prefix;
	$url .= "0" if($i<10);
	$url .= "$i$url_postfix";
	push @urls,$url;
}
my $total_urls = 0;

# Limit parallel connections
my $max_con = 20;

# User agent following up to 5 redirects
my $ua = Mojo::UserAgent->new(max_redirects => 5);

# Keep track of active connections
my $active = 0;


##### MAIN ############################################

Mojo::IOLoop->recurring(
	0 => sub {
		for($active + 1 .. $max_con){
			# Dequeue or halt if there are no active crawlers anymore
			my $url;
			unless ($url = shift @urls){
				return ($active or end_scraping());
			}
			
			# Fetch non-blocking just by adding a callback and marking as active
			++$active;
			get_callback($ua->get($url));
		}
	}
);

# Start event loop if necessary
Mojo::IOLoop->start unless Mojo::IOLoop->is_running;

##### MAIN END ########################################


##### SUBS ############################################

## Check callback if URL is valid and parse html if so
sub get_callback{
	my ($tx) = @_;
	
	# Deactivate
	--$active;
	
	# Only use OK HTML responses
	return
		if not $tx->res->is_status_class(200);
	
	# Request URL
	my $url = $tx->req->url;
	say $url;
	++$total_urls;
	parse_html($url,$tx);
	
	return;
}

## Scrape and process HTML code of given url
sub parse_html{
	my ($url,$tx) = @_;

	my $html = $tx->res->to_string;

	my $body;
	$body = $1 if ($html =~ m((?:.*?)\n\s*\n(.+))s);

	# Write data to file
	to_file($url,$body);
	return;
}

## Write scraped HTML to file for later testing
sub to_file{
	my ($url,$body) = @_;

	my $id = $1 if($url =~ m(^(?:.+)/(.+?).pl$));

	open(my $out,">","$dir_output/reeks$reeks_no/Reeks$reeks_no\_$id.pl") or die "Failed to open outputfile: $!";
	say $out $body;
	close($out);

	return;
}

## End the scraping process and execute any followup code
sub end_scraping{
	Mojo::IOLoop->stop if Mojo::IOLoop->is_running;
	
	exit(0);
}
