#!/usr/bin/ruby

require './lib/regex'
module Parser


  def self.binyan_definitions
    {
      paal: "Paal is a simple action.  Subject does verb to object.",
      nifal: "Nifal is the passive form of paal.  Subject has verb done to it. 'Was written' for example.",
      piel: "Piel is an intensive action.  Subject does verb to object, but more intensely than in paal.  For example, broke vs. shattered.  Not all verbs have both a piel and a paal form, in which case piel is a simple action.",
      pual: "Pual is the passive form of piel.  Subject has verb done to it.",
      paul: "Use of paul indicates a passive, permanent state.  'Open' for example, in the sentence 'The door is open.'",
      hifil: "Hifil is the causative case.  It means the subject caused the verb to happen, but through someone else's action.  For example, 'dictated' is the causative form of 'wrote'.  It can also mean 'to become' the noun form of the verb.",
      hufal: "Hufal is the passive form of hifil.  It means the subject was caused to happen by the object, but not directly done by the object.",
      hitpael: "hitpael is the reflexive form of the word."
      
    }
  end

  def self.build_definition form, root
    
    case form[:part]
    when :verb
      return "The shoresh is #{root}.  This word is in #{form[:tense]} tense.  It is in #{form[:person]} person, and #{form[:number]}.  The subject is #{form[:gender]}.  It is in #{form[:binyan]} form, which means: #{binyan_definitions[form[:binyan]]}"
    when :adjective
      return "This is an adjective."
    end
  end

  #$~ is the matchdata of the last regex match.
  #match[0] is the full match, match[1] is the first group matched.
  #In this case, that's the shoresh.
  def self.translate word
    regex_dictionary = Regex.regex_dictionary
    results = []
    
    regex_dictionary.each do |regex, form|
      if regex.match word
        root = $~[1..-1].join
        root = fix_endings(root)
        results << (build_definition form, root)
      end
    end
    output = results.join("\nAlternatively, it can be interpreted as:\n")

    
    return output
  end

  def self.fix_endings root
    sofim_dict = {
      'פ' => 'ף',
      'כ' => 'ך',
      'מ' => 'ם',
      'נ' => 'ן',
      'צ' => 'ץ'
    }

    sofim_dict.each do |key, value|
      if root[-1] == key
        root[-1] = value
      end
    end
    return root
  end
end
