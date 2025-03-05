class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      # :usersのテーブルを作成
      t.string :name
      t.string :email

      t.timestamps
      # :マジックカラムを作成
    end
  end
end
