# README

### Ruby version
* 2.3.1

### Rails version
* 4.2.6

### Coding convention of this project
* Based on :
    * ruby-style-guide : https://github.com/dalzony/ruby-style-guide/blob/master/README-koKR.md#no-space-inside-range-literals
    * rails-style-guide : https://github.com/pureugong/rails-style-guide/blob/master/README-koKR.md

* Use 'rubocop' gem
    * This gem inspect code with **ruby-style-guide** and **rails-style-guide**
    * https://github.com/bbatsov/rubocop
    * How to install?**(Important)**
        * RailsRoot$ cd .githooks
        * .githooks$ ./install_hooks
        * **INSTALL THIS IS NECESSARY TO EVERYONE FOR COLLABORATION**
    * How to use?
        * $ rubocop
        * $ rubocop -a : fixed automatically
    * Customized setting of this project : RailsRoot/.rubocop.yml(will be improved with argument)
