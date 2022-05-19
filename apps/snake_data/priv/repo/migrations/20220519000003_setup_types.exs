defmodule SnakeData.Repo.Migrations.SetupTypes do
  use Ecto.Migration

  def up do
    execute "CREATE DOMAIN public.nonempty_citext AS citext CHECK (VALUE <> '');"
    execute "CREATE DOMAIN public.nonempty_citext_array AS citext[] CHECK ((NOT VALUE @> ARRAY[''::citext]) AND (NOT VALUE @> ARRAY[NULL::citext]));"
    execute "CREATE DOMAIN public.nonempty_string AS text CHECK (VALUE <> '');"
    execute "CREATE DOMAIN public.nonempty_string_array AS text[] CHECK ((NOT VALUE @> ARRAY[''::text]) AND (NOT VALUE @> ARRAY[NULL::text]));"
  end

  def down do
    execute "DROP DOMAIN public.nonempty_string_array;"
    execute "DROP DOMAIN public.nonempty_string;"
    execute "DROP DOMAIN public.nonempty_citext_array;"
    execute "DROP DOMAIN public.nonempty_citext;"
  end
end
