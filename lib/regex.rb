require './default_verb'
module Regex
  def self.regex_dictionary
    regexes = {}
    
    regexes.merge!(DefaultVerb.regex_dictionary)
    return regexes
  end
end
