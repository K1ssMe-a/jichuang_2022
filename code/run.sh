#!/bin/bash

gcc bmp.c LCDI.c main.c matrix.c weight.c -std=c99 -O3 -o out
