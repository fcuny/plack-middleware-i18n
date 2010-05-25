use strict;
use warnings;
use Test::More;
use Plack::Builder;
use Plack::Test;
use HTTP::Request::Common;

my $handler = builder {
    enable "i18n";
    sub {
        [   '200', ['Content-Type' => 'text/html', 'Accept-Language' => 'fr'],
            ['Hello world']
        ];
    };
};

test_psgi
    app    => $handler,
    client => sub {
    my $cb = shift;
    {
        my $req = GET "http://localhost/";
        ok my $res = $cb->($req);
    }
};

done_testing();
