# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Entry', type: :system, js: true do
  let(:date) { Date.current.beginning_of_year }
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
        find(data_test('save-short-entry')).click
        expect(page).to have_flash_notice "Updated entry on #{day.date&.strftime("%B %d, %Y")}"
      }.to change(Entry, :count).by(1)

      find('.header').click
      entry = Entry.last
      expect(entry.journalable).to eq day
      expect(page).to_not have_css data_test('day-popup-form')
      expect(entry.content.body.to_plain_text).to eq text
    end
  end

  describe 'entering month entry' do
    it 'allows the user to enter a short entry' do
      visit current_years_path

      month = user.months.first

      text = 'hello, this is a cool day!'
      find(data_test("edit-month-entry-#{month.id}")).click
      expect {
        within find('#modal') do
          input = find(data_test('month-entry-text-area'))
          input.set text
        end
      }.to change(Entry, :count).by(1)

      click_on 'Save'
      entry = Entry.last
      expect(entry.journalable).to eq month
      expect(page).to_not have_css('.modal-wrapper--active')
      expect(entry.content.body.to_plain_text).to eq text
      expect(page).to have_flash_notice 'Updated month entry'
    end
  end

  describe 'searching' do
    let(:day_1) { create(:day, date: Date.new(2024, 1, 1))}
    let(:day_2) { create(:day, date: Date.new(2024, 1, 2))}
    let(:day_3) { create(:day, date: Date.new(2024, 1, 3))}
    let!(:entry_1) { create(:entry, :with_content, journalable: day_1, user:, content: 'Dogs are cool')}
    let!(:entry_2) { create(:entry, :with_content, journalable: day_2, user:, content: 'Cats are nice')}
    let!(:entry_3) { create(:entry, :with_content, journalable: day_3, user:, content: 'Take your dog for a walk bro')}

    it 'shows entries with content matching search term' do
      Timecop.travel(day_1.date) do
        visit current_years_path

        find(data_test('search-button')).click
        find(data_test('search-input')).send_keys(['dog', :enter])
        expect(page).to have_content entry_1.title
        expect(page).to have_content entry_3.title
        expect(page).to_not have_content entry_2.title
      end
    end
  end
end
