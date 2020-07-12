# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    if user.roles.include? "admin"
      can :manage, :all
    end

    if user.roles.include? "redactor"
      can :read, ActiveAdmin::Page, name: "Dashboard"
      can :manage, [Region, School, District, City]
    end

    if user.roles.include? "user"
      can :read, ActiveAdmin::Page, name: "Dashboard"
      can :read, [Region, School, District, City]
    end
  end
end
