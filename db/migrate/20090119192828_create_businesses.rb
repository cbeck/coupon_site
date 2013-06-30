class CreateBusinesses < ActiveRecord::Migration
  def self.up
    create_table :locations, :force => true,
      :options => 'ENGINE=InnoDB DEFAULT CHARSET=utf8' do |t|
      t.column :addressable_id,   :integer
      t.column :addressable_type, :string
      t.column :address_line1,    :string
      t.column :address_line2,    :string
      t.column :city,             :string
      t.column :state,            :string, :limit => 2
      t.column :postal_code,      :string
      t.column :country,          :string
      t.column :directions,       :string
      t.column :longitude,        :float
      t.column :latitude,         :float
      t.datetime :verified_at
      t.timestamps      
    end
    add_index :locations, [:addressable_id, :addressable_type]
    
    create_table :phones, :force => true,
      :options => 'ENGINE=InnoDB DEFAULT CHARSET=utf8' do |t|
      t.column :callable_id,    :integer
      t.column :callable_type,  :string
      t.column :number,         :string
      t.column :extension,      :string
      t.column :description,    :string
      t.column :phone_type,     :string
      t.column :main,           :boolean
      t.column :verified_at,    :datetime
      t.timestamps
    end
    add_index :phones, [:callable_id, :callable_type]
    
    create_table :people, :force => true,
      :options => 'ENGINE=InnoDB DEFAULT CHARSET=utf8' do |t|
      t.column :personable_id,    :integer
      t.column :personable_type,  :string
      t.column :first_name,       :string
      t.column :last_name,        :string
      # t.column :email,            :string
      # t.column :user_id,          :integer
      t.timestamps
    end
    add_index :people, [:personable_id, :personable_type]
    
    create_table :websites, :force => true,
      :options => 'ENGINE=InnoDB DEFAULT CHARSET=utf8' do |t|
      t.column :netable_id,   :integer
      t.column :netable_type, :string
      t.column :url,          :string
      t.timestamps
    end
    add_index :websites, [:netable_id, :netable_type]
    
    create_table :email_addresses do |t|
      t.integer :emailable_id
      t.string :emailable_type
      t.string :address
      t.string :label
      t.datetime :verified_at
      t.timestamps
    end
    add_index :email_addresses, [:emailable_id, :emailable_type]
    
    create_table :businesses, :force => true,
      :options => 'ENGINE=InnoDB DEFAULT CHARSET=utf8' do |t|
      t.column :name,         :string
      t.column :description,  :text
      t.column :schedule,     :string
      t.column :user_id,      :integer
      t.timestamps
    end    
    add_index :businesses, :user_id
        
  end

  def self.down
    drop_table :locations
    drop_table :phones
    drop_table :people
    drop_table :websites
    drop_table :email_addresses
    drop_table :businesses
  end
end
