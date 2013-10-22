module Deviant
  def self.exception(e, data = {})
    client.store e.class.name, e.message, data
  end

  def self.method_missing(method, *args, &block)
    if args.length > 0 && method.to_s[-1] == '!' && respond_to?(method.to_s[0...-1])
      send method.to_s[0...-1], *args, &block
      raise args.first
    end

    super
  end
end