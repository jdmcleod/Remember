class EncryptEntries < ActiveRecord::Migration[7.1]
  class Entry < ApplicationRecord
    encrypts :title
    has_rich_text :content, encrypted: true
  end

  def change
    add_column :entries, :tsv, :tsvector
    add_index :entries, :tsv, using: :gin

    up_only do
      Entry.find_each do |entry|
        entry.title_will_change!
        entry.save
      end
    end

    rich_text_scope = ActionText::EncryptedRichText.where(record_type: %w[Entry])
    say_with_time "Encrypting #{rich_text_scope.count} Entries ActionText bodies" do
      rich_text_scope.find_each do |rich_text|
        rich_text.body_will_change!
        rich_text.save
      end

      raise EncryptionFailedError.new if rich_text_scope.where.not("body LIKE ?", '{%').any?
      say 'Success validated!'
    end
  end
end
