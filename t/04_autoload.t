use strict;
use warnings;
use lib 't/lib';
use Test::More;

eval {
    require Module::Requires;
    Module::Requires->import(
        'ClassA' => {
            import => [qw/ foo bar baz /],
        }
    );
};
like($@, qr/ClassA is unloaded because -autoload an option is lacking./);

ok(ClassA->can('package'));

eval {
    require Module::Requires;
    Module::Requires->import(
        'ClassA' => {
            import => [qw/ foo bar baz /],
        },
        'ClassC' => {
            import => [qw/ foo bar baz /],
        }
    );
};
like($@, qr/ClassA is unloaded because -autoload an option is lacking.\nClassC is unloaded because -autoload an option is lacking./);

eval {
    require Module::Requires;
    Module::Requires->import(
        '-autoload',
        'ClassA' => {
            import => [qw/ foo bar baz /],
        }
    );
};
is($@, '');
is(ClassA->params, 'ClassA, foo, bar, baz');
