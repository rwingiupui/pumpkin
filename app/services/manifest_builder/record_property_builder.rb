class ManifestBuilder
  class RecordPropertyBuilder
    attr_reader :record, :path
    def initialize(record, path)
      @record = record
      @path = path
    end

    def apply(manifest)
      manifest['@id'] = path.to_s
      manifest.label = record.to_s
      manifest.description = record.description
      manifest.viewing_hint = viewing_hint if viewing_hint
      manifest.try(:viewing_direction=, viewing_direction) if viewing_direction
    end

    private

      def viewing_direction
        record.try(:viewing_direction) || "left-to-right"
      end

      def viewing_hint
        record.viewing_hint || "individuals"
      end
  end
end
