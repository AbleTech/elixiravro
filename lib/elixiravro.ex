defmodule Elixiravro do
  # def create_binary do
  #   store = :avro_schema_store.import_file('./lib/schema.json', :avro_schema_store.new([]))
  #   encoder = :avro.make_encoder(store, [])
  #   json_encoder = :avro.make_encoder(store, [{:encoding, :avro_json}])

  #   decoder = :avro.make_decoder(store, [])
  #   json_decoder = :avro.make_decoder(store, [{:encoding, :avro_json}])

  #   encoded = File.read!('./lib/content.json')
  #     |> (&json_decoder.('User', &1)).()
  #     |> (&encoder.('User', &1)).()
  #     |> :erlang.iolist_to_binary

  #   IO.inspect encoded

  #   {:ok, encoded_file} = File.open "0-encoding", [:write, :utf8]
  #   IO.write encoded_file, encoded
  #   File.close encoded_file

  #   decoded = File.read!('0-encoding')
  #     |> (&decoder.('User', &1)).()
  #     |> (&json_encoder.('User', &1)).()

  #   IO.inspect decoded

  #   {:ok, decoded_file} = File.open "0-decoding", [:write, :utf8]
  #   IO.write decoded_file, decoded
  #   File.close decoded_file
  # end

  def create_file(name_folder) do
    store = :avro_schema_store.import_file("./data/#{name_folder}/schema.avsc", :avro_schema_store.new([]))
    json_decoder = :avro.make_decoder(store, [{:encoding, :avro_json}])

    schema = File.read!("./data/#{name_folder}/schema.avsc")
      |> :avro_json_decoder.decode_schema
    object = File.read!("./data/#{name_folder}/content.json")
      |> (&json_decoder.(schema, &1)).()

    :avro_ocf.write_file("./data/results/#{name_folder}.avro", store, schema, [object])
  end

  def read_file(name_folder) do
    store = :avro_schema_store.import_file("./data/#{name_folder}/schema.avsc", :avro_schema_store.new([]))
    json_encoder = :avro.make_encoder(store, [{:encoding, :avro_json}])

    {_, _, objects} = :avro_ocf.decode_file("./data/results/#{name_folder}.avro")

    IO.puts objects
      |> Enum.map(&json_encoder.("domain.avro.Message", &1))
  end

  def create_simple_structure do
    create_file('0-simple-structure')
  end

  def read_simple_structure do
    read_file('0-simple-structure')
  end

  def create_complex_structure do
    create_file('1-complex-structure')
  end

  def read_complex_structure do
    read_file('1-complex-structure')
  end

  def create_notifier_service do
    create_file('2-notifier-service')
  end

  def read_notifier_service do
    read_file('2-notifier-service')
  end
end

Elixiravro.create_simple_structure
Elixiravro.read_simple_structure
Elixiravro.create_complex_structure
Elixiravro.read_complex_structure
Elixiravro.create_notifier_service
Elixiravro.read_notifier_service
