use strict;
use warnings;
use Test::More;
use Plack::Builder;
use Plack::Test;
use HTTP::Request::Common;

my $handler = builder {
    enable "i18n";
    sub {
        my $env = shift;
        [   '200',
            ['Content-Type' => 'text/html',],
            ['locale is ' . $env->{'psgix.locale'}]
        ];
    };
};

test_psgi
  app    => $handler,
  client => sub {
    my $cb = shift;
    {
        my $req = GET "http://localhost/";
        $req->header('Accept-Language' => 'fr-FR,de;q=0.8');
        ok my $res = $cb->($req);
        is $res->content, 'locale is fr';
    }
  };

done_testing();

