package WordFinder;
use Dancer2;

use Algorithm::Permute;
use Path::Tiny;

our $VERSION = '0.1';

## ------------------------------------------------------------------
## Load word dictionary when server starts:
my $dictionary = config->{dictionary}
    or die "'dictionary' setting not defined in config.yml\n";

## Lowercase the dictionary words and pre-populate a hash for fast lookup:
my %DICT = ( map { lc $_ => $_ } path($dictionary)->lines({chomp => 1}) );

## ------------------------------------------------------------------
## find_words:
## - finds all possible words that can be made out of the input letters
sub find_words {
    my ( $input ) = @_;

    my @letters = split(q{}, $input);

    ## Create all possible permutations of the letters given:
    my %permutations = ();

    ## No sense permuting down to single lettes - the only two single letter
    ## English words found in /usr/share/dict/words are 'a' & 'I')
    for ( my $i = @letters; $i > 1 ; $i-- ) {

        my $p = Algorithm::Permute->new([ @letters ], $i);

        ## we can get duplicate permutations - we're only interested
        ## in the unique strings, so we keep track of only those:
        while ( my @res = $p->next ) {
            $permutations{join(q{}, @res)} ||= 1;
        }
    }

    # ... and if the input _does_ contain an 'a' or 'i':
    $permutations{a} = 1 if $input =~ qr{a};
    $permutations{i} = 1 if $input =~ qr{i};

    debug "Total permutations of '$input': ".(scalar keys %permutations);

    my @words = ();

    ## Find all the 'words':
    ## I like a sorted list - could remove the sort for speed as the
    ## permutations hash will get quite big for long words... not to
    ## mention, this isn't exactly memory-efficient either.
    for my $s ( sort keys %permutations ) {
        if ( my $word = $DICT{$s} ) {
            push @words, $word;
        }
    }

    return \@words;
}

## ------------------------------------------------------------------
## ROUTES:
##
## ping = no-op, just respond with '200 OK'
get '/ping' => sub {};

get '/wordfinder/:input' => sub {
    my $input = route_parameters->get(q{input});

    # this is a word search - letters only please:
    $input =~ qr{^[[:alpha:]]+$} or
        send_error("Bad input", 400);

    # this is a pretty crap algorithm, so for now, deny strings longer
    # than 10 characters - it takes way too long to iterate through the
    # permutations
    length($input) <= 10 or
        send_error("Input too long", 400);

    debug qq{/wordfinder input: $input};

    send_as JSON => find_words($input);
};

true;
