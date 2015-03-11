class AddDefaultStatus < ActiveRecord::Migration
  def change
    remove_column(:cat_rental_requests, :status)
    add_column(:cat_rental_requests, :status, :string, null:false, default: "PENDING")
  end
end
