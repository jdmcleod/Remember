class PresenterFinder

  attr_reader :presentable, :object, :klass

  def initialize(presentable)
    @presentable = presentable
  end

  def find
    modules = Array(presentable).dup
    last = modules.pop
    context = modules.map { |x| find_class_name(x) }.join("::")
    @klass = [context, find_class_name(last)].join("::")
    @object = last
    self
  end

  def find_class_name(subject)
    if subject.respond_to?(:model_name)
      subject.model_name
    elsif subject.class.respond_to?(:model_name)
      subject.class.model_name
    elsif subject.is_a?(Class)
      subject
    elsif subject.is_a?(Symbol)
      subject.to_s.camelize
    else
      subject.class
    end
  end
end
