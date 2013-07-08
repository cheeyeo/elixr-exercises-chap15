defmodule Stackapp.Server do
  use GenServer.Behaviour

  @vsn "0"

  ### EXTERNAL API
  def start_link(stash_pid) do
    :gen_server.start_link({:local, :stack},__MODULE__, stash_pid, [debug: [:trace]])
  end

  def pop do
    :gen_server.call :stack, :pop
  end

  def push(item) do
    :gen_server.cast :stack, {:push, item}
  end


  ## Gen Server stuff

  def init(stash_pid) do
    current_list = Stackapp.Stash.get_list stash_pid
    { :ok, {current_list, stash_pid} }
  end

  def handle_call(:pop, _from, {[h|stack], stash_pid}) do
    {:reply, h, {stack,stash_pid}}
  end

  def handle_cast({:push, item},{current_list, stash_pid}) do
    {:noreply, {[item|current_list], stash_pid}}
  end


  def terminate(_reason, {current_list, stash_pid}) do
    Stackapp.Stash.save_list stash_pid, current_list
  end

end
