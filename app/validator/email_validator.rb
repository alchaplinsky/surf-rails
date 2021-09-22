# encoding: UTF-8
# Regular expression based on: https://www.w3.org/TR/html5/forms.html#valid-e-mail-address
# with the custom modification that the domain part (after the '@') must contain a "." (aka dot, period, or full stop)

class EmailValidator < ActiveModel::EachValidator
  def self.regexp
    %r{^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)+$}
  end

  def self.valid?(value)
    !!(value =~ regexp)
  end

  def validate_each(record, attribute, value)
    unless self.class.valid?(value)
      record.errors.add(attribute, options[:message] || :invalid)
    end
  end
end
