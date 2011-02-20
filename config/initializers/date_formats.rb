# $Id$
my_formats = {
  :time_period_date_with_time => '%B %d, %Y %H:%M',
  :time_period_date => '%B %d, %Y',
  :short_date_with_year => '%b %d, %Y'
}

ActiveSupport::CoreExtensions::Time::Conversions::DATE_FORMATS.merge!(my_formats)
ActiveSupport::CoreExtensions::Date::Conversions::DATE_FORMATS.merge!(my_formats)
