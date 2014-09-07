module ApplicationHelper
  def time_ago_in_words_short(from_time, options={})
    # time_ago_in_words(from_time, options).gsub(' year','y').gsub(' minute','mi.').gsub(' hour','h').gsub(' day','d').gsub(' month','mo.').gsub(' second','sec').gsub('about ','').gsub(/s\z/,' ')
    time_ago_in_words(from_time, options).gsub('about ','')
  end


  def page_links(options = {})
    options = {
      current_page_number: 1,
      items_per_page: 10,
      total_items: 99,
      url: 'page=[[page]]'
      }.merge(options)
    options[:current_page_number] = options[:current_page_number].to_i 
    options[:current_page_number] = 1 if options[:current_page_number] < 1
    total_pages = ((options[:total_items]-1) / options[:items_per_page]) + 1

    if options[:current_page_number]==1
      html = "<ul class=\"pagination\">\n<li class=\"prev disabled\"><span>&#8592; Previous</span></li>\n"
    else
      html = "<ul class=\"pagination\">\n<li class=\"prev \"><a href=\"#{options[:url].gsub('[[page]]', (options[:current_page_number]-1).to_s)}\">&#8592; Previous</a></li>\n"
    end 

    rendered_previous = true
    1.upto(total_pages) do |current_page|
      link = options[:url].gsub('[[page]]', current_page.to_s)
      if (current_page<3) || (total_pages-current_page < 3) || ([options[:current_page_number], current_page].max - [options[:current_page_number], current_page].min < 2)
        klass = options[:current_page_number]==current_page ? ' class="active"' : ''
        html << "<li#{klass}><a href=\"#{link}\">#{current_page}</a></li>\n"
        rendered_previous = true 
      else 
        html << "<li class=\"disabled\"><a>...</a></li>" if rendered_previous 
        rendered_previous = false
      end 
    end 

    if options[:current_page_number]==total_pages 
      html << "<li class=\"next disabled\"><span>Next &#8594;</span></li></ul>"
    else 
      html << "<li class=\"next\"><a href=\"#{options[:url].gsub('[[page]]', (options[:current_page_number]+1).to_s)}\">Next &#8594;</a></li></ul>"
    end 

    html.html_safe
  end 

end
