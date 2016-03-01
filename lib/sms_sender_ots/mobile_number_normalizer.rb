module SmsSenderOts
  module MobileNumberNormalizer
    def self.normalize_number(n)
      while n.starts_with?('+') || n.starts_with?('0')
        n.slice!(0)
      end
      return n
    end

    def self.normalize_message(message)
      message.encode(Encoding::UTF_8)
    end
  end
end
