# Amazon Autosuggest Scraper

Welcome! This is a simple scraper that grabs Amazon autosuggest data based on a search query. Zero or more queries can be passed, with their autosuggest data combined into a single output stream.

It supports the following features:

* Search for zero or more queries at a time
* Write output as text or JSON, to STDOUT or a file
* Logging to STDOUT or a file

## Find autosuggestions

Run the tool using the following (note, only tested on Ruby 2.3):

```
ruby suggestions.rb
```

The following options are accepted:

```
  -q --query [QUERY]            One or more search queries separated by commas (e.g. 'apple,headphones')
  -o --output [OUTPUT_FILE]     File to write output (defaults to STDOUT)
  -f --format [FORMAT]          Format to write output – 'json' or 'text', defaults to 'text'
  -l --log [LOGFILE]            File to write logs to (defaults to STDOUT)
```

## Zero queries


## Examples

* Find autosuggestions for `apple` and output as JSON to a file:

```
ruby suggestions.rb -q apple -f json -l log.txt -o apple_suggestions.json
```
