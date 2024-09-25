class ApplicationPresenter
  include Rails.application.routes.url_helpers

  attr_reader :presented

  def initialize(presented)
    @presented = presented
  end

  def self.presenter_for(subject)
    presenter_lookup = PresenterFinder.new(subject).find

    "#{presenter_lookup.klass}Presenter".constantize.new(presenter_lookup.object)
  end
end
