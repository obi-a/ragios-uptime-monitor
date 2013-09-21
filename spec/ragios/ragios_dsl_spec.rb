require 'spec_base.rb'

#add code to excute when a test fails
run_in_failure = lambda{
                       puts 'test has failed'
                       puts 'do some failure recovery here'
                      }

run_in_fixed = lambda{
                       puts 'test has fixed'
                       puts 'running on fixed'
                      }

    monitoring = { monitor: 'url',
                   every: '30s',
                   test: 'github repo a http test',
                   url: 'https://github.com/obi-a/Ragios',
                   contact: 'obi.akubue@mail.com',
                   via: 'gmail_notifier',  
                   notify_interval:'6h'
                  
                  },
		   {monitor: 'http',
                    every: '2m',
                    test: 'google site test',
                    domain: 'www.google.com',
                    contact: 'obi.akubue@mail.com',
                    via: 'gmail_notifier',  
                    notify_interval: '6h'
                  } ,
                  { monitor: 'url',
                   every: '2m',
                   test: 'fake url test',
                   url: 'http://www.google.com/fail/',
                   contact: 'obi.akubue@mail.com',
                   via: 'gmail_notifier',  
                   notify_interval: '6h'
                  },
                  { monitor: 'url',
                   every: '2m',
                   test: 'lambda test - the monitors test is expected to fail',
                   url: 'http://www.google.com/fail/',
                   contact: 'obi.akubue@mail.com',
                   via: 'gmail_notifier',  
                   notify_interval: '6h',
                   failed: run_in_failure,
                   fixed: run_in_fixed 
                  }
               

 describe Ragios::Controller do 

   it "should initialize all monitors and activate the scheduler" do 
        monitors = Ragios::Controller.run_monitors(monitoring)

     monitors.each do |monitor|  
         puts monitor.num_tests_failed.to_s
         puts monitor.num_tests_passed.to_s
         puts monitor.total_num_tests.to_s
         puts monitor.test_description 
         puts monitor.creation_date
         puts monitor.time_of_last_test
     end
   end
end

