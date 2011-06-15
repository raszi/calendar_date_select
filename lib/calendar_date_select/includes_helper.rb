module CalendarDateSelect::IncludesHelper
  def calendar_date_select_stylesheets_loaded?
    @cds_stylesheets_loaded ||= false
  end

  def calendar_date_select_javascripts_loaded?
    @cds_javascripts_loaded ||= false
  end

  # returns the selected calendar_date_select stylesheet (not an array)
  def calendar_date_select_stylesheets(options = {})
    return "" if @cds_stylesheets_loaded

    @cds_stylesheets_loaded = true

    options.assert_valid_keys(:style)
    "calendar_date_select/#{options[:style] || "default"}"
  end

  # returns an array of javascripts needed for the selected locale, date_format, and calendar control itself.
  def calendar_date_select_javascripts(options = {})
    return [] if @cds_javascripts_loaded

    @cds_javascripts_loaded = true

    options.assert_valid_keys(:locale)
    files = ["calendar_date_select/calendar_date_select"]
    files << "calendar_date_select/locale/#{options[:locale]}" if options[:locale]
    files << "calendar_date_select/#{CalendarDateSelect.format[:javascript_include]}" if CalendarDateSelect.format[:javascript_include]
    files
  end

  # returns html necessary to load javascript and css to make calendar_date_select work
  def calendar_date_select_includes(*args)
    options = (Hash === args.last) ? args.pop : {}
    options.assert_valid_keys(:style, :locale)
    options[:style] ||= args.shift
    
    javascript_include_tag(*calendar_date_select_javascripts(:locale => options[:locale])) + "\n" +
    stylesheet_link_tag(*calendar_date_select_stylesheets(:style => options[:style])) + "\n"
  end
end
