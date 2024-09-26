# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Trips', type: :system, js: true do
  let(:user) { create(:user) }

  before do
    sign_in user
  end

  specify 'Trip CRUD' do
    visit current_years_path

    find(data_test('trips-button')).click
    click_on 'New'
    fill_in 'Name', with: 'A trip'
    fill_in 'Start date', with: "0111#{Date.current.year}"
    fill_in 'End date', with: "0114#{Date.current.year}"
    expect {
      click_on 'Create'
      expect(page).to have_content 'A trip'
    }.to change(Event, :count).by(1)

    day = user.days.find_by(date: Date.new(Date.current.year, 1, 11))
    within find(data_test("month-#{day.month.id}")) do
      expect(page).to have_css '.trip__primary--start'
      expect(page).to have_css '.trip__primary--end'
    end

    click_on 'A trip'
    fill_in 'Name', with: 'Updated trip'
    click_on 'Update'
    click_on 'Updated trip'
    expect {
      click_on 'Delete'
      expect(page).to have_no_content 'Updated trip'
    }.to change(Event, :count).by(-1)

    within find(data_test("month-#{day.month.id}")) do
      expect(page).to have_no_css '.trip__primary--start'
      expect(page).to have_no_css '.trip__primary--end'
    end
  end
end
