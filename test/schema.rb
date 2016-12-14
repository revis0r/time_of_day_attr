ActiveRecord::Migration.verbose = false

ActiveRecord::Schema.define do
  
  create_table :business_hours, :force => true do |t|
    t.integer :opening
    t.integer :closing
  end

  create_table :time_slots, :force => true do |t|
    t.integer :in
    t.integer :out

    t.integer :from
    t.integer :to
  end
end
