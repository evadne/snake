defmodule SnakeData.Repo.Migrations.SetupSystem do
  use Ecto.Migration

  def up do
    execute "CREATE EXTENSION \"btree_gist\" WITH SCHEMA public"
    execute "CREATE EXTENSION \"citext\" WITH SCHEMA public"
    execute "CREATE EXTENSION \"pgcrypto\" WITH SCHEMA public"
    execute "CREATE EXTENSION \"pgstattuple\" WITH SCHEMA public"
    execute "CREATE EXTENSION \"pg_stat_statements\" WITH SCHEMA public"
    execute "CREATE EXTENSION \"uuid-ossp\" WITH SCHEMA public"
  end

  def down do
    execute "DROP EXTENSION \"uuid-ossp\""
    execute "DROP EXTENSION \"pg_stat_statements\""
    execute "DROP EXTENSION \"pgstattuple\""
    execute "DROP EXTENSION \"pgcrypto\""
    execute "DROP EXTENSION \"citext\""
    execute "DROP EXTENSION \"btree_gist\""
  end
end
