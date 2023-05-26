module Test
    @tests = mytests = [
        'x = 2;',
        'print(x);',
        'if (x==2) x = 4; else x = 8;',
        'if (x==9) x = 3; else x = 10;',
        'x = x + 2;',
        'x = x - 4;',
        '4 == 2',
        '4 > 2',
        '4 < 2',
        '2 >= 2',
        '2 <= 2',
        '4 >= 2',
        '4 <= 2',
        'y = 3;',
        'x = y;',
        'y = y + y;',
        'y = y * 3;',
        'y = y / 3;',
        'while (y > 1) y = y - 1;',
        'print(y);',
        'print(y*2);'
    ]

    def self.tests
        @tests
    end
end

# if (3 == 2) print(3); else print(2);

# @value = !!(value)