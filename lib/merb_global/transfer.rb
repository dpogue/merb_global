module Merb
  module Global
    module Provider
      ##
      # Transfer data from importer into exporter
      #
      # ==== Parameters
      # importer<Importer>:: The provider providing the information
      # exporter<Exporter>:: The provider receiving the information
      def self.transfer(importer, exporter)
        exporter.start_export do
          importer.import(exporter)
        end
      end
      ##
      # Importer is a provider through which one can iterate.
      # Therefore it is possible to import data from this source
      module Importer
        ##
        # This method iterates through the data and calles the export method
        # of exporter
        #
        # ==== Parameters
        # exporter<Exporter>:: Exporter to which it should be exported
        # 
        # ==== Raises
        # NoMethodError:: Raised by default implementation.
        #                 Should not be thrown.
        def import(exporter)
          raise NoMethodError.new('method import has not been implemented')
        end
      end

      ##
      # Some sources are not only read-only but one can write to them.
      # The provider is exporter if it handles this sort of source.
      module Exporter
        ##
        # This method handles all transaction stuff that is needed.
        # It also should do a initialization and/or cleanup of all resources
        # needed specificly to the transfer as well as the final
        # flush of changes.
        # ==== Yields
        # A block in which the transfer is handled
        def export # Better name needed
          Merb.logger.error('No transaction has been set by exporter')
          yield
        end
        ##
        # This method exports a single message. Please note that the calles
        # may be not in any particular order.
        # ==== Parameters
        # language:: Language data (yielded by Language call)
        # msgid<String>:: Orginal string
        # msgstr<String>:: The translation
        # msgstr_index<Integer>:: The number of form (nil if only singular)
        def export_string(language, msgid, msgstr, msgstr_index)
          raise NoMethodError.new('method export has not been implemented')
        end
        ##
        # This method export an language. It is guaranteed to be called
        # before any of the messages will be exported.
        #
        # ==== Parameters
        # language<String>:: Language call
        # plural<String>:: Format of plural
        # ==== Yields
        # language:: The data about language
        def export_language(language, plural)
          raise NoMethodError.new('method export has not been implemented')
        end
      end
    end
  end
end
