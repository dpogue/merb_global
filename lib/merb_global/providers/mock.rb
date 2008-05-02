module Merb
  module Global
    module Providers
      class Mock #:nodoc:
        def translate_to singular, plural, opts
          opts[:n] > 1 ? plural : singular
        end
        def supported? lang
          true
        end
      end
    end
  end
end
