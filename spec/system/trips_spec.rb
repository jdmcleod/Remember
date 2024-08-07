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
      click_on 'Add'
      expect(page).to have_content 'A trip'
    }.to change(Event, :count).by(1)

    click_on 'A trip'
    fill_in 'Name', with: 'Updated trip'
    click_on 'Update'
    click_on 'Updated trip'
    expect {
      click_on 'Delete'
      expect(page).to have_no_content 'Updated trip'
    }.to change(Event, :count).by(-1)
  end
end
