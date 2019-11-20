require 'parametric'

# Hash validator
class HashPolicy
  # Validation error message, if invalid
  def message
    'is invalid'
  end

  # Whether or not to validate and coerce this value
  # if false, no other policies will be run on the field
  def eligible?(value, _key, _payload)
    value ? true : false
  end

  # Transform the value
  def coerce(value, _key, _context)
    value
  end

  # Is the value valid?
  def valid?(value, _key, _payload)
    value.is_a?(Hash)
  end

  # merge this object into the field's meta data
  def meta_data
    { type: :hash }
  end
end

Parametric.policy :hash, HashPolicy
