use strict;
use warnings;
use lib 't/lib';
use Test::More;
require Module::Requires;

eval {
    Module::Requires->import(
        'ClassA' => {
            import => [qw/ foo bar baz /],
        }
    );
};
like($@, qr/ClassA is unloaded because -autoload an option is lacking./);

ok(!ClassA->can('package'));

eval {
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
ok(!ClassA->can('package'));
ok(!ClassC->can('package'));

eval {
    Module::Requires->import(
        '-autoload',
        'ClassA' => {
            import => [qw/ foo bar baz /],
        }
    );
};
is($@, '');
is(ClassA->params, 'ClassA, foo, bar, baz');

done_testing;
