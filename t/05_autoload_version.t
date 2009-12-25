use strict;
use warnings;
use lib 't/lib';
use Test::More;

eval {
    require Module::Requires;
    Module::Requires->import(
        'ClassA' => {
            import  => [qw/ foo bar baz /],
            version => 0.01,
        }
    );
};
like($@, qr/ClassA is unloaded because -autoload an option is lacking./);
unlike($@, qr/version/);

ok(ClassA->can('package'));
is(ClassA->params, '');

eval {
    require Module::Requires;
    Module::Requires->import(
        '-autoload',
        'ClassA' => {
            import  => [qw/ foo bar baz /],
            version => 0.03,
        },
        'ClassB' => '0.10',
        'ClassC' => {
            import => [qw/ foo bar baz /],
        }
    );
};
like($@, qr/ClassA version 0.03 required--this is only version 0.02\nClassB version 0.10 required--this is only version 0.08/);
unlike($@, qr/ClassC/);

ok(ClassB->can('package'));
ok(ClassC->can('package'));
is(ClassA->params, '');

eval {
    require Module::Requires;
    Module::Requires->import(
        '-autoload',
        'ClassA' => {
            import  => [qw/ foo bar baz /],
            version => 0.02,
        }
    );
};
is($@, '');
is(ClassA->params, 'ClassA, foo, bar, baz');
