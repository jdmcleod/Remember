desc 'Pull in BeRealMemories'
task sync_be_real_memories: :environment do |t|
  BeRealApi::V1::Importer.import
end
