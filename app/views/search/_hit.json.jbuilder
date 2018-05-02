json.set! '@type', 'search:Hit'
json.annotations do
  # This is the way we trick UV to show the number of hits
  urls = []
  time = 0
  doc[:hit_number].each do |hits|
    hits.times do |t|
      urls << annotation_url(doc['id'], time)
      time += 1
    end
  end
  json.array! urls
end
