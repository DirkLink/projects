class Train
  attr_reader :line, :destination, :min

  def initialize api_data
    @line             = api_data.fetch "Line"
    @destination      = api_data.fetch "DestinationName"
    @min              = api_data.fetch "Min"
  end
end