class TimeSlot < ActiveRecord::Base
  time_of_day_attr :in, :out, callback: ->(attr, value) { attr.eql?(:out) && value.zero? ? 24*3600 : value }
  time_of_day_attr :from, :to, callback: :process_values

  def process_values(attr, value)
    attr.eql?(:to) && value == 0 ? 24*3600 : value
  end
end
