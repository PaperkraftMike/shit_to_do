require 'sinatra/activerecord/rake'
require './shit_to_do'

task :sendmail do 
  Task.where("tdate" == Date.today).each do |t|
    Pony.mail({
    :from => "gettingstuffdone123@gmail.com",
    :to => User.where(t.user_id).email,
    :subject => "You have a task to do today",
    :body => "Hi #{User.where(t.user_id).full_name}, don't forget that you have #{t.tname} to do today at #{t.ttime} at #{t.location}",
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