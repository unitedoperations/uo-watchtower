## Copyright (C) 2019  United Operations
##
## This program is free software: you can redistribute it and/or modify
## it under the terms of the GNU General Public License as published by
## the Free Software Foundation, either version 3 of the License, or
## (at your option) any later version.
##
## This program is distributed in the hope that it will be useful,
## but WITHOUT ANY WARRANTY; without even the implied warranty of
## MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
## GNU General Public License for more details.
##
## You should have received a copy of the GNU General Public License
## along with this program.  If not, see <https://www.gnu.org/licenses/>.

defmodule WatchTower.Forums do
  use HTTPoison.Base

  @expected_fields ~w(primaryGroup secondaryGroups)

  def process_request_url(user_id) do
    "https://unitedoperations.net/forums/api/index.php?/core/members/" <> user_id
  end

  def process_request_headers(_headers) do
    token = 
      Application.get_env(:uo_watchtower, :forums_api_key)
      |> (fn key -> Base.encode64("#{key}:") end).()
    [
      "Authorization": "Basic #{token}",
      "Content-Type": "application/json",
      "Accept": "application/json"
    ]
  end

  def process_response_body(body) do
    body
    |> Poison.decode!
    |> Map.take(@expected_fields)
    |> Enum.map(fn {k, v} -> { String.to_atom(k), v } end)
  end
end
