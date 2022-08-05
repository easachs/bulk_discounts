class HolidaySearch
  
  def next_three_holidays
    service.holidays[0..2].map do |holiday|
      "#{holiday["name"]} - #{holiday["date"]}"
    end
  end

  def service
    HolidayService.new
  end

end