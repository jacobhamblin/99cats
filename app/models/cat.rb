class Cat < ActiveRecord::Base
  has_many(
    :rental_requests,
    class_name: :CatRentalRequest,
    foreign_key: :cat_id,
    primary_key: :id,
    dependent: :destroy
  )

  COAT_COLORS = %w(black calico tabby)
  validates :birth_date, :color, :name, :sex, :description, presence: true
  validates :color, inclusion: COAT_COLORS

  def age
    now = Date.current
    age = now.year - birth_date.year
    age -= 1 if now.month <= birth_date.month && now.day < birth_date.day
    age
  end
end
