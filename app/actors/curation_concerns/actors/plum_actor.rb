module CurationConcerns::Actors
  class PlumActor < ::CurationConcerns::Actors::BaseActor
    def update(attributes)
      super.tap do |result|
        messenger.record_updated(curation_concern) if result
      end
    rescue => err
      update_or_create_error(err)
    end

    def create(attributes)
      super
    rescue => err
      update_or_create_error(err)
    end

    private

      def messenger
        @messenger ||= ManifestEventGenerator.new(Plum.messaging_client)
      end

      # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
      def update_or_create_error(err)
        case err
        when RemoteRecord::BibdataError
          error_ui_text = err.to_s
        when JSONLDRecord::MissingRemoteRecordError
          error_ui_text = "The entered ID did not match any " \
                          "#{I18n.t('services.metadata')} records."
          error_log_text = "No #{I18n.t('services.metadata')} record found: " \
                           "#{curation_concern.source_metadata_identifier}: " \
                           "#{err}"
        when IuMetadata::MarcRecord::MarcParsingError
          error_ui_text = err.to_s
          error_log_text = "MARC parsing failed: " \
                           "#{curation_concern.source_metadata_identifier}: " \
                           "#{err}"
        else
          error_ui_text = 'An unexpected error occurred.'
          error_log_text = "Unexpected error type #{err.class}: " \
                           "#{curation_concern.source_metadata_identifier}: " \
                           "#{err}"
        end
        error_log_text ||= ''
        curation_concern.errors.add :source_metadata_identifier, error_ui_text
        Rails.logger.debug error_log_text if error_log_text.present?
        false
      end
    # rubocop:enable Metrics/AbcSize, Metrics/MethodLength
  end
end
