cinnamonroll
=============

## What's this ?

This is **the tool for the CSS** that **decompiling/compiling** to the **".cinnamonroll"**/".css" type, wrinte in the *haskell* use with the *Parsec library*.

Notes:

* The cinnamonroll is the tool for writing/managing CSS to **easy** for a human **like me**. :)
* It's not a validator.
    * very loose allowance for a CSS syntax.
    * parsing follow the "cinnamonroll rule".
        * the top level of a CSS has cinnamonroll blocks.
        * the second level of a CSS has selector blocks.
        * the third level of a CSS has property blocks.
        * the charactor of '@' called "cinnamonroll". :)

### How to Run it

In the directory: src/cinnamonroll.lhs

It's the command line tool writen in literate haskell.

#### Usage for an instant

Decompile to .cinnamonroll from .css

    % ./cinnamonroll.lhs -d source.css

Compile to .css from .cinnamonroll

    % ./cinnamonroll.lhs -c source.cinnamonroll

#### Build and Install

    % ghc cinnamonroll.lhs
    % ln -s `pwd`/cinnamonroll /usr/local/bin/cinnamonroll

Note: you can install to the other path as you like.

#### Requirement

*   [GHC][GHC]   (>=7.4.1)

### Use the backend library

In the directory: src/WRP/CSS.hs

This is the library of the "WRP.CSS". The command line tool require it. This is the entity of the software. You can use it if you need for a your haskell programs.

## Specification

### Digest

* available implements
    * write with space indent match to a level of nest
    * omit comment blocks

* planed feature
    * optimization options

* no plan
    * no-omit comment blocks option

### .cinnamonroll

(Now Preparing)

## Licence

### for Software

[MIT/X11][L:MIT/X11]

[L:MIT/X11]: http://www.opensource.org/licenses/mit-license

### for Document

[CC-BY/2.1(ja)][L:CC-BY/2.1(ja)]

[L:CC-BY/2.1(ja)]: http://creativecommons.org/licenses/by/2.1/jp/deed.en

## Contact

*   GitHub  : [GitHub][C:github]

*   Website : [Wonder Rabbit Project][C:website]
*   E-Mail  : [usagi@WonderRabbitProject.net][C:email]
*   Facebook: [usagi.wrp][C:facebook]
*   Twitter : [@USAGI\_WRP][C:twitter]

[C:github]:   https://github.com/usagi/cinnamonroll

[C:website]:  http://www.WonderRabbitProject.net
[C:email]:    mailto:usagi@WonderRabbitProject.net
[C:facebook]: https://www.facebook.com/usagi.wrp
[C:twitter]:  https://twitter.com/#!/USAGI_WRP

[GHC]: http://www.haskell.org/ghc/

