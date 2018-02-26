#!/usr/bin/env ruby

require "ruby-kafka"

client = Kafka::Client.new(seed_brokers: "kafka1:9092,kafka2:9092,kafka3:9092", client_id: "test_producer")

done = 0
last_printed = {}
client.each_message(topic: "random_numbers") do |message|
  p message

  if last_printed[message.partition].to_i < message.offset
    last_printed[message.partition] = message.offset
  end

  done += 1
  if done % 100 == 0
    p last_printed
    p client.last_offsets_for("random_numbers")
  end
end
