namespace :db do

task :sendmail => :environment do
  Task.where("tdate" == Date.today.to_s).each do |t|
    require 'pony' 
    Pony.mail({
    :from => "gettingstuffdone123@gmail.com",
    :to => User.find(t.user_id).email,
    :subject => "You have a task to do today",
    :body => "Hi #{User.find(t.user_id).full_name}, don't forget that you have #{t.tname} to do today at #{t.ttime} at #{t.location}",
    :via => :smtp,
    :via_options => {
    :address              => 'smtp.gmail.com',
    :port                 => '587',
    :enable_starttls_auto => true,
    :user_name            => 'gettingstuffdone123@gmail.com',
    :password             => 'shit_to_do',
    :authentication       => :plain, 
    :domain               => "localhost.localdomain" 
     }
    })
    end
  end
end