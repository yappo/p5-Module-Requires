use strict;
use warnings;
use lib 't/lib';
use Test::More;

eval {
    require Module::Requires;
    Module::Requires->import(
        'ClassD',
    );
};
like($@, qr/Can't locate ClassD.pm/);
ok(!ClassA->can('package'));

eval {
    require Module::Requires;
    Module::Requires->import(
        'ClassD',
        'ClassA',
    );
};
like($@, qr/Can't locate ClassD.pm/);
ok(ClassA->can('package'));

done_testing;
