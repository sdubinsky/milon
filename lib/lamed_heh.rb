require './lib/prefixes_suffixes'
module LamedHeh
  def self.generate_exception_regexes
    
  end

  def self.generate_shem_hapoel_regexes
    
  end
  
  def self.generate_past_regexes
    binyanim = {
      paal: /(..)ה/,
      nifal: /נ(..)ה/,
      piel: /(.)י(.)ה/,
      pual: /(.)ו(.)ה/,
      hitpael: /הת(..)ה/,
      hifil: /ה(..)ה/,
      hufal: /הו(..)ה/
    }
    retval = []
    regexes = PrefixesSuffixes.generate_past_regexes binyanim
    regexes.each_pair do |regex, form|
      if regex[-2..-3] == 'הה'
        regex[-2..-3] = 'תה'
      end
      if regex[-4] == 'ה'
        regex[-4] = 'י'
      end

      retval[regex] = form
    end
    return retval
  end

  def self.generate_present_regexes
    regexes = {}
    endings = PrefixesSuffixes.present_endings
    endings[0] = {'ה' => endings[0]['']}
    endings[1] = {'ה' => endings[1]['ת']}
    endings.each do |suffix|
      ending, form = suffix.keys[0], suffix.values[0]
      regexes.merge!({ /^(.)ו(.)#{ending}$/ => form.merge({binyan: :paal})})
      regexes.merge!({ /^מ(..)#{ending}$/ => form.merge({binyan: :piel})})
      regexes.merge!({ /^מ(.)ו(.)#{ending}$/ => form.merge({binyan: :pual})})
      regexes.merge!({ /^מת(..)#{ending}$/ => form.merge({binyan: :hitpael})})
      regexes.merge!({ /^מ(..)#{ending}$/ => form.merge({binyan: :hifil})})
      regexes.merge!({ /^מו(..)#{ending}$/ => form.merge({binyan: :hufal})})
      nifal_dict = { /^נ(..)#{ending}$/ => form.merge({binyan: :nifal})}
      nifal_dict = { /^נ(..)ית$/ => form} if ending == 'ה' and form[:gender] == :female
      regexes.merge!(nifal_dict)
    end
  end

  def self.generate_future_regexes
    binyanim = {
      paal: /(..)ה/,
      nifal: /י(..)ה/,
      piel: /(..)ה/,
      pual: /(.)ו(.)ה/,
      hitpael: /ת(..)ה/,
      hifil: /(..)ה/,
      hufal: /ו(..)ה/,
    }

    retval = {}
    regexes = PrefixesSuffixes.generate_future_regexes binyanim
    regexes.each_pair do |regex, form|
      if regex[-2] == 'י'
        regex.slice!(-3)
      end
      retval[regex] = form
    end

    return retval
  end

  def self.regex_dictionary
    regexes = {}
    regexes.merge! generate_past_regexes
  end
end
