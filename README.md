# Random Token

[![Gem Version](https://badge.fury.io/rb/random_token.png)][gem]
[![Build Status](https://travis-ci.org/sibevin/random_token.png?branch=build)][travis]

[gem]: https://rubygems.org/gems/random_token
[travis]: https://travis-ci.org/sibevin/random_token

A simple way to generate a random token.

    jjukoguwegcvclkuhljvsblrpfnd
    je         dzl            pu
    qu  yrllvr  bsnehow  pplshyo
    sw  hwzedi  cnjdpqw  pnuctvl
    fY  sJmss  msg2Qpbx  7sgtFpD
    5V        90Ofl83da  3TQ6fQj
    il  q93H  GLpCNvakC  Fd0ppyd
    QW  TWZLX  WFQUWYMD  MJSYRJI
    IX  AIVBZI  andomPR  okenYIN
    DRRJVYVMEVREBFYXLLFQGISGAGED

## Usage

### Basic

Use "gen" method with a format string to create a random token.

    RandomToken.gen("%8?")
    # "6HRQZp8O"

    RandomToken.gen("%4H-%4H-%4H-%4H")
    # "FD77-2792-91A9-6CE3"

Or just give the token length.

    RandomToken.gen(8)
    # "iUEFxcG2"

Some options can help to modify the token format.

    RandomToken.gen(20, seed: :alphabet, friendly: true, case: :up)
    # "YTHJHTXKSSXTPLARALRH"

Or just simplify as:

    RandomToken.gen(20, s: :a, f: true, c: :u)
    # "YTHJHTXKSSXTPLARALRH"

### Format

You can embed random tokens in your own string using a format string. Here are some examples:

    RandomToken.gen("%2A-%4n")
    # "VS-6921"

    RandomToken.genf("Your redeem code: %16?")
    # "Your redeem code: 4xgRH2JaLxtR3dWK"

    RandomToken.gen("Lucky Number = %n")
    # "Lucky Number = 8"

The directive consists of a percent(%), length, and type.

    %[length][type]

where

*   length

> The length of random token you want to create. The default value is 1 if no length is given.

*   type

> A - upper-case alphabets  
> a - down-case alphabets  
> n - numbers  
> b - binaries  
> o - octal digits  
> H - upper-case hexadecimal digits  
> h - down-case hexadecimal digits  
> X - upper-case alphabets and numbers  
> x - down-case alphabets and numbers  
> ? - mixed-case alphabets and numbers  
> % - show the % sign  

`:seed`, `:friendly`, `:case` options are supported in the format string, and they would override the type behavior.

    RandomToken.gen("%32X", seed: :a, friendly: true, case: :d)
    # "ddbpeqhtmaenxsaksxrmeaawnwpkfess"

### Length

You can just give a token length. For example:

    RandomToken.gen(8)
    # "iUEFxcG2"

The random token are created with mixed-case alphbets and numbers by default, same as the format string, you can use `:seed`, `:friendly`, `:case` options to modify the your token.

## Options

### Seed

Use `:s` (or `:seed`) option to customize the random characters. Here are available options:

Use `:a` (or `:alphabet`, `:l`, `:letter`) to create a token with alphabets.

    RandomToken.gen(32, s: :a)
    # "DTVbCnRldQnLAoERHAzjLOTJBTWoBGQb"

Use `:n` (or `:number`, `10`, `1`) to create a token with numbers.

    RandomToken.gen(32, s: :n)
    # "41107838709625922353782552721916"

Use `:b` (or `:binary`, `2`) to create a binary token.

    RandomToken.gen(32, s: :b)
    # "11101001110110110000101101010101"

Use `:o` (or `:oct`, 8) to create a octal token.

    RandomToken.gen(32, s: :o)
    # "57531726664723324643140173424423"

Use `:h` (or `:hex`, 16) to create a hexadecimal token.

    RandomToken.gen(32, s: :h)
    # "B7E1FD250D250008314496AE48EDE310"

Use an `array` to customize random seeds.

    RandomToken.gen(32, s: ['a', 'b', 'c'])
    # "cbbcbcabbbacbaaababcbcabcacbcacb"

Use a `hash` to customize random seeds and their distribution. For example, the following hash would create a token with "a" and "b" where p("a") = 1/3 and p("b") = 2/3.

    RandomToken.gen(32, s: { 'a' => 1, 'b' => 2 })
    # "bbabbaaaabaabbbabbbbbbbbbaababbb"

### Friendly & Mask

Use `:f` (or `:friendly`) option to remove the ambiguous characters, the default mask includes *1, I, l, i, 0, O, o, Q, D, C, c, G, 9, 6, U, u, V, v, E, F, M, N, 8, B*.

    RandomToken.gen(32, f: true)
    # "fjx5WTb4wbPmbwb7b4szzY4szfrqtJLj"

The default `:friendly` option is false. There is a convenient method "genf" using `friendly: true` by default.

    RandomToken.genf(32)
    # "kPafJh5gHAPJjYsssjW7yhthPr4Zg4t3"

Friendly is not supported with some `:seed` options(`:b`, `:o`, `:h` and customized hash seeds).

    RandomToken.genf(32, s: :b)
    # RandomToken::RandomTokenError: RandomToken::RandomTokenError

Use `:m` (or `:mask`) to customize your own friendly mask. Note that `:friendly` is true by default if `:mask` is given.

    RandomToken.gen(32, m: ['a', 'A', 'b', 'c'])
    # "QlHhMpfrGnOykMS8tpfYrW0EnqvRsItw"

### Case

Use `:c` (or `:case`) option to modify the token case. Here are available options:

Use `:u` (or `:up`) to create an upper-case token.

    RandomToken.gen(32, c: :u)
    # "YKNOAMC5FQZTMRS9U3SI4U9QWEMU7TLL"

Use `:d` (or `:down`) to create a down-case token.

    RandomToken.gen(32, c: :d)
    # "8fvs6dfxko4buxcho23vz5jpxw9arj7t"

Use `:m` (or `:mixed`) to create a mixed-case token. It is the default option.

    RandomToken.gen(32, c: :m)
    # "BjWRJjU2iKF2O1cKrWpnF1EzZHuoUCM5"

Case is not supported with some `:seed` options(`:n`, `:b`, `:o` and customized hash seeds).

    RandomToken.gen(32, s: :n, c: :u)
    # RandomToken::RandomTokenError: RandomToken::RandomTokenError

With :hex seed, i.e, `s: :h`, the default case is changed to upper-case. You can override it by giving the `:case` option.

    RandomToken.gen(32, s: :h, c: :d)
    # "d331ce7dae87f3bb3dcb3975be9c430d"

## Use Cases

### Case 1

How to create a RPG random desert map?

    1.upto(10).each { puts RandomToken.gen(28, s: { '.' => 1000, 'o' => 20, 'O' => 5, '_' => 1 }) }

    ............................
    .......................O.o..
    ............................
    ........................_...
    .....o...............O......
    ............................
    ............................
    ............................
    .........o....O.............
    .o..........................

Is it a desert? Of course!! . = sand, o = small stone, O = large stone, and _ = oasis.

Oh..., I think I am not a man of imagination like you...

### Case 2

How to create a cool logo?

    puts RandomToken.gen("%28a\n%2a#{' '*9}%3a#{' '*12}%2a\n%2a  %6a  %7a  %7a\n%2a  %6a  %7a  %7a\n%2?  %5?  %8?  %7?\n%2?#{' '*8}%9?  %7?\n%2?  %4?  %9?  %7?\n%2A  %5A  %8A  %7A\n%2A  %6A  andom%2A  oken%3A\n%28A")

    ieqccitkalecvbfehlfbkejdthxc
    kt         vhk            mw
    mt  rktuhx  wvniunx  yckqxih
    gu  mbrjdf  ratkfyj  oxcvtle
    F7  tFpoz  8QZpLT1Y  vxNl778
    VZ        gXqKqXDkr  Nx1j0Ig
    n9  ee7s  UeDOXLl3D  pxf6mgH
    VM  QGSPP  VAJCAVDM  UJRCCXP
    KC  TMWEVM  andomAX  okenQNE
    NMVJJAXHHAPLDSYNHCXILCFWYAQA

Uh, I don't think it is cool enough...

## Test

Go to random_token gem folder and run

    ruby ./test/test_all.rb

## Authors

Sibevin Wang

## Copyright

Copyright (c) 2013 Sibevin Wang. Released under the MIT license.
