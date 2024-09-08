RSpec::Matchers.define :have_flash_notice do |flash_message|
  match do |page|
    page.has_css?('.alert-notice.alert--flash', text: flash_message, visible: :all)
  end

  failure_message do
    "expected that page would have flash notice of #{flash_message} but was not found"
  end

  match_when_negated do |page|
    page.has_no_css?('.alert-notice.alert--flash', text: flash_message, visible: :all)
  end

  failure_message_when_negated do
    "expected that page would not have flash notice of #{flash_message} but was found"
  end
end

RSpec::Matchers.define :have_flash_alert do |flash_message|
  match do |page|
    page.has_css?('.alert-alert.alert--flash', text: flash_message, visible: :all) ||
      page.has_css?('.alert-danger.alert--flash', text: flash_message, visible: :all)
  end

  failure_message do
    "expected that page would have flash alert of #{flash_message} but was not found"
  end

  match_when_negated do |page|
    page.has_no_css?('.alert-alert.alert--flash', text: flash_message, visible: :all) &&
      page.has_no_css?('.alert-danger.alert--flash', text: flash_message, visible: :all)
  end

  failure_message_when_negated do
    "expected that page would not have flash alert of #{flash_message} but was found"
  end
end

RSpec::Matchers.define :have_flash_warning do |flash_message|
  match do |page|
    page.has_css?('.alert-warning.alert--flash', text: flash_message, visible: :all)
  end

  failure_message do
    "expected that page would have flash warning of #{flash_message} but was not found"
  end

  match_when_negated do |page|
    page.has_no_css?('.alert-warning.alert--flash', text: flash_message, visible: :all)
  end

  failure_message_when_negated do
    "expected that page would not have flash warning of #{flash_message} but was found"
  end
end
