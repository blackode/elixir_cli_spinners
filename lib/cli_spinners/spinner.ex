defmodule CliSpinners.Spinner do
  @moduledoc ~S"""
  #Intro
  This is real spinner module. This module is responsible for the actual
  spinning process. This is where the spinning configuration, rendering frame
  and getting appropriate list frames based on the atom passed.

  """
  alias CliSpinners.Utils

  @default_format [
    frames: :line,         # This theme is set when no theme is set
    spinner_color: [],     # The color code of the spinner
    text: "Loading…",      # The prefix text of the spinner
    done: "Loaded.",       # This text prints after ending the apinning
    interval: 100,         # This is the default time interval used to render
                           # The frame sequence
  ]

  @doc ~S"""
  This is actual definition for rendering spinning animation. This usuallly takes
  Two prameters. This firs param is **configuration** which is optional and the
  second one is **function**.

  The animation begins once if the confuguration is set with the given format.
  This animation lasts long until the **function** finishes its code of execution.
  The animation stops once if the function raise the exception.

  ##  Examples
    iex> ClisSpinner.Spinner.render([text: "Please wait...",frames: ["⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏"]])
    iex> CliSpinners.Spinner.render([text: "collecting...",frames: :dots])
    iex> CliSpinners.Spinner.render_()



  """

  def render(custom_format \\ @default_format, fun) do
    format = Keyword.merge(@default_format, custom_format)

    config = [
      interval: format[:interval],
      render_frame: fn (count) -> render_frame(format, count) end,
      render_done:  fn -> render_done(format[:done]) end,
    ]

    CliSpinners.Animation.begin_animation(config)
    value = fun.()
    CliSpinners.Animation.end_animation()
    value
  end

  defp render_frame(format, count) do
    frames = get_frames(format[:frames])
    index = rem(count, length(frames))
    frame = Enum.at(frames, index)

    IO.write [
      Utils.ansi_prefix(),
      Utils.color(frame, format[:spinner_color]),
      " ",
      format[:text],
    ]
  end

  defp render_done(:remove), do: IO.write(Utils.ansi_prefix())
  defp render_done(text) do
    IO.write [
      Utils.ansi_prefix(),
      text,
      "\n",
    ]
  end

  defp get_frames(list) when is_list(list), do: list
  defp get_frames(theme) when is_atom(theme) do
    _frames = Kernel.apply(CliSpinners.Spinners, theme, [])
  end

end

