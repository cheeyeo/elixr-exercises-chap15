defmodule Stackapp do

  def start(_type, initial_list) do 
    Stackapp.Supervisor.start_link(initial_list)
  end

end
