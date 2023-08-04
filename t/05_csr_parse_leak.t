#!/usr/bin/env perl
use strict;
use warnings;

use Test::More;
use Crypt::PKCS10;

run();

sub run {
    Crypt::PKCS10->setAPIversion(1);

    my $string = "-----BEGIN NEW CERTIFICATE REQUEST-----
MIIEcTCCA1kCAQAweDELMAkGA1UEBhMCREUxDzANBgNVBAgMBkJheWVybjEQMA4GA1UEBwwHS3JvbmFjaDEgMB4GA1UECgwXTHVjYXMtQ3JhbmFjaC1DYW1wdXMgS1UxCzAJBgNVBAsMAklUMRcwFQYDVQQDDA50aW1lLmxjYy1rYy5kZTCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBAMRlgtivD3ajS6Ww8AafhmfUeNwfoTEbzaihb2TPjYfbfHJ7aXKT5ZYXz9vsESQWdhqU8WZmVDkPRH5o6vQsG39F2ZtzPfYvB0BftT5Z5VoT2OUMuS6ecB9dP8B0uACmMyx3zc4pm5Kb70sqRazssmghZMlvBaBi4c1MB1EtoDVSWTI/QyEVN+Gam8qFNiJa38sGFepgn+NozTlOewqWPaOfUflQopkxMMxtJmvfRg22yk3a9aS66u1bTDW3517cFnbPYblh3UMtVSRJBgIJJ7FVo9LzVrDkfvYnNXPxx6aHJptijVlX+5viBFH2qAaaXom/tefpFRt5cbCxWNWCyG0CAwEAAaCCAbIwHAYKKwYBBAGCNw0CAzEOFgwxMC4wLjE3NzYzLjIwTAYJKwYBBAGCNxUUMT8wPQIBBQwWVElNRU1BU1RFUi5sY2NrYy5sb2NhbAwTTENDS0NcYWRtaW5pc3RyYXRvcgwLSW5ldE1nci5leGUwcgYKKwYBBAGCNw0CAjFkMGICAQEeWgBNAGkAYwByAG8AcwBvAGYAdAAgAFIAUwBBACAAUwBDAGgAYQBuAG4AZQBsACAAQwByAHkAcAB0AG8AZwByAGEAcABoAGkAYwAgAFAAcgBvAHYAaQBkAGUAcgMBADCBzwYJKoZIhvcNAQkOMYHBMIG+MA4GA1UdDwEB/wQEAwIE8DATBgNVHSUEDDAKBggrBgEFBQcDATB4BgkqhkiG9w0BCQ8EazBpMA4GCCqGSIb3DQMCAgIAgDAOBggqhkiG9w0DBAICAIAwCwYJYIZIAWUDBAEqMAsGCWCGSAFlAwQBLTALBglghkgBZQMEAQIwCwYJYIZIAWUDBAEFMAcGBSsOAwIHMAoGCCqGSIb3DQMHMB0GA1UdDgQWBBSVEDulP7zK1MhQyDj6QpRzQEZ/njANBgkqhkiG9w0BAQUFAAOCAQEAwAKgBQ/OsudTtQ9AiI6bC6Wb0K2uLMabgXvpa06ESZA3YO/Wd70IiAcMVdgdxhMHW+CW78c8YZ/E4JJw4Riu13JTuM3FuWBa/VH3D6TGN7kVGEBEGh98vaxK6RhlqQVdGMpqrOXtPTg5BRQUR4hP3h9fCXqYB59txyWxbG8fJ1YGALNJF95uiG+IE7/N4379hPT68/m4Bj3XLt1SmomtlqO8A+AemXWKZSacaP9KKggFnkxSC9BbjRi6V785URmwPgFwq20mpvIBQWphQKKBzeDoVRThwyI+RzwnX3XeJ8wDPWf/whlxkJfW3EYtGDcRkoMNykdirPE/JbN0MtIgoA==
-----END NEW CERTIFICATE REQUEST-----";

    my $pkcs10 = Crypt::PKCS10->new($string);
    ok( $pkcs10, "got a parse result" );
    is( Crypt::PKCS10->error, undef, "no errors parsing the CSR" );

    $pkcs10->commonName;
    $pkcs10->countryName;
    $pkcs10->stateOrProvinceName;
    $pkcs10->organizationName;
    $pkcs10->emailAddress;
    $pkcs10->extensionPresent('subjectAltName');
    $pkcs10->extensionValue('subjectAltName');
    $pkcs10->commonName;
    $pkcs10->csrRequest(1);
    $pkcs10 = undef;

    if ( not eval { require Net::Prometheus } ) {
        diag "Net::Prometheus not installed, skipping leak test";
        ok 1;
    }
    else {    # there are some leaks left, but i ran out of time on those
        note $_ for grep /UDAG|Convert::ASN1/,    #
          split /\n/,
          Net::Prometheus->new->render( { perl_collector_detail => 2 } );
        is(
            ( Net::Prometheus::PerlCollector::count_heap(2) )[3]    #
              {"Convert::ASN1::parser"},
            undef,
            "no leak"
        );
    }

    done_testing;

    return;
}
