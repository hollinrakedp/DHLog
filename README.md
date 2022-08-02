# DHLog
Basic PowerShell Logging Module

This function adds more robust logging functionality for other scripts and functions. Each log entry is composed of three parts: timestamp, log level, and the message. The timestamp is in the following format: "yyyy-MM-dd HH:mm:ss:fff". There are three (3) log levels: ERROR, WARN, INFO. Each of these direct output to a corresponding stream as well as to the log. (ERROR to the Error stream, WARN to the Warning stream, INFO to the Verbose stream).