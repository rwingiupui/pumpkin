module CurationConcernsHelper
  include ::BlacklightHelper
  include CurationConcerns::MainAppHelpers

  def default_icon_fallback
    safe_join ["this.src='", image_path('default.png'), "'"]
  end
end
