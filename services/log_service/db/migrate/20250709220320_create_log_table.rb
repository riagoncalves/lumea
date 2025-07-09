class CreateLogTable < ActiveRecord::Migration[8.0]
  def change
    create_table :audit_logs do |t|
      t.bigint  :user_id,     null: true  
      t.string  :action,      null: false
      t.string  :entity_type, null: false
      t.bigint  :entity_id,   null: false
      t.jsonb   :old_values,  null: true, default: {}
      t.jsonb   :new_values,  null: true, default: {}
      t.timestamps
    end
  end
end
