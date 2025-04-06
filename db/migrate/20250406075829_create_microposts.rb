class CreateMicroposts < ActiveRecord::Migration[7.0]
  def change
    create_table :microposts do |t|
      t.text :content
      # マイクロポストの中身
      t.references :user, null: false, foreign_key: true

      t.timestamps
      # created_atとupdated_atのカラムを自動的に追加する。
    end
    add_index :microposts, %i[user_id created_at]
    # [:user_id, :created_at]の組み合わせでインデックスを作成する。
  end
end
