# -*- encoding: utf-8; -*-

require "phobos"

module NewModelConsumer
  class Handler
    include Phobos::Handler

    def consume(payload, metadata)
      if payload.to_i != metadata[:offset]
        puts "Offset mismatch: #{payload.inspect} != #{metadata[:offset].inspect}"
      end
    end
  end
end

# {
#   :message => "Failed to run listener (undefined method `/' for nil:NilClass)",
#   :exception_class => "NoMethodError",
#   :exception_message => "undefined method `/' for nil:NilClass",
#   :backtrace => [
#     "/usr/local/bundle/gems/phobos-1.7.1/lib/phobos.rb:53:in `create_exponential_backoff'",
#     "/usr/local/bundle/gems/phobos-1.7.1/lib/phobos/listener.rb:124:in `create_exponential_backoff'",
#     "/usr/local/bundle/gems/phobos-1.7.1/lib/phobos/executor.rb:71:in `run_listener'",
#     "/usr/local/bundle/gems/phobos-1.7.1/lib/phobos/executor.rb:40:in `block (2 levels) in start'",
#     "/usr/local/bundle/gems/concurrent-ruby-1.0.5/lib/concurrent/executor/ruby_thread_pool_executor.rb:348:in `run_task'",
#     "/usr/local/bundle/gems/concurrent-ruby-1.0.5/lib/concurrent/executor/ruby_thread_pool_executor.rb:337:in `block (3 levels) in create_worker'",
#     "/usr/local/bundle/gems/concurrent-ruby-1.0.5/lib/concurrent/executor/ruby_thread_pool_executor.rb:320:in `loop'",
#     "/usr/local/bundle/gems/concurrent-ruby-1.0.5/lib/concurrent/executor/ruby_thread_pool_executor.rb:320:in `block (2 levels) in create_worker'",
#     "/usr/local/bundle/gems/concurrent-ruby-1.0.5/lib/concurrent/executor/ruby_thread_pool_executor.rb:319:in `catch'",
#     "/usr/local/bundle/gems/concurrent-ruby-1.0.5/lib/concurrent/executor/ruby_thread_pool_executor.rb:319:in `block in create_worker'",
#     "/usr/local/bundle/gems/logging-2.2.2/lib/logging/diagnostic_context.rb:474:in `block in create_with_logging_context'"
#   ]
# }
