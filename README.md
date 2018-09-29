# linksaver

CLI for saving links (but also any other string of text) with a description in a local **PostgreSQL** database.

Written in **Haskell**; current version: **0.3.0**

## Usage
### Build

To build the executable, you need *Stack*. Run
```
stack build
```
in the terminal: this will create an executable called *linksaver-exe* in .stack-work/dist/\<OS\>/build/linksaver-exe/

### Fetching and saving data
The program needs you to have a running instance of PostgreSQL database in your machine, which will connect to when executed. The default username, database and table must be defined in *Fill.hs*: if you don't set these variables to your desired defaults, you will need to pass *-u*, *-D*, *-t* as arguments to the program. 

#### Fetch data
To fetch the data, run
```
linksaver -r -D database -u user -t table
```
*-r* (read) is the default option so you can ommit it; if you have defined your default variables, then this command
``` 
linksaver 
```
is equivalent to that above.

#### Save data
To save a link you need to use the *-s* (save) option, with an optional *-d* (description). The link you want to save is copied from you clipboard so you don't need to pass it explicitely, but you could do it with *-l* (link): if you have both data in your clipboard and passed a link explicitely, the latter will be saved.
Example:
```
linksaver -s -d Descripion of the link
```
will save the data in your clipboard as the link, and "Description of the link" as the desription.

### Remove data
To remove a link you need to pass the program the *-rm* flag, alongside with *-id \<id of link\>*
Example
```
linksaver -rm -id 27
```
will remove the row with an id of 27.