#!/usr/bin/env python

import sqlite3
import argparse

def init_argparse() -> argparse.ArgumentParser:
    parser = argparse.ArgumentParser(
        usage="%(prog)s -i [input aup3] -o [output raw]...",
        description="Dump raw waveform data from aup3 project file to 32bit float raw audio file."
    )
    parser.add_argument(
        "-v", "--version", action="version",
        version = f"{parser.prog} version 1.0.0"
    )
    parser.add_argument(
        "-i", "--input",
        required=True
    )
    parser.add_argument(
        "-o", "--output",
        required=True
    )
    return parser

parser = init_argparse()
args = parser.parse_args()
    
con = sqlite3.connect(args.input)
cur = con.cursor()
for sample in cur.execute("SELECT samples from sampleblocks;"):
    with open(args.output, 'ab') as file:
        file.write(sample[0])
con.close();






