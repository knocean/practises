#!/usr/bin/env python3

import argparse


def foo(input_path, output_path):
    print('foo')


def test_foo():
    pass


def main():
    parser = argparse.ArgumentParser(description="{{ DESCRIPTION }}")
    parser.add_argument("input", type=str, help="The input file")
    parser.add_argument("output", type=str, help="The output file")
    args = parser.parse_args()

    foo(args.input, args.output)


if __name__ == "__main__":
    main()
