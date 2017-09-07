class Ability
  include CanCan::Ability

  def initialize(user)
    # Define abilities for the passed in user here. For example:
    user ||= User.new # guest user (not logged in)

    if user.role? :admin
      can :manage, :all
      can :read, :all

    elsif user.role? :manager

      can :read, :all
      can :manage, Purchase
      can :manage, ItemPrice
      can :manage, Item

    elsif user.role? :shipper

      can :read, User do |u|
        u.id == user.id
      end

      can :update, User do |u|
        u.id == user.id
      end

      can :index, Item

      can :show, Item

    elsif user.role? :customer
      can :read, Order do |this_order|  
        my_orders = user.customer.orders.map(&:id)
        my_orders.include? this_orders.id 
      end
      can :read, :all
      can :add_to_cart, Item
      can :remove_from_cart, Item
      can :cart, Order
      can :empty_cart, Order
      can :checkout, Order
      can :new, Order
      can :create, Order
      can :checkout, Order

      can :show, User do |u|
        u.id == user.id
      end
      can :update, User do |u|  
        c.id == user.id
      end
    else
      can :create, User
      can :create, School
      can :read, School
      can :read, Item
      can :read, User
    end

    # The first argument to `can` is the action you are giving the user
    # permission to do.
    # If you pass :manage it will apply to every action. Other common actions
    # here are :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on.
    # If you pass :all it will apply to every resource. Otherwise pass a Ruby
    # class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the
    # objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details:
    # https://github.com/CanCanCommunity/cancancan/wiki/Defining-Abilities
  end
end
