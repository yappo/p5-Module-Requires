use strict;
use warnings;
use lib 't/lib';
use Test::More;

eval {
    require Module::Requires;
    Module::Requires->import('ClassA', [ '>' => 0.4 ]);
};
like($@, qr/ClassA version > 0.04 required--this is only version 0.02/);

ok(ClassA->can('package'));

eval {
    require Module::Requires;
    Module::Requires->import('ClassA', [ '<' => 0.2 ]);
};
like($@, qr/ClassA version < 0.02 required--this is only version 0.02/);

eval {
    require Module::Requires;
    Module::Requires->import('ClassA', [ '<' => 0.2, '>' => 0.02 ]);
};
like($@, qr/ClassA version < 0.02 AND > 0.02 required--this is only version 0.02/);

eval {
    require Module::Requires;
    Module::Requires->import('ClassA', [ '<=' => 0.1, '>=' => 0.03 ]);
};
like($@, qr/ClassA version <= 0.01 AND >= 0.03 required--this is only version 0.02/);

eval {
    require Module::Requires;
    Module::Requires->import('ClassA', [ '>' => 0.1, '!=' => 0.02 ]);
};
like($@, qr/ClassA version > 0.01 AND != 0.02 required--this is only version 0.02/);

eval {
    require Module::Requires;
    Module::Requires->import('ClassA', [ '>' => 0.2, '=' => 0.02 ]);
};
like($@, qr/ClassA version check syntax error/);

eval {
    require Module::Requires;
    Module::Requires->import('ClassA', [ '>' => 0.2, 'y' ]);
};
like($@, qr/ClassA version check syntax error/);

eval {
    require Module::Requires;
    Module::Requires->import('ClassA', [ '>' => 0.1, '!=' => 0.03 ]);
};
is($@, '');
