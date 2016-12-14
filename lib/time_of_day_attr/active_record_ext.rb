module TimeOfDayAttr
  module ActiveRecordExt
    extend ActiveSupport::Concern

    module ClassMethods

      def time_of_day_attr(*attrs, &block)
        options = attrs.extract_options!
        options[:formats] ||= [:default, :hour]
        callback = block_given? ? block : options[:callback]
        attrs.each do |attr|
          define_method("#{attr}=") do |value|
            if value.is_a?(String)
              delocalized_values = options[:formats].map do |format|
                begin
                  TimeOfDayAttr.delocalize(value, format: format)
                rescue ArgumentError => e
                  if 'argument out of range' == e.message
                    super(nil)
                    return
                  end
                  nil
                end
              end
              delocalized_value = delocalized_values.compact.first
              if callback.present?
                delocalized_value = callback.is_a?(Proc) ? callback.call(attr, delocalized_value) : send(callback, attr, delocalized_value)
              end
              super(delocalized_value)
            else
              super(value)
            end
          end
        end
      end
    
    end
  end
end
ActiveSupport.on_load(:active_record) do
  include TimeOfDayAttr::ActiveRecordExt
end
