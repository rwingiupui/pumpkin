json.set! '@context', 'http://iiif.io/api/search/0/context.json'
json.set! '@id', request.original_url
json.set! '@type', 'sc:AnnotationList'
json.startIndex 0

json.within do
  json.ignored []
  json.total 1 # FIXME
  json.set! '@type', 'sc:Layer'
end

json.hits @docs, partial: 'search/hit', as: :doc

# We rework this into individual resource_docs/annotations so that
# we trick UV into showing the number of hits for each page.
resource_docs = []

@docs.each do |doc|
  word_count = 0
  time_count = 0
  doc[:hit_number].each do |t|
    t.times do
      word = doc[:word][word_count]
      new_doc = {id: doc['id'], resource: doc['resource'], time: time_count, word: word}
      time_count += 1
      resource_docs << new_doc
    end
    word_count += 1
  end
end

json.resources resource_docs, partial: 'search/resource', as: :doc
