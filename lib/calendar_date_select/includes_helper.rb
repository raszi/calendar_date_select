module CalendarDateSelect::IncludesHelper
  def calendar_date_select_stylesheets_loaded?
    @cds_stylesheets_loaded ||= false
  end

  def calendar_date_select_javascripts_loaded?
    @cds_javascripts_loaded ||= false
  end

  # returns the selected calendar_date_select stylesheet (not an array)
  def calendar_date_select_stylesheets(options = {})
    return [] if @cds_stylesheets_loaded

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
    
    includes = [
      javascript_include_tag(*calendar_date_select_javascripts(:locale => options[:locale])),
      stylesheet_link_tag(*calendar_date_select_stylesheets(:style => options[:style]))
    ]
    includes << calendar_date_default_translation unless options[:locale]
    includes
  end

  # from one of the comments of http://code.google.com/p/calendardateselect/wiki/HowToLocalize
  def calendar_date_default_translation
    scope = [ :calendar_date_select ]

    update_page_tag do |page|
      page.assign '_translations', {
        'OK'    => I18n.t(:ok, :scope => scope),
        'Now'   => I18n.t(:now, :scope => scope),
        'Today' => I18n.t(:today, :scope => scope),
        'Clear' => I18n.t(:clear, :scope => scope)
      }
      page.assign 'Date.weekdays', I18n.translate('date.abbr_day_names')
      page.assign 'Date.months', I18n.translate('date.month_names')[1..-1]
    end
  end

end
