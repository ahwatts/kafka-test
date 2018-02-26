#!/usr/bin/env ruby

require "phobos"

class FooProducer
  include Phobos::Producer
end

Phobos.configure({
    logger: {
      file: false,
    },
    kafka: {
      client_id: "foo-producer",
      seed_brokers: [
        "kafka1:9092",
        "kafka2:9092",
        "kafka3:9092",
      ],
    },
    producer: {},
  })
srand(Time.now.to_i)

loop do
  t = Time.now

  messages = 0.upto(rand(5)).map do |n|
    nn = rand(100)
    { topic: "random_numbers", payload: "at #{t}: #{nn}", key: nn.to_s }
  end
  FooProducer.producer.publish_list(messages)

  sleep 15
end
