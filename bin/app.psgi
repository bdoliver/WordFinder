#!/usr/bin/env perl

use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../lib";


# use this block if you don't need middleware, and only have a single target Dancer app to run here
use WordFinder;

WordFinder->to_app;

=begin comment
# use this block if you want to include middleware such as Plack::Middleware::Deflater

use WordFinder;
use Plack::Builder;

builder {
    enable 'Deflater';
    WordFinder->to_app;
}

=end comment

=cut

=begin comment
# use this block if you want to mount several applications on different path

use WordFinder;
use WordFinder_admin;

use Plack::Builder;

builder {
    mount '/'      => WordFinder->to_app;
    mount '/admin'      => WordFinder_admin->to_app;
}

=end comment

=cut

