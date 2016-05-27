
module Amaze::Module::AutoRegisterSubclass
  def inherited child_class
    name = child_class.to_s.
      split('::').last.
      split(/(?=[[:upper:]])/).
      map(&:downcase).
      join

    (@registred ||= {})[name.to_sym] = child_class
  end
  
  def registred
    @registred
  end
  
  def all
    registred.keys
  end
  
  def create name, *args
    registred[name.to_sym].new(*args)
  end
end