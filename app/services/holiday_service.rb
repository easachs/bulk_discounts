class HolidayService

  def holidays
    get_url('https://date.nager.at/api/v3/NextPublicHolidays/US')
  end

  def get_url(url)
    HTTParty.get(url)
  end

end