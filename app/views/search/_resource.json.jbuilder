json.set! "@id", annotation_url(doc[:id], doc[:time])
json.set! '@type', 'oa:Annotation'
json.motivation 'sc:painting'

json.resource do
  json.set! '@type',  "cnt:ContentAsText"
  json.chars doc[:word]
end

page_word_list = @pages_json[doc[:id]]
real_key = page_word_list.keys.find { |k| doc[:word].downcase == k.downcase }
xywh = if !@pages_json[doc[:id]] || page_word_list[real_key].nil?
  "0,0,0,0"
else
  word_bounds = page_word_list[real_key].shift
  # FIXME: This is the wrong place to set all of these to integers
  if word_bounds
    x = word_bounds["x0"].to_i
    y = word_bounds["y0"].to_i
    w = word_bounds["x1"].to_i - word_bounds["x0"].to_i
    h = word_bounds["y1"].to_i - word_bounds["y0"].to_i
    "#{x},#{y},#{w},#{h}"
  else
    "0,0,0,0"
  end
end

json.on manifest_canvas_on_xywh(@parent_path, doc[:id], xywh)
