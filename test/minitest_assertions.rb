##
# Add custom assertion to minitest
module Minitest::Assertions

  ##
  # Asserts that +model+ is invalid, and that +error_message+
  # is present on the +attribute+ attribute.
  def assert_invalid model, attribute, error_message=nil, msg=nil
    refute model.valid?,
        msg || "Expected #{model.class} to be invalid but it was valid"

    errors = model.errors[attribute]
    assert errors.any?,
        msg || "#{model.class} was invalid, but there were no errors on #{attribute} #{model.errors.keys}"

    if error_message
      assert errors.include?(error_message),
          msg || ["Expected #{model.class}##{attribute} error messages to to include this error message",
           "  Expected: \"#{error_message}\"",
           "    Actual: #{errors}"].join("\n")
    end
  end

  ##
  # Asserts that the model is valid, if it's not it prints each error
  def assert_valid model, msg=nil
    valid = model.valid?
    msg = ["Expected #{model.class} to be valid but it had these errors:",
      *model.errors.full_messages.map { |message| " - #{message}" }].join("\n")
    assert valid, msg
  end

  ##
  # Asserts that Klass#all is equal to Klass.all.order(order)
  def assert_order klass, *order
    assert klass.all == klass.all.order(order),
      "Expected #{klass} to be ordered by #{order}"
  end

  ##
  # Asserts that +model+ is invalid when +attribute+ is blank.
  def assert_cannot_be_blank model, attribute, msg=nil
    msg ||= "Expected #{model.class} to be invalid when #{attribute} is blank"
    blanky_values = [nil, '']
    blanky_values.each do |blank_value|
      model[attribute] = blank_value
      assert_invalid model, attribute, "can't be blank", msg
    end
  end

  ##
  # Asserts that the expressions in +expression+ have changed by +difference+
  # after yielding +block+
  def assert_difference(expression, difference = 1, message = nil, &block)
    expressions = Array(expression)

    exps = expressions.map { |e|
      e.respond_to?(:call) ? e : lambda { eval(e, block.binding) }
    }
    before = exps.map { |e| e.call }

    yield

    expressions.zip(exps).each_with_index do |(code, e), i|
      if message
        error  = message
      else
        error  = "#{code.inspect} didn't change by #{difference}"
      end
      assert_equal(before[i] + difference, e.call, error)
    end
  end

  ##
  # Asserts that the expressions in +expression+ have not changed after
  # yielding to +block+
  def assert_no_difference(expressions, message = nil, &block)
    message ||= "Expected #{expressions} not to change but it did"
    assert_difference(expressions, 0, message, &block)
  end

  ##
  # Asserts that the passed model was destroyed
  def assert_destroyed *models
    models.each do |model|
      assert model.destroyed?, "#{model.class} should have been destroyed but was not"
    end
  end
end

