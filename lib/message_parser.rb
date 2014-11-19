module MessageParser
  def self.extract_number(input_string, key)
    index_of_key = input_string.index(key)
    return nil unless index_of_key
    start_of_number = input_string.index(':', index_of_key) + 1
    end_of_number = input_string.index("<br", index_of_key)
    end_of_number ||= input_string.length
    error_number = input_string[start_of_number..(end_of_number-1)].to_i
  end
end
