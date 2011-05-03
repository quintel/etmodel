##
# Class documentation. Write one line why this class exists.
# (one blank line for better readibility)
class Foo < ActiveRecord::Base
  # include and exclude statements immediately on the next line
  include Module
  extend OtherModule

  ##
  # Database and plugin related configurations
  ##
  set_table_name 'legacy_foo'
  has_paper_trail

  ##
  # Assocations and "foreign_key constraints"
  ##
  has_one :foo

  ##
  # Validations
  ##
  validates_presence_of :attribute, :on => :create, :message => "can't be blank"
  validate :custom_validation

  # put method after the last validation
  # Except if it is used somewhere else as well
  # (then probably something is wrong) put in the method body
  def custom_validation
  end

  ##
  # Named Scopes
  ##
  named_scope :foo

  ##
  # Hooks (comes at the end, as it is a mix of programming and db)
  ##
  before_save :check_this

  # put method after the last hook (before_save, after_save, ...)
  # Except if it is used somewhere else, put in the method body
  def check_this
    puts 'help'
  end

  ##
  # Instance Methods
  ##

  ##
  # Method description
  #
  # @param val <String> Description what is expected
  # @return <Boolean> What is returned
  # (one blank line for better readibility)
  def method_a(val)
    true
  end

protected
  # All protected instance methods

private
  # All private instance methods

public
  ##
  # Class Methods
  ##

  def self.foo
  end

end
