package WordFinder;
use Dancer2;

our $VERSION = '0.1';

## ping = no-op, just respond with '200 OK'
get '/ping' => sub {};

true;
