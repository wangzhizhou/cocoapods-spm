require "json"

module Pod
  module SPM
    class Metadata
      attr_reader :raw

      def initialize(raw)
        @raw = raw
      end

      def self.load(path)
        new(JSON.parse(File.read(path)))
      end

      def targets
        raw["targets"]
      end

      def targets_of_type(type)
        targets.select { |t| t["type"] == type }
      end

      def macro_impl_name
        targets_of_type("macro").first&.fetch("name")
      end
    end
  end
end