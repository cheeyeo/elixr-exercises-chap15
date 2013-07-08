defmodule Stackapp.Stash do
  use GenServer.Behaviour

  def start_link(current_list) do
    :gen_server.start_link( __MODULE__, current_list, [])
  end

  def get_list(pid) do
    :gen_server.call pid, :get_list
  end

  def save_list(pid, value) do
    :gen_server.cast pid, {:save_list, value}
  end


  ####
  # GenServer implementation

  def init(current_list)
    when is_list(current_list) do
      {:ok, current_list}
  end

  def handle_call(:get_list, _from, current_list) do
    {:reply, current_list, current_list}
  end

  def handle_cast({:save_list, value}, _current_list) do
    {:noreply,value}
  end


end