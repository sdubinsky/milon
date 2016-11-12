module PrefixesSuffixes
  def self.past_endings
    [
      {'תי' =>{tense: :past, person: :first, number: :singular, gender: :neuter, part: :verb}},
      {'ת' => {tense: :past, person: :second, number: :singular, gender: :neuter, part: :verb}},
      {'' => {tense: :past, person: :third, number: :singular, gender: :male, part: :verb}},
      {'ה' => {tense: :past, person: :third, number: :singular, gender: :female, part: :verb}},
      {'תם' => {tense: :past, person: :second, number: :plural, gender: :male, part: :verb}},
      {'תן' => {tense: :past, person: :second, number: :plural, gender: :female, part: :verb}},
      {'נו' => {tense: :past, person: :first, number: :plural, gender: :neuter, part: :verb}},
      {'ו' => {tense: :past, person: :third, number: :plural, gender: :neuter, part: :verb}},
    ]
  end

  def self.present_endings
    [
      {'' => {tense: :present, person: :unknown, number: :singular, gender: :male, part: :verb}},
      {'ת' => {tense: :present, person: :unknown, number: :singular, gender: :female, part: :verb}},
      {'ים' => {tense: :present, person: :unknown, number: :plural, gender: :male, part: :verb}},
      {'ות' => {tense: :present, person: :unknown, number: :plural, gender: :female, part: :verb}}
    ]
  end

  #Binyan here is a string or regex representing the form of the binyan
  def self.future_regexes binyan, name 
    {
      /^א#{binyan}$/ => {tense: :future, person: :first, number: :singular, binyan: name, gender: :neuter, part: :verb},
      /^ת#{binyan}$/ => {tense: :future, person: [:second, :third], number: :singular, binyan: name, gender: [:male, :female], part: :verb},
      /^ת#{binyan.sub('ו', '')}י$/ => {tense: :future, person: :second, number: :singular, binyan: name, gender: :female, part: :verb},
      /^י#{binyan}$/ => {tense: :future, person: :third, number: :singular, binyan: name, gender: :neuter, part: :verb},
      /^נ#{binyan}$/ => {tense: :future, person: :first, number: :singular, binyan: name, gender: :neuter, part: :verb},
      /^ת#{binyan.sub('ו', '')}ו$/ => {tense: :future, person: :first, number: :singular, binyan: name, gender: :neuter, part: :verb},
      /^י#{binyan.sub('ו', '')}ו$/ => {tense: :future, person: :third, number: :singular, binyan: name, gender: :neuter, part: :verb}
    }
  end

  def self.generate_future_regexes binyanim
    regexes = {}
    binyanim.each_pair do |name, binyan|
      regexes.merge!(future_regexes(binyan, name))
    end
    return regexes
  end

  def self.generate_past_regexes binyanim
    regexes = {}
    past_endings.each do |suffix|
      ending, form = suffix.keys[0], suffix.values[0]
      binyanim.each_pair do |name, regex|
        regexes.merge!({/^#{regex}#{ending}$/ => form.merge({binyan: name})})
      end
    end
    return regexes
  end

  def self.generate_shem_hapoel_regexes binyanim
    form = {tense: :infinitive, person: :nonspecific, number: "both singular and plural", gender: :neuter, part: :verb}

    regexes = {}
    binyanim.each_pair do |regex, binyan|
      regexes.merge!({regex => binyan.merge(form)})
    end
    return regexes
  end
end
