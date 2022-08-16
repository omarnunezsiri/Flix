class RemoveSlugFromUsers < ActiveRecord::Migration[6.1]
  def change
    remove_column :users, :slug, :string
  end
end
