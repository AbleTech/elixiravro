defmodule Elixiravro do
  @moduledoc """
  Documentation for Elixiravro.
  """

  @doc """
  Hello world.

  ## Examples

      iex> Elixiravro.hello
      :world

  """
  def hello do
    :world
  end

  def create_binary do
    store = :avro_schema_store.import_file('./lib/schema.json', :avro_schema_store.new([]))
    encoder = :avro.make_encoder(store, [])
    json_encoder = :avro.make_encoder(store, [{:encoding, :avro_json}])

    decoder = :avro.make_decoder(store, [])
    json_decoder = :avro.make_decoder(store, [{:encoding, :avro_json}])

    encoded = File.read!('./lib/content.json')
      |> (&json_decoder.('User', &1)).()
      |> (&encoder.('User', &1)).()
      |> :erlang.iolist_to_binary

    IO.inspect encoded

    {:ok, encoded_file} = File.open "0-encoding", [:write, :utf8]
    IO.write encoded_file, encoded
    File.close encoded_file

    decoded = File.read!('0-encoding')
      |> (&decoder.('User', &1)).()
      |> (&json_encoder.('User', &1)).()

    IO.inspect decoded

    {:ok, decoded_file} = File.open "0-decoding", [:write, :utf8]
    IO.write decoded_file, decoded
    File.close decoded_file
  end

  def read_binary do
    {header, schema, objects} = :avro_ocf.decode_file('./data/avro-examples/twitter.avro')
    store = :avro_schema_store.import_file('./data/avro-examples/twitter.avsc', :avro_schema_store.new([]))
    json_encoder = :avro.make_encoder(store, [{:encoding, :avro_json}])

    objects
      |> Enum.map(&json_encoder.('com.miguno.avro.twitter_schema', &1))
  end

  def read_ruby do
    {header, schema, objects} = :avro_ocf.decode_file('./data/ruby-examples/data.avro')
    store = :avro_schema_store.import_file('./data/ruby-examples/schema.json', :avro_schema_store.new([]))
    json_encoder = :avro.make_encoder(store, [{:encoding, :avro_json}])

    objects
      |> Enum.map(&json_encoder.('User', &1))
  end

  def create_file do
    filename = './data/elixir-examples/data.avro'
    store = :avro_schema_store.import_file('./data/elixir-examples/schema.avsc', :avro_schema_store.new([]))
    {:ok, type} = :avro_schema_store.lookup_type('User', store)
    json_decoder = :avro.make_decoder(store, [{:encoding, :avro_json}])
    object = File.read!('./data/elixir-examples/content.json') |> (&json_decoder.('User', &1)).()

    :avro_ocf.write_file(filename, store, type, [object])
    # - 1 you need to edfine the type make store as undefined and see from there.
    # - 2 you need to understand what is the store and what is the type
  end

  def read_elixir do
    {header, schema, objects} = :avro_ocf.decode_file('./data/elixir-examples/data.avro')
    store = :avro_schema_store.import_file('./data/elixir-examples/schema.avsc', :avro_schema_store.new([]))
    json_encoder = :avro.make_encoder(store, [{:encoding, :avro_json}])

    objects
      |> Enum.map(&json_encoder.('User', &1))
  end
end

# Elixiravro.create_binary
# Elixiravro.read_binary
# Elixiravro.create_file
# Elixiravro.read_elixir
