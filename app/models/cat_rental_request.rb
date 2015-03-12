class CatRentalRequest < ActiveRecord::Base

  belongs_to(
    :cat,
    class_name: :Cat,
    foreign_key: :cat_id,
    primary_key: :id
  )

  belongs_to(
    :requester,
    class_name: :User,
    foreign_key: :user_id,
    primary_key: :id
  )

  STATUSES = %w(PENDING APPROVED DENIED)
  validates :cat_id, :status, :start_date, :end_date, :user_id, presence: true
  validates :status, inclusion: STATUSES
  validate :overlapping_approved_requests

  def overlapping_requests(second_cat)
    return false if second_cat.cat_id != self.cat_id
    return false if second_cat.id == self.id

    [second_cat.start_date, second_cat.end_date].each do |date|
      return true if date.between?(self.start_date, self.end_date)
    end

    [self.start_date, self.end_date].each do |date|
      return true if date.between?(second_cat.start_date, second_cat.end_date)
    end

    false
  end

  def approve!
    CatRentalRequest.transaction do
      self.status = 'APPROVED'
      self.save
      overlapping_pending_requests.map { |request| request.deny! }
    end
  end

  def deny!
    CatRentalRequest.transaction do
      self.status = 'DENIED'
      self.save
    end
  end

  def pending?
    self.status == 'PENDING'
  end

  def overlapping_pending_requests
    pending = CatRentalRequest.where(status: 'PENDING')
    pending.select { |request| overlapping_requests(request) }
  end

  def overlapping_approved_requests
    approved = CatRentalRequest.where(status: 'APPROVED')
    approved.each do |request|
      if overlapping_requests(request)
        self.approve!
        errors[:overlapping] << "That cat is already rented!"
      end
    end
  end

end
