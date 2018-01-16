require 'rdf'
# rubocop:disable Style/CommentedKeyword
class F3Access < RDF::StrictVocabulary('http://fedora.info/definitions/1/0/access/ObjState#')
  # rubocop:enable Style/CommentedKeyword
  term :objState, label: 'Object State'.freeze, type: 'rdf:Property'.freeze
end
