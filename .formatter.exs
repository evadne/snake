[
  import_deps: [:phoenix, :ecto],
  inputs: [
    "apps/*/{lib,config,test}/**/*.{ex,exs}",
    "apps/*/priv/*/seeds.exs",
    "apps/*/mix.exs",
    "*.{ex,exs}",
    "{config,lib,scripts,test}/**/*.{ex,exs}"
  ],
  subdirectories: ["priv/*/migrations"]
]
