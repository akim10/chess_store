class User < ActiveRecord::Base
  # get modules to help with some functionality
  include ChessStoreHelpers::Validations

  # use has_secure_password
  has_secure_password

  # Relationships
  has_many :orders

  # Scopes
  scope :alphabetical,  -> { order(:last_name).order(:first_name) }
  scope :active,        -> { where(active: true) }
  scope :inactive,      -> { where(active: false) }
  scope :employees,     -> { where.not(role: 'customer') }
  scope :customers,     -> { where(role: 'customer') }

  # Validations
  validates :username, presence: true, uniqueness: { case_sensitive: false}
  validates :email, presence: true, uniqueness: { case_sensitive: false}, format: { with: /\A[\w]([^@\s,;]+)@(([\w-]+\.)+(com|edu|org|net|gov|mil|biz|info))\z/i, message: "is not a valid format" }
  validates :phone, format: { with: /\A\(?\d{3}\)?[-. ]?\d{3}[-.]?\d{4}\z/, message: "should be 10 digits (area code needed) and delimited with dashes only", allow_blank: true }
  validates :role, inclusion: { in: %w[admin manager shipper customer], message: "is not a recognized role in system" }
  validates_presence_of :password, on: :create 
  validates_presence_of :password_confirmation, on: :create 
  validates_confirmation_of :password, on: :create, message: "does not match"
  validates_length_of :password, minimum: 4, message: "must be at least 4 characters long", allow_blank: true

  # For use in authorizing with CanCan
  ROLES = [['Administrator', :admin],['Manager', :manager],['Shipper', :shipper],['Customer',:customer]]

  def self.best_customers
    limit = 5
    customers_by_num_orders = User.all.sort_by{|user| user.orders.length}
    best_five_customers = customers_by_num_orders.last(limit)
    best_customers = []
    best_customers[0] = [best_five_customers.map{|u| u.proper_name}[0], best_five_customers.map{|user| user.orders.length}[0]]
    best_customers[1] = [best_five_customers.map{|u| u.proper_name}[1], best_five_customers.map{|user| user.orders.length}[1]]
    best_customers[2] = [best_five_customers.map{|u| u.proper_name}[2], best_five_customers.map{|user| user.orders.length}[2]]
    best_customers[3] = [best_five_customers.map{|u| u.proper_name}[3], best_five_customers.map{|user| user.orders.length}[3]]
    best_customers[4] = [best_five_customers.map{|u| u.proper_name}[4], best_five_customers.map{|user| user.orders.length}[4]]
    best_customers
  end

  def role?(authorized_role)
    return false if role.nil?
    role.downcase.to_sym == authorized_role
  end

  # Other methods
  def name
    "#{last_name}, #{first_name}"
  end

  def proper_name
    "#{first_name} #{last_name}"
  end

  # Callbacks
  before_destroy :is_never_destroyable
  before_save :reformat_phone
  
  private
  def reformat_phone
    phone = self.phone.to_s  # change to string in case input as all numbers 
    phone.gsub!(/[^0-9]/,"") # strip all non-digits
    self.phone = phone       # reset self.phone to new string
  end

  def self.authenticate(email,password)
    find_by_email(email).try(:authenticate, password)
  end

end
