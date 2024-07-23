require 'rails_helper'

RSpec.describe Entry, type: :model do
  let(:user) { create(:user) }
  let(:day) { create(:day) }

  describe 'after_save' do
    it 'stores vectorized content that is searchable' do
      entry = create(:entry, :with_content, content: 'The story of a dog', journalable: day)
      _entry_1 = create(:entry, :with_content, content: 'Why are we here', journalable: day)
      entry_2 = create(:entry, :with_content, content: 'Do all dogs go to heaven?', journalable: day)

      expect(entry.content.to_plain_text).to eq 'The story of a dog'
      expect(entry.tsv).to eq "'dog':5 'stori':2"

      expect(Entry.search('dog')).to match_array([entry, entry_2])
    end
  end
end
