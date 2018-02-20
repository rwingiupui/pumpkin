module LockWarningHelper
  def lock_warning
    return nil unless lock_id? && @presenter.try(:lock?)
    content_tag(:h1,
                'This object is currently queued for processing.',
                class: 'alert alert-warning')
  end

  private

    def lock_id?
      @presenter.try(:id).present?
    end
end
