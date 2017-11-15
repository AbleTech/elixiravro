# Elixiravro

Investigation on Erlavro library written for serializing messages in Avro in ERlang VM.

## Installation
The package is not available in Hex and is just for demonstration purpose.

clone the repository and cd into it
```
$ mix mix deps.get
```

## Generate Avro file samples
```
$ mix run ./lib/elixiravro.ex
```

The `/data` folder is split into 3 categories:
* **0-simple-structure**: schema and content files for a simple schema structure
* **1-complex-structure**: schema and content files for a complex schema structure
* **2-notifier-service**: schema and content files for the notifier service message structure.

## Results
The `/results` folder shows the binary files generated in Elixir *(.avro files)* and the results generated from the `avro-tools` cli *(.cli.json files)*.

### avro-tools
`avro-tools` is the testing reference to make sure the files generated in Elixir can be read back in json format. Everything read with the cli tool can be read in Ruby with ease.

To install `avro-tools`
```
$ brew install avro-tools
```
Paste those commands in your terminal to read the files generated in Elixir. _You need to first generate the samples with Elixir_
```
avro-tools tojson ./data/results/0-simple-structure.avro > ./data/results/0-simple-structure.cli.json
avro-tools tojson ./data/results/1-complex-structure.avro > ./data/results/1-complex-structure.cli.json
avro-tools tojson ./data/results/2-notifier-service.avro > ./data/results/2-notifier-service.cli.json
```

## Gotchas
Below is the full schema from erlavro library used for testing. Two fields were raising errors when trying to generate the avro file in Elixir from a json file.

* bytesField
```
{"name": "bytesField", "type": "bytes"},
```
* fixedField
```
  {"name": "fixedField", "type":
   {"type": "fixed", "name": "MD5", "size": 16}},
```

To make the examples work I needed to remove those definitions from the schema. Everything else works fine out of the box. You can compare that structure with the one in `./data/1-complex-structure`

```
{"type": "record", "name":"Interop", "namespace": "org.apache.avro",
  "fields": [
      {"name": "intField", "type": "int"},
      {"name": "longField", "type": "long"},
      {"name": "stringField", "type": "string"},
      {"name": "boolField", "type": "boolean"},
      {"name": "floatField", "type": "float"},
      {"name": "doubleField", "type": "double"},
      {"name": "bytesField", "type": "bytes"},
      {"name": "nullField", "type": "null"},
      {"name": "arrayField", "type": {"type": "array", "items": "double"}},
      {"name": "mapField", "type":
       {"type": "map", "values":
        {"type": "record", "name": "Foo",
         "fields": [{"name": "label", "type": "string"}]}}},
      {"name": "unionField", "type":
       ["boolean", "double", {"type": "array", "items": "bytes"}]},
      {"name": "enumField", "type":
       {"type": "enum", "name": "Kind", "symbols": ["A","B","C"]}},
      {"name": "fixedField", "type":
       {"type": "fixed", "name": "MD5", "size": 16}},
      {"name": "recordField", "type":
       {"type": "record", "name": "Node",
        "fields": [
            {"name": "label", "type": "string"},
            {"name": "children", "type": {"type": "array", "items": "Node"}}]}}
  ]
}
```

