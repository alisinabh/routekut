defmodule Routekut do
  @moduledoc """
  Routekut creates routing configuration based files for countries.
  """

  require Logger

  @dbip_url "https://download.db-ip.com/free/dbip-country-lite-$YEAR-$MONTH.csv.gz"

  def download_and_create do
    {:ok, csv} = download_latest_database()

    csv
    |> decode_csv()
    |> Enum.group_by(&Map.get(&1, :iso))
    |> Enum.each(fn {iso, ips} ->
      File.mkdir_p!("db/country/#{String.downcase(iso)}")

      cidrs =
        ips
        |> list_to_cidrs()
        |> Enum.join("\n")

      File.write!("db/country/#{String.downcase(iso)}/ipv4.cidr", cidrs)
    end)
  end

  defp list_to_cidrs(ips) do
    Enum.reduce(ips, [], fn range, acc ->
      with cidrs when is_list(cidrs) <-
             CIDR.parse_range("#{ntoa(range.from)}-#{ntoa(range.until)}") do
        formatted = Enum.reduce(cidrs, [], fn c, acc -> ["#{ntoa(c.first)}/#{c.mask}" | acc] end)
        acc ++ formatted
      else
        error ->
          Logger.error("CIDR parse error: #{inspect(error)}")
          acc
      end
    end)
  end

  defp ntoa({i1, i2, i3, i4}), do: "#{i1}.#{i2}.#{i3}.#{i4}"
  defp ntoa(bin), do: bin

  defp decode_csv(csv) do
    csv
    |> String.split("\n")
    |> Enum.reduce([], fn line, acc ->
      case String.split(line, ",") do
        [from, until, iso] ->
          [%{from: from, until: until, iso: iso} | acc]

        [""] ->
          acc

        unmatch ->
          Logger.warn("Unmatched line #{unmatch}. Cannot decode!")

          acc
      end
    end)
  end

  defp download_latest_database do
    url =
      @dbip_url
      |> String.replace("$YEAR", to_string(DateTime.utc_now().year))
      |> String.replace("$MONTH", fxlen(DateTime.utc_now().month))

    Logger.info("Downloading #{url}")

    with {:ok, %{status_code: 200, body: csv_gz}} <- HTTPoison.get(url) do
      Logger.info("Download finished")
      Logger.info("Unzipping...")

      csv =
        [csv_gz]
        |> StreamGzip.gunzip()
        |> Enum.into("")

      {:ok, csv}
    else
      error ->
        Logger.error("Error: #{inspect(error)}")
        :error
    end
  end

  defp fxlen(n) when n > 9, do: "#{n}"
  defp fxlen(n), do: "0#{n}"
end
