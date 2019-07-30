# stringsaver

CLI for saving notes and strings with a description in a local **PostgreSQL** database.

Written in **Haskell**; current version: **0.3.0**

## Usage
### Build

To build the executable, you need *Stack*. Run
```
stack build
```
in the terminal: this will create an executable called *linksaver-exe* in .stack-work/dist/\<OS\>/build/linksaver-exe/

### Fetching and saving data
The program needs you to have a running instance of PostgreSQL database in your machine, which will connect to when executed. The default username, database and table must be defined in *Fill.hs*: if you don't set these variables to your desired defaults, you will need to pass *-u* (username), *-D* (database), *-t* (table) as arguments to the program. 
Your table must have three columns: the primary key column and two Text columns, which will represent the string and the description respectively.  

#### Fetch data
To fetch the data, run
```
stringsaver -r -D database -u user -t table
```
*-r* (read) is the default option so you can ommit it; if you have defined your default variables, then this command
``` 
stringsaver 
```
is equivalent to that above.

#### Save data
To save a link you need to use the *-s* (save) option, with an optional *-d* (description). The link you want to save is copied from you clipboard so you don't need to pass it explicitely, but you could do it with *-l* (link): if you have both data in your clipboard and passed a link explicitely, the latter will be saved. **Note**: if you pass explicitely a string with *-l*, it cannot have hyphens (-) in it.

Example:
```
stringsaver -s -d Descripion of the link
```
will save the data in your clipboard as the link and "Description of the link" as its description.

### Remove data
To remove an entry you need to pass the program the *-rm* flag, alongside with *-id \<id of link\>*

Example
```
stringsaver -rm -id 27
```
will remove the row with an id of 27.
