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

done = 0

loop do
  messages = 0.upto(rand(5)).map do |n|
    done += 1
    { topic: "random_numbers", payload: done.to_s, key: done.to_s }
  end
  FooProducer.producer.publish_list(messages)

  sleep 10
end
