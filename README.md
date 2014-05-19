![quick-wb logo](https://github.com/jeanlescure/quick-wb/raw/master/misc/logo.png)

# Quick WEBrick

Run a WEBrick server locally and serve any folder on any port of your choice, quickly and hassle-free.

## Dependencies

Quick WEBrick depends on the 'gli', before running it execute the following from your cli:

    gem install gli
    
## Running Quick WEBrick

### On Unix Based Operating Systems
## (e.g. Ubuntu, MacOS X)

Make the quick-wb script executable:

    $ chmod 744 bin/quick-wb

Run the server:

    $ cd bin
    $ ./quick-wb
    
### On Windows

Just run the provided exe from the win-dist folder.

This executable file is compiled using Ocra from the latest stable version.

## Easy Execution In Any Folder

In order to start `quick-wb` on any folder quickly and easily simply add the `path/to/quick-rb/dir` to your **PATH** environment variable.

This works on most mainstream operating systems.

## ![PHP](http://www.php.net/images/logo.php) Now Supported!

Run the server with php command:

    quick-wb php
    
Override php installation directory:

    quick-wb php --phpdir="c:\dev\php-5.4"

### Note: This feature has only been tested on windows platforms, so take into mind the following considerations:

* The default directory for php is currently set as `c:\php`. In future patches I'll dynamically change this based on common OS definitions. (e.g. `/private/etc` for MacOS X, and `/usr/share/php5` for Ubuntu)

* In good theory Quick WEBrick *should* work on any OS given that you override the default directory using the `--phpdir` flag as shown above. **Do** let me know if it happens otherwise.

## For more help

To view quick-wb's help info about commands and arguments, run:

On Linux: `$ ./quick-wb help`

On Windows: `quick-wb help`