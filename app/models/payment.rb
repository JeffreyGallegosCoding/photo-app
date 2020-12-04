class Payment < ApplicationRecord
  # needed fields for card payments
  attr_accessor :card_number, :card_cvc, :card_expires_month, :card_expires_year
  belongs_to :user

  # displays for month and year options

  # when a user selects the month option for cc info - display purposes
  def self.month_options
    Date::MONTHNAMES.compact.each_with_index.map { |name, i| ["#{i+1} - #{name}", i+1]  }
  end

  def self.year_options
    # date range for year - Today's year, .. is range, to how many years in the future to display
    # and convert it into an array
    (Date.today.year..(Date.today.year + 10)).to_a
  end

  # method used to process the payment during registration
  def process_payment
    # create a stripe customer variable to assign a stripe charge to
    customer = Stripe::Customer.create email: email, card: token

    # creates a stripe charge assigned to the customer variable by id with the payment attributes
    # amount 1000 is cents, description of charge, and the type of currency used for charge
    Stripe::Charge.create customer: customer.id,
                          amount: 1000,
                          description: 'Premium',
                          currency: 'usd'
  end

end
