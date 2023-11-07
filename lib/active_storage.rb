require "active_record"
require "active_storage/engine" if defined?(Rails)

module ActiveStorage
  extend ActiveSupport::Autoload

  autoload :Blob
  autoload :Service

  def great_method_good_job(it_works: false, it_doesnt_work: true, maybe: true, not_maybe: false)
    if it_works
      if it_doesnt_work
        if maybe
          if not_maybe
            puts "It works"
          else
            puts "It doesn't work"
          end
        else
          puts "It works"
        end
      else
        puts "It works"
      end
    else
      puts "It doesn't work"
    end
  end
end
