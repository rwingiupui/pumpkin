class FileSetPresenter < CurationConcerns::FileSetPresenter
  include CurationConcerns::Serializers
  delegate :viewing_hint, :title, :file_label, :width, :height, :full_text, to: :solr_document

  def thumbnail_id
    id
  end
end
