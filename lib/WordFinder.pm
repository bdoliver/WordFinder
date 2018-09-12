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

    my %words;

    ## Permute all combinations of letters in the input string,
    ## down to all possible 2-char strings. No sense permuting
    ## down to single letters - the only two single letter
    ## English words found in /usr/share/dict/words are 'a' & 'I')
    ## Could also be smarter if we only look at 2-char "words" which
    ## contain a vowel or 'y'...

    for ( my $i = @letters; $i > 1 ; $i-- ) {

        my $p = Algorithm::Permute->new([ @letters ], $i);

        ## we can get duplicate permutations - we're only interested
        ## in the unique strings, so we keep track of only those:
        while ( my @res = $p->next ) {
            my $permuted_string = join(q{}, @res);

            if ( exists $DICT{$permuted_string} ) {
                $words{$DICT{$permuted_string}} ||= 1;
            }
        }
    }

    $words{a} = 1 if $input =~ qr{a};
    $words{I} = 1 if $input =~ qr{i};

    return [ sort keys %words ];
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

    debug qq{/wordfinder input: $input};

    send_as JSON => find_words($input);
};

true;
