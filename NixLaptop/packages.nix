{pkgs, ...}: {
  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    #  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.

    # ---- Base Stuff ----
    wget
    rustup
    clang
    python314
    micro-full
    uv
    lm_sensors

    # -TeX-
    texliveFull
    tex-fmt

    # --- Nix ---
    alejandra
    nixd
    compose2nix

    # --- Apps ---
    vscode-fhs
    brave
    warp-terminal
    waveterm
    kando
    geteduroam
    rustdesk-flutter
    resources
    anytype
    spacedrive
    anki
    beeper
    libreoffice-qt-fresh
    kdePackages.okular
    
    tail-tray
    trayscale
    piper
    solaar
    # ---- CLI ----

    #-Nushell-
    # nushell
    # nufmt
    # nushellPlugins.polars
    # nushellPlugins.gstat
    # nushellPlugins.skim

    # -Misc-
    fish-lsp
    fastfetch
    # -Tools-
    fzf
    eza
    dust
    ripgrep-all
    fd
    dua

    btop

    # manix is CLI for nixsearch.
    manix
    # TLRC is tldr.
    tlrc
    # rip2 is improved rm command.
    rip2

    jujutsu
    lazyjj

    # AI / LLM Stuff
    #fabric-ai
    #ollama
    #alpaca

    lshw-gui

    #  espanso-wayland

    hwinfo
  ];
}
