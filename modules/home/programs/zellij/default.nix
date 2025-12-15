# modules/home/programs/zellij/default.nix
{
  lib,
  pkgs,
  inputs,
  namespace,
  system,
  target,
  format,
  virtual,
  systems,
  config,
  ...
}: let
  cfg = config.profiles.${namespace}.my.home.programs.zellij;

  inherit (lib) mkIf;
  inherit (lib.${namespace}) enabled mkBoolOpt;
in {
  options.profiles.${namespace}.my.home.programs.zellij = {
    enable = mkBoolOpt false "Enable custom module for platform 'home', of category 'programs', of module 'zellij', for namespace '${namespace}'.";
  };
  imports = [./plugins.nix];
  config = mkIf cfg.enable {
    programs.zellij = {
      enable = true;
      settings = {
        default_mode = "locked";
        scrollback_editor = "hx";
        pane_frames = false;
        keybinds = {
          locked = {
            # "bind \"Alt i\"" = {
            # };
            "bind \"Alt [\"" = {
              SwitchToMode = ["entersearch"];
            };

            "bind \"Alt j\"" = {
              EditScrollback = [];
            };
            "bind \"Alt \\\\\"" = {
              ToggleFloatingPanes = [];
            };
            # "bind \"Alt ]\"" = {
            #   MoveTab = ["Right"];
            # };
            # "bind \"Alt [\"" = {
            #   MoveTab = ["Left"];
            # };
            "bind \"Alt l\"" = {
              GoToNextTab = [];
            };
            "bind \"Alt h\"" = {
              GoToPreviousTab = [];
            };
            "bind \"Alt r\"" = {
              SwitchToMode = ["renametab"];
              TabNameInput = [0];
            };
            "bind \"Alt z\"" = {
              FocusNextPane = [];
            };

            # "bind \"Alt r\"" = {
            #   NewTab = [];
            #   SwitchToMode = ["renametab"];
            #   TabNameInput = [0];
            # };
          };
          renametab = {
            "bind \"Enter\"" = {
              SwitchToMode = ["locked"];
            };
          };

          # Doesn't work: make 'w' key (picking the manager) in locked mode automatically
          # session = {
          #   "bind \"w\"" = {
          #     SwitchToMode = ["locked"];
          #   };
          # };
          # tab = {
          #   "bind \"Alt ]\"" = {
          #     MoveTab = ["Right"];
          #   };
          #   "bind \"Alt [\"" = {
          #     MoveTab = ["Left"];
          #   };
          # };
        };
      };
    };
    # TODO
    # this is jank, please do something more elegant!
    xdg.configFile."zellij/layouts/custom.kdl".text = ''
      layout {
          pane split_direction="vertical" {
              pane
          }

          pane size=1 borderless=true {
              plugin location="file:${pkgs.zjstatus}/bin/zjstatus.wasm" {
                  format_left  "{mode}#[fg=#a89984,bg=#363231] #[fg=#363231,bg=#a89984,italic]{tabs}#[fg=#a89984,bg=#363231]"
                  format_right "#[fg=#d5c4a1,bg=#363231]{datetime}#[fg=#a89984,bg=#d5c4a1] #[fg=#363231,bg=#a89984] {session} #[fg=#a89984,bg=#363231]▒░"
                  format_space "#[bg=#363231]"

                  border_enabled  "true"
                  border_char     "─"
                  border_format   "#[fg=#b8bb26]{char}"
                  border_position "top"

                  hide_frame_for_single_pane "true"

                  mode_normal        "#[fg=#b8bb26,bg=#363231] #[fg=#363231,bg=#b8bb26]  {name} #[fg=#b8bb26,bg=#363231] "
                  mode_locked        "#[fg=#fb4934,bg=#363231] #[fg=#363231,bg=#fb4934]  {name} #[fg=#fb4934,bg=#363231] "
                  mode_resize        "#[fg=#d79921,bg=#363231] #[fg=#363231,bg=#d79921]  {name} #[fg=#d79921,bg=#363231] "
                  mode_pane          "#[fg=white,bg=#363231] #[fg=#363231,bg=white] 󰓫 {name} #[fg=white,bg=#363231] "
                  mode_tab           "#[fg=#fabd2f,bg=#363231] #[fg=#363231,bg=#fabd2f] 󰓩 {name} #[fg=#fabd2f,bg=#363231] "
                  mode_scroll        "#[fg=#83a59a,bg=#363231] #[fg=#363231,bg=#83a59a]  {name} #[fg=#83a59a,bg=#363231] "
                  mode_enter_search  "#[fg=white,bg=#363231] #[fg=#363231,bg=white] {name} #[fg=white,bg=#363231] "
                  mode_search        "#[fg=white,bg=#363231] #[fg=#363231,bg=white] {name} #[fg=white,bg=#363231] "
                  mode_rename_tab    "#[fg=white,bg=#363231] #[fg=#363231,bg=white] {name} #[fg=white,bg=#363231] "
                  mode_rename_pane   "#[fg=white,bg=#363231] #[fg=#363231,bg=white] {name} #[fg=white,bg=#363231] "
                  mode_session       "#[fg=white,bg=#363231] #[fg=#363231,bg=white] {name} #[fg=white,bg=#363231] "
                  mode_move          "#[fg=white,bg=#363231] #[fg=#363231,bg=white] {name} #[fg=white,bg=#363231] "
                  mode_prompt        "#[fg=white,bg=#363231] #[fg=#363231,bg=white] {name} #[fg=white,bg=#363231] "
                  mode_tmux          "#[fg=white,bg=#363231] #[fg=#363231,bg=white] {name} #[fg=white,bg=#363231] "

                  tab_normal   "#[fg=#363231,bg=#a89984,italic] {name} "
                  tab_active   "#[fg=#ebdbb2,bg=#a89984,bold]#[fg=#363231,bg=#ebdbb2,bold]{index}  {name}#[fg=#ebdbb2,bg=#a89984,bold]"

                  command_git_branch_command   "git rev-parse --abbrev-ref HEAD"
                  command_git_branch_format    "#[fg=blue] {stdout} "
                  command_git_branch_interval  "10"

                  datetime        "#[fg=#363231,bg=#d5c4a1]󰃭 {format}"
                  datetime_format "%d/%m/%Y"
                  datetime_timezone "Europe/Paris"
              }
          }
      }
    '';
  };
}
