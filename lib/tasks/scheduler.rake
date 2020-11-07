desc "Send Daily Poem to Users"
task send_daily_poem: :environment do
   User.send_daily_poem
end
