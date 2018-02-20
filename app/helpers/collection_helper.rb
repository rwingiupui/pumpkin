module CollectionHelper
  def find_or_create_collections(slugs)
    slugs.map { |slug| find_or_create_collection(slug) }
  end

  def find_or_create_collection(slug)
    existing = Collection.where exhibit_id_ssim: slug
    return existing.first if existing.first
    col = Collection.new metadata_for_collection(slug)
    col.apply_depositor_metadata @user
    col.save!
    col
  end

  def metadata_for_collection(slug)
    collection_metadata.each do |c|
      if c['slug'] == slug
        return { exhibit_id: slug,
                 title: [c['title']],
                 description: [c['blurb']] }
      end
    end
  end

  def collection_metadata
    @collection_metadata ||=
      JSON.parse(File.read(Rails.root.join('config',
                                           'pudl_collections.json')))
  end
end
