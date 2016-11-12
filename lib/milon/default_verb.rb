require_relative "./prefixes_suffixes"
module DefaultVerb
  def self.generate_exception_regexes
    {
      
      /^(..)ו(.)$/ => {part: :adjective}
    }
  end

  def self.generate_shem_hapoel_regexes
    regexes = {
      /^ל(..)ו(.)$/ => {binyan: :paal},
      /^להי(...)$/ => {binyan: :nifal},
      /^ל(...)$/ => {binyan: :piel},
      /^להת(...)$/ => {binyan: :hitpael},
      /^לה(...)$/ => {binyan: :hifil}
    }
    return PrefixesSuffixes.generate_shem_hapoel_regexes regexes
  end

  def self.generate_future_regexes
    binyanim = {
      paal: '(.)ו(..)',
      nifal: 'נ(.)ו(..)',
      piel: '(...)',
    }
    return PrefixesSuffixes.generate_future_regexes binyanim
  end

  def self.generate_past_regexes
    binyanim = {
      paal: /(...)/,
      nifal: /נ(...)/,
      piel: /(.)י(..)/,
      paul: /(..)ו(.)/,
      hifil: /ה(..)י(.)/,
      hufal: /הו(...)/,
      hitpael: /הת(...)/
    }
    regexes = PrefixesSuffixes.generate_past_regexes binyanim
    return regexes
  end


  def self.generate_present_regexes
    regexes = {}
    PrefixesSuffixes.present_endings.each do |suffix|
      ending, form = suffix.keys[0], suffix.values[0]
      regexes.merge!({/^מ(...)#{ending}$/ => form.merge({binyan: :piel})})
      regexes.merge!({/^(.)ו(..)#{ending}$/ => form.merge({binyan: :paal})})
    end
    return regexes
  end

  def self.regex_dictionary
    regexes = {}
    regexes.merge! generate_shem_hapoel_regexes
    regexes.merge! generate_past_regexes
    regexes.merge! generate_present_regexes
    regexes.merge! generate_future_regexes
    regexes.merge! generate_exception_regexes
    return regexes
  end
end
