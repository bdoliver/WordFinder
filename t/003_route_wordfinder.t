use strict;
use warnings;

use WordFinder;
use Test::More tests => 3;
use Plack::Test;
use HTTP::Request::Common;
use Ref::Util qw<is_coderef>;
use JSON;

my $app = WordFinder->to_app;
ok( is_coderef($app), 'Got app' );

my $test = Plack::Test->create($app);
my $res  = $test->request( GET '/wordfinder/house' );

ok( $res->is_success, '[GET /wordfinder/house] successful' );

my $expected_json = [
  "eh",
  "es",
  "he",
  "hes",
  "ho",
  "hoe",
  "hoes",
  "hose",
  "house",
  "hue",
  "hues",
  "oe",
  "oes",
  "oh",
  "ohs",
  "os",
  "ose",
  "sh",
  "she",
  "shoe",
  "so",
  "sou",
  "sue",
  "us",
  "use",
];

my $got_json = decode_json($res->content);

is_deeply($got_json, $expected_json, 'Got expected JSON response');

