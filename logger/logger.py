#!/usr/bin/python3
import sys, syslog
def logger(msg):
    syslog.openlog(ident="Failed Login", facility=syslog.LOG_LOCAL1)
    syslog.syslog(syslog.LOG_WARNING, (msg) + "\n\n")
