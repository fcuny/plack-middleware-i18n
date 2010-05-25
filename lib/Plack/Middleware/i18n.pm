package Plack::Middleware::i18n;

use strict;
use warnings;
use Plack::Util;
use Plack::Util::Accessor qw/default_lang/;
use I18N::LangTags;
use I18N::LangTags::Detect;

our $VERSION = '0.01';

use parent 'Plack::Middleware';

sub call {
    my $self = shift;
    my $res  = $self->app->(@_);

    my $h = Plack::Util::headers($res->[1]);

    my @languages = ($self->default_lang) if $self->default_lang;
    push @languages,
      I18N::LangTags::implicate_supers(
        I18N::LangTags::Detect->http_accept_langs($h->get('Accept-Language')));

    # XXX store languages in psgix.languages
    # XXX if session, store in session too
    # XXX maybe redirect to appropriate location ?
    
    return $res;
}

1;

__END__
