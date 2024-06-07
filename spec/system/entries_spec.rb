# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Entry', type: :system, js: true do
  let(:date) { Date.today.beginning_of_year }
  let(:user) { create(:user) }

  before do
    sign_in user
  end

  describe 'entering short entry' do
    it 'allows the user to enter a short entry' do
      visit current_years_path

      day = user.days.on(date)

      text = 'hello, this is a cool day!'
      find(data_test("day-#{day.id}")).click
      expect {
        within find(data_test('day-popup-form')) do
          input = find(data_test'short-entry-input')
          input.set text
        end
      }.to change(Entry, :count).by(1)

      find('.header').click
      entry = Entry.last
      expect(entry.journalable).to eq day
      expect(page).to_not have_css data_test('day-popup-form')
      expect(entry.content.body.to_plain_text).to eq text
    end
  end
end
