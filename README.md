# LocaleManager AS3 (AIR Only)

## What is it? ##
The LocaleManager provides dyinamic localization support for ActionScript AIR only apps. It takes care of loading/parsing resource bundle files (*.txt) and returns localized resources based on the locales provided from the external JSON file.

Because it is using FileStream, it currently supports only AIR apps. 

## Resource files

The bundle files are stored in `app://locale/[xx_XX]/[xx_XX].txt`  (ie.: `app://locale/en_US/en_US.txt`). Make sure the directory "locale" is copied to your build package:

* Put the directory locale in your src directory.
* Or add the directory containing 'locale' to your Source Path (Flash Builder: Project > Properties > ActionScript Build Path > Source Path).

The content format for bundle files is `KEY = Value` followed by a line break. __You can use the "=" character within the value, but not for keys or comments.__

    # Any line without the "equals" character is a comment. 
    A leading # does not harm.
    LABEL_FIRSTNAME = Firstname
    LABEL_LASTNAME  = Lastname


## How to use it? ##

## To Do ##
- [ ] Create/Make Tests
