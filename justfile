default:
    @just --list

build:
    cd src && sbcl --non-interactive --load build.lisp
