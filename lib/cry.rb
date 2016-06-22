require "cry/version"

module Cry
  def on(*events, &block)
    raise ArgumentError, "must specify at least one event" unless events.any?
    events.each { |event| listeners_for(event) << block }
    self
  end

  class NoListenersError < StandardError; end

  private

  def publish(event, *args)
    listeners_for(event).each do |listener|
      listener.call(*args)
    end
  end

  def publish!(event, *args)
    raise NoListenersError, "nothing listening for #{event}" \
      unless listeners_for(event).any?
    publish(event, *args)
  end

  def listeners
    @listeners ||= {}
  end

  def listeners_for(event)
    listeners[event.to_sym] ||= []
  end
end
