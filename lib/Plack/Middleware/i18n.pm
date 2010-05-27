package Plack::Middleware::i18n;

use strict;
use warnings;

use Plack::Util;
use Plack::Util::Accessor qw/default_locale/;
use I18N::LangTags;
use I18N::LangTags::Detect;

our $VERSION = '0.01';

use parent 'Plack::Middleware';

sub call {
    my ($self, $env) = @_;

    my $locale;

    if (my $lang = $env->{'HTTP_ACCEPT_LANGUAGE'}) {
        $locale = (
            split(
                '-',
                (   I18N::LangTags::implicate_supers(
                        I18N::LangTags::Detect->http_accept_langs($lang)
                    )
                  )[0]
            )
        )[0];
    }
    else {
        $locale = $self->default_locale // 'en';
    }

    $env->{'psgix.locale'} = $locale;

    if (my $session = $env->{'psgix.session'}) {
        $session->{locale} = $locale;
    }

    $self->app->($env);
}


1;

__END__
