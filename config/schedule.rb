pwd = File.expand_path File.dirname(__FILE__)
log_dir = File.expand_path "#{pwd}/../logs"

every :hour do 
   command "bundle exec restart-workers.rb", :output => "#{log_dir}/whenever.log"
end
