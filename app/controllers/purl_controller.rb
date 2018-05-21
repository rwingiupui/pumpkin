class PurlController < ApplicationController
  def default # rubocop:disable Metrics/AbcSize
    begin
      set_object
      realid = @solr_hit.id
      url = "#{request.protocol}#{request.host_with_port}" \
        "#{config.relative_url_root}/concern/#{@subfolder}/#{realid}"
      url += "#?m=#{@volume}&cv=#{@page}" if @volume.positive? || @page.positive?
    rescue StandardError
      url = Plum.config['purl_redirect_url'] % params[:id]
    end
    respond_to do |f|
      f.html { redirect_to url }
      f.json { render json: { url: url }.to_json }
    end
  end

  private

    OBJECT_LOOKUPS = {
      MultiVolumeWork => /^\w{3}\d{4}$/,
      ScannedResource => /^\w{3}\d{4}$/
    }.freeze

    def set_object
      @id, @volume, @page = params[:id].split('-')
      @volume = normalize_number(@volume)
      @page = normalize_number(@page)
      OBJECT_LOOKUPS.each do |klass, match_pattern|
        if @id.match match_pattern
          @solr_hit = klass.search_with_conditions(
            { source_metadata_identifier_tesim: @id }, rows: 1
          ).first
          @subfolder = klass.to_s.pluralize.underscore
        end
        break if @solr_hit
      end
    end

    def normalize_number(n)
      n.to_i.positive? ? (n.to_i - 1) : 0
    end
end
