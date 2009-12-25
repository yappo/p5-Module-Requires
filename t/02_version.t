use strict;
use warnings;
use lib 't/lib';
use Test::More;

eval {
    require Module::Requires;
    Module::Requires->import('ClassA', '0.03');
};
like($@, qr/ClassA version 0.03 required--this is only version 0.02/);
ok(ClassA->can('package'));

eval {
    require Module::Requires;
    Module::Requires->import(
        'ClassA' => '0.03',
        'ClassB' => '0.10',
        'ClassC' => '0.30',
    );
};
like($@, qr/ClassA version 0.03 required--this is only version 0.02\nClassB version 0.10 required--this is only version 0.08\nClassC version 0.30 required--this is only version 0.12/);
eval {
    require Module::Requires;
    Module::Requires->import(
        'ClassC' => '0.99',
        'ClassA' => '0.10',
        'ClassB' => '0.30',
    );
};
like($@, qr/ClassC version 0.99 required--this is only version 0.12\nClassA version 0.10 required--this is only version 0.02\nClassB version 0.30 required--this is only version 0.08/);
ok(ClassB->can('package'));
ok(ClassC->can('package'));

eval {
    require Module::Requires;
    Module::Requires->import('ClassA', '0.02');
};
is($@, '');

done_testing;
