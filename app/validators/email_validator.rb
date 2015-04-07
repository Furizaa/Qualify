class EmailValidator < ActiveModel::EachValidator

  def self.email_regex
    /^[a-zA-Z0-9!#\$%&'*+\/=?\^_`{|}~\-]+(?:\.[a-zA-Z0-9!#\$%&'\*+\/=?\^_`{|}~\-]+)*@(?:[a-zA-Z0-9](?:[a-zA-Z0-9\-]*[a-zA-Z0-9])?\.)+[a-zA-Z0-9](?:[a-zA-Z0-9\-]*[a-zA-Z0-9])?$/
  end

  def validate_each(record, attribute, value)
    if !value.present? || !(EmailValidator.email_regex =~ value)
      record.errors[attribute] << I18n.t(:'email.invalid', email: value)
    end
  end

end