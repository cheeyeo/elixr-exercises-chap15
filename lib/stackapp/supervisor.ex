defmodule Stackapp.Supervisor do
  use Supervisor.Behaviour

  def start_link(initial_list) do
    # :supervisor.start_link(__MODULE__, initial_list)
    result = {:ok, sup } = :supervisor.start_link(__MODULE__, [initial_list])
    start_workers(sup, initial_list)
    result 
  end

  def start_workers(sup,initial_list) do
    # Start the stash worker
    {:ok, stash} = :supervisor.start_child(sup, worker(Stackapp.Stash, [initial_list]))
    
    # and then the subsupervisor for the actual sequence server
    :supervisor.start_child(sup, supervisor(Stackapp.SubSupervisor, [stash]))
  end

  # def init(initial_list) do
  #     # [ worker(Sequence.Server, [initial_number]) ]
  #     child_processes = [ worker(Stack.Server, [initial_list]) ]
  #     supervise child_processes, strategy: :one_for_one
  #   end

  def init(_) do
    supervise [], strategy: :one_for_one
  end

end