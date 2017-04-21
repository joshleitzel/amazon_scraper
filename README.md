# Amazon Autosuggest Scraper

Welcome! This is a simple scraper that grabs Amazon autosuggest data based on a search query. Zero or more queries can be passed, with their autosuggest data combined into a single output stream.

It supports the following features:

* Search for zero or more queries at a time
* Collect department information (e.g. `Cell Phones & Accessories`) when available
* Write output as text or JSON, to STDOUT or a file
* Log to STDOUT or a file

## Find autosuggestions

Run the tool using the following (note, only tested on Ruby 2.3):

```
> ruby suggestions.rb
```

The following options are accepted:

```
  -q --query [QUERY]            One or more search queries separated by commas (e.g. 'apple,headphones')
  -o --output [OUTPUT_FILE]     File to write output (defaults to STDOUT)
  -f --format [FORMAT]          Format to write output – 'json' or 'text', defaults to 'text'
  -l --log [LOGFILE]            File to write logs to (defaults to STDOUT)
```

## No-query mode

If you don’t want to pass your own query, you don’t have to! We’ll auto-generate a two-character query composed of one letter and one vowel. Try it!

```
> ruby suggestions.rb

  Query                Keywords                       Departments

  os                   oscillating fan                Home & Kitchen, Appliances
  os                   osmo
  os                   oscillococcinum
  os                   ostrim
  os                   oster blender replacement parts
  os                   osprey backpack
  os                   osteo biflex triple strength
  os                   ostrich feathers
  os                   oster blender
  os                   oster clippers
```

## Examples

* Find autosuggestions for `apple` and output as JSON to a file:

```
> ruby suggestions.rb -q apple -f json -l log.txt -o apple_suggestions.json
```
