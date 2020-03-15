defmodule Mix.Tasks.Routekut.Create do
  use Mix.Task

  @shortdoc "Downloads and creates route config files."

  def run(_) do
    Application.ensure_all_started(:routekut)
    start_time = System.system_time(:second)
    Routekut.download_and_create()
    IO.puts("Finished! Took #{System.system_time(:second) - start_time} seconds")
  end
end
