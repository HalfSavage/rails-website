module HalfSavageFlashHelper

  def half_savage_flash
    flash_messages = []
    flash.each do |type, message|

      # Skip empty messages, e.g. for devise messages set to nothing in a locale file.
      next if message.blank?

      # NOTE: Beginning with Rails 4.1, the keys in the flash object are 
      # strings (ie, 'error') and not symbols (ie, :error)
      # NOTE 2: Some of the flash types below are custom; they're registered 
      # in app/controllers/application_controller.rb
      css_class = case type 
        when 'alert' 
          'alert-warning'
        when 'notice' 
          'alert-info'
        when 'success' 
          'alert-success'
        when 'warning'
          'alert-warning'
        when 'danger' 
          'alert-danger'
        else 
          'alert-info'
      end 

      Array(message).each do |msg|
        puts 'poop!'
        text = content_tag(:div,
                           content_tag(:button, raw("&times;"), :class => "close", "data-dismiss" => "alert") +
                           msg.html_safe, :class => "alert fade in #{css_class}")
        flash_messages << text if msg
      end
    end
    flash_messages.join("\n").html_safe
  end
end
