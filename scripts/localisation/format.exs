# For all .POT files
#   Parse PO to internal format
#     Remove comments
#     Remove duplicate references
#     Sort terms by key
#   Dump out data
#   Bodge data with regex
#     Remove leading #: for long reference
#   Write file

# For all .PO files
#   Parse PO to internal format
#     Remove header
#     Remove comments
#     Remove references
#     Remove flags
#     Sort terms by key
#   Dump data
#   Write file

template_pot = "priv/gettext/*.pot"
template_po = "priv/gettext/*/LC_MESSAGES/*.po"

for {_, app_path} <- Mix.Project.apps_paths() do
  for path <- Path.wildcard(Path.join([app_path, template_pot])) do
    {:ok, data} = File.read(path)
    {:ok, po} = Gettext.PO.parse_string(data)

    translation_fun = fn translation ->
      flags = MapSet.new()
      %{translation | comments: [], extracted_comments: [], references: [], flags: flags}
    end

    translations = po.translations |> Enum.map(translation_fun) |> Enum.sort_by(& &1.msgid)
    iodata = Gettext.PO.dump(%{po | translations: translations})
    data = IO.iodata_to_binary(iodata)
    data = data |> String.replace(~r/\n#:.+\n/, "\n")
    :ok = File.write(path, data)
  end

  for path <- Path.wildcard(Path.join([app_path, template_po])) do
    {:ok, data} = File.read(path)
    {:ok, po} = Gettext.PO.parse_string(data)

    translation_fun = fn translation ->
      flags = MapSet.new()
      %{translation | comments: [], extracted_comments: [], references: [], flags: flags}
    end

    translations = po.translations |> Enum.map(translation_fun) |> Enum.sort_by(& &1.msgid)
    iodata = Gettext.PO.dump(%{po | headers: [], translations: translations})
    :ok = File.write(path, iodata)
  end
end
