module CryptKeeper
  VERSION = "0.1.0"
  class Connection
    def initialize(*args)
      options = {}
      options.merge!(args.pop) if args.last.kind_of? Hash
    end
  end
end