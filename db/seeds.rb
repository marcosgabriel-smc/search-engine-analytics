# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# CLEAN DB
######################################################################
puts 'Cleaning the database...'
Article.destroy_all
Log.destroy_all


# Articles

puts 'Creating some dummy articles...'

30.times do
  Article.create!(
    {
      title: Faker::Book.unique.title,
      content: Faker::Lorem.paragraph(sentence_count: 30, supplemental: true, random_sentences_to_add: 50),
    }
  )
end

# Logs

puts 'Creating some dummy logs...'

countries = ["Brazil", "United States", "India", "Pakistan", "Argentina", "Mexico", "Canada", "Germany", "France", "Spain", "Japan", "China", "Australia", "Angola", "Madagascar", "Morroco"]
3000.times do
  Log.create!(
    {
      input: Faker::Book.title,
      ip: Faker::Internet.ip_v4_address,
      country: countries.sample,
      created_at: Time.now - rand(0..30).days,
      is_processed: true
    }
  )
end

puts "Creating our dummy top users..."

ipAddresses = ["192.168.0.1", "10.0.0.1", "172.16.0.1", "192.0.2.1", "198.51.100.1"]
100.times do
  Log.create!(
    {
      input: Faker::Book.title,
      ip: ipAddresses.sample,
      country: countries.sample,
      created_at: Time.now - rand(0..30).days,
      is_processed: true
    }
  )
end

puts "Creating some bad logs..."

base_time = Time.now - 3.hours

Log.create!(
  ip: '192.168.1.1',
  input: "XXX - A",
  country: "Brazil",
  is_processed: false,
  created_at: base_time - 13.minutes
)
Log.create!(
  ip: '192.168.1.1',
  input: "XXX - Al",
  country: "Brazil",
  is_processed: false,
  created_at: base_time - 12.minutes
)
Log.create!(
  ip: '192.168.1.1',
  input: "XXX - All",
  country: "Brazil",
  is_processed: false,
  created_at: base_time - 11.minutes
)
Log.create!(
  ip: '192.168.1.1',
  input: "XXX - All ",
  country: "Brazil",
  is_processed: false,
  created_at: base_time - 10.minutes
)
Log.create!(
  ip: '192.168.1.1',
  input: "XXX - All the query",
  country: "Brazil",
  is_processed: false,
  created_at: base_time - 9.minutes
)

puts 'All set to go!'
