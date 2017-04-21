# Amazon Autosuggest Scraper

Welcome! This is a simple scraper that grabs Amazon autosuggest data based on a search query. Zero or more queries can be passed, with their autosuggest data combined into a single output stream.

It supports the following features:

* Search for zero or more queries at a time
* Snowball results into new queries for infinite searching
* Collect department information (e.g. `Cell Phones & Accessories`) when available
* Write output as text or JSON, to STDOUT or a file
* Log to STDOUT or a file
* Output metrics on queries used, keywords found, and total search time

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
  -s --snowball [MAX_REQUESTS]  Enable snowball mode; integer representing max additional requests to make
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

## Snowball mode
Snowball mode uses the autosuggests results themselves to build new queries and get new suggestions in turn. For example, for the keyword “echo”, one autosuggest result might be `echo dot 2nd generation`. With snowball mode, `echo`, `dot`, `2nd`, and `generation` all become queries that are then submitted to retrieve *their* suggestions.

Since such a system could run indefinitely, to use snowball mode, pass an integer representing the maximum number of additional requests to make. For example, to stop snowballing after 10 requests total:

```
> ruby suggestions.rb -s 10
```

Combine no-query mode and snowball mode for a maximum laziness-to-results ratio!

## Examples

* Find autosuggestions for `apple` and output as text to a file:

  ```
  > ruby suggestions.rb -q apple -o apple_suggestions.txt -l log/log.txt 
  ```

  [See output](https://github.com/joshleitzel/amazon_scraper/blob/master/examples/apple_suggestions.txt)

* Find autosuggestions for `apple` and output as JSON to a file:

  ```
  > ruby suggestions.rb -q apple -f json -o apple_suggestions.json -l log/log.txt 
  ```

  [See output](https://github.com/joshleitzel/amazon_scraper/blob/master/examples/apple_suggestions.json)

* Find autosuggestions for `apple` and `pear` and output as text to a file:

  ```
  > ruby suggestions.rb -q apple,pear -o apple_pear_suggestions.txt -l log/log.txt 
  ```

  [See output](https://github.com/joshleitzel/amazon_scraper/blob/master/examples/apple_pear_suggestions.txt)

* Find random autosuggestions and output to STDOUT:

  ```
  > ruby suggestions.rb -l log/log.txt
  ```

  [See output](https://github.com/joshleitzel/amazon_scraper/blob/master/examples/random.txt)

* Find random autosuggestions with snowballing and output to STDOUT:

  ```
  > ruby suggestions.rb -s 10 -l log/log.txt 
  ```

  [See output](https://github.com/joshleitzel/amazon_scraper/blob/master/examples/random_snowballing.txt)

* Find random autosuggestions with lots of snowballing and output to file:

  ```
  > ruby suggestions.rb -s 300 -o examples/snowball_300.txt -l log/log.txt 
  ```

  [See output](https://github.com/joshleitzel/amazon_scraper/blob/master/examples/snowball_300.txt)
