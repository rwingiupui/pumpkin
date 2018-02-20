module CurationConcerns::LockWarning
  extend ActiveSupport::Concern

  included do
    def lock_warning
      flash.now[:alert] = "This object is currently queued for processing." if
        lock_id? && presenter.lock?
    end

    private

      def lock_id?
        presenter.try(:id).present?
      end
  end
end
