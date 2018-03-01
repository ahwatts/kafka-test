#!/usr/bin/env ruby

require "ruby-kafka"

$stdout.sync = true
$stderr.sync = true

threads = 0.upto(2).map do |partition|
  Thread.new do
    client = Kafka::Client.new(seed_brokers: "kafka1:9092,kafka2:9092,kafka3:9092", client_id: "test_consumer")
    offset = :earliest

    loop do
      puts "Fetching from partition #{partition} at offset #{offset.inspect}"

      begin
        messages = client.fetch_messages(topic: "random_numbers", partition: partition, offset: offset)
      rescue
        $stderr.puts("Exception fetching messages: #{$!.message}")
        # client = Kafka::Client.new(seed_brokers: "kafka1:9092,kafka2:9092,kafka3:9092", client_id: "test_consumer")
      end

      if messages != nil && !messages.empty?
        messages.each do |message|
          if message.value.to_i != message.offset
            puts "Mismatched: #{message.inspect}"
          end
        end
        offset = messages.last.offset + 1
      end

      puts "Partition #{partition} at offset #{offset.inspect}"

      sleep 10
    end
  end
end

threads.each { |t| t.join }

# client = Kafka::Client.new(seed_brokers: "kafka1:9092,kafka2:9092,kafka3:9092", client_id: "test_producer")

# done = 0
# last_printed = {}
# client.each_message(topic: "random_numbers") do |message|
#   p message

#   if last_printed[message.partition].to_i < message.offset
#     last_printed[message.partition] = message.offset
#   end

#   done += 1
#   if done % 100 == 0
#     p last_printed
#     p client.last_offsets_for("random_numbers")
#   end
# end
