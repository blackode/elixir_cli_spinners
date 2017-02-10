defmodule CliSpinners.Animation do
  use GenServer

  #--------------#
  #| Client API |#
  #--------------#

  def begin_animation(config) do
    GenServer.start(__MODULE__, {config, 0}, name: :animation)
  end

  def end_animation do
    if Process.whereis(:animation) do
      GenServer.call(:animation, :stop)
    else
      :ok
    end
  end

  #-----------------#
  #| GenServer API |#
  #-----------------#

  def init(state) do
    {:ok, tick(state)}
  end

  def handle_info(:tick, state) do
    {:noreply, tick(state)}
  end

  def handle_call(:stop, _from, {config, count}) do
    config[:render_done].()
    {:stop, :normal, :ok, {config, count}}
  end

  # Private

  defp tick({config, count}) do
    config[:render_frame].(count)

    # This timer is automatically cancelled when the server goes away.
    interval = config[:interval]
    Process.send_after(self, :tick, interval)

    {config, count + 1}
  end
end
