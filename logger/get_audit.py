import os, sys
from logger import logger

with open('./John.csv', 'r') as in_file:
    for in_line in in_file.readlines():
        logger(in_line)
