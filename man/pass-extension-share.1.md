% pass-extension-share(1) "user commands" 0.1.0
% Anthony Bible
% July 2022

# NAME
pass-extension-share make password sharing easy, even grandma can do it

# SYNOPSIS
**share** [*OPTION*] pass-name

# DESCRIPTION
**share** uses curl to upload what is returned from `pass pass-name` to https://password.exchange and returns a url the user can access the password.

# OPTIONS
**-h**, **--help**
: Displays a friendly help message

**-p**, **--passphrase**
: A passphrase to protect the webpage, you can use the reciepents last name

**-H**, **--head**
: Only upload the first line

**-t**, **--tail**
: Only upload the last line

# ENVIRONMENT VARIABLES
*PASSWORD_SHARE_ENDPOINT* 
: The endpoint to upload password to. (See https://github.com/Anthony-Bible/password-exchange)

# EXAMPLES
**pass share -p smith email/example@example.com**
: Uploads information from email/example@example.com and protects the webpage with the passphrase `smith`

**pass share -h email/example@example.com**
: Uploads the first line from email/example@example.com

**pass share -t social/facebook/user1**
: Uploads the last line from social/facebook/user1

# BUGS
Currently the program will stop processing arguments once it encounters it's first non-option. Please submit any bugs to https://github.com/Anthony-Bible/password-store-extension/issues

# COPYRIGHT
Copyright © 2022 Anthony Bible. License Apache-2.0: <https://www.apache.org/licenses/LICENSE-2.0.txt> This is Free Software: you are free to change and distribute it. There is NO WARRANTY, to the extent permitted by law 
