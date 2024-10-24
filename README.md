# DHLog
Basic PowerShell Logging Module

This function adds more robust logging functionality for other scripts and functions. Each log entry is composed of three parts: timestamp, log level, and the message. The timestamp is in the following format: "yyyy-MM-dd HH:mm:ss:fff". There are five (5) log levels: ERROR, WARN, INFO, DEBUG, VERBOSE. Each of these direct output to a corresponding stream as well as to the log. (ERROR to the Error stream, WARN to the Warning stream, INFO to the Verbose stream, DEBUG to the Debug stream, VERBOSE to the Verbose stream).