module BeRealApi
  module V1
    class Importer
      def self.import
        puts 'Importing BeReal memories...'
        users_to_import = User.includes(:be_real_connection).where.not(be_real_connection: { bereal_access_token: nil })
        users_to_import_count = users_to_import.count

        users_to_import.find_each.with_index do |user, user_index|
          puts "Importing memories for #{user.name}. (#{user_index + 1}/#{users_to_import_count})"

          days_to_import = user.days.where('date <= ?', DateTime.current).where.missing(:be_real_memories)
          days_to_import_count = days_to_import.count

          next if days_to_import.count.zero?

          memory_collection = user.be_real_connection.memories

          days_to_import.find_each.with_index do |day, day_index|
            puts "Importing memories for #{day.date.to_fs(:full_date)}. (#{day_index + 1}/#{days_to_import_count})"

            memory_data = memory_collection.for_date(day.date)

            next if memory_data.empty?

            memory_data.each do |raw_memory|
              # TODO: Probably should be a transaction so if one of the image attachments fails, the memory isn't created
              new_memory = day.be_real_memories.create(
                be_real_id: raw_memory.id,
                location: raw_memory.location,
                late: raw_memory.is_late?,
              )

              new_memory.attach_image_from(raw_memory.primary.url, :primary)
              new_memory.attach_image_from(raw_memory.secondary.url, :secondary)
              new_memory.attach_image_from(raw_memory.thumbnail.url, :thumbnail)
            end

            puts "Finished Importing memories for #{day.date.to_fs(:full_date)}"
          end

          puts "Finished Importing memories for #{user.name}"
        end

        puts 'Finished Importing BeReal memories...'
      end
    end
  end
end
