{ config, lib, ... }:
let
  name = "lazygit";
  cfg = config.smi.programs.${name};
in
{
  options.smi.programs.${name} = {
    enable = lib.mkEnableOption name;
  };

  config = lib.mkIf cfg.enable {
    programs.lazygit = {
      enable = true;
      settings = {
        customCommands = [
          {
            key = "C";
            context = "global";
            description = "Commit mit gitmoji";
            prompts = [
              {
                type = "menu";
                title = "Wähle ein gitmoji";
                options = [
                  {
                    value = ":sparkles:";
                    name = "✨  :sparkles: — neues Feature";
                  }
                  {
                    value = ":bug:";
                    name = "🐛  :bug: — Bugfix";
                  }
                  {
                    value = ":memo:";
                    name = "📝  :memo: — Doku";
                  }
                  {
                    value = ":recycle:";
                    name = "♻️  :recycle: — Refactor";
                  }
                  {
                    value = ":fire:";
                    name = "🔥  :fire: — Code/Files entfernt";
                  }
                  {
                    value = ":lipstick:";
                    name = "💄  :lipstick: — UI/Style";
                  }
                  {
                    value = ":zap:";
                    name = "⚡  :zap: — Performance";
                  }
                  {
                    value = ":lock:";
                    name = "🔒  :lock: — Security";
                  }
                  {
                    value = ":wrench:";
                    name = "🔧  :wrench: — Config";
                  }
                  {
                    value = ":construction:";
                    name = "🚧  :construction: — WIP";
                  }
                  {
                    value = ":white_check_mark:";
                    name = "✅  :white_check_mark: — Tests";
                  }
                  {
                    value = ":green_heart:";
                    name = "💚  :green_heart: — CI fix";
                  }
                  {
                    value = ":arrow_up:";
                    name = "⬆️  :arrow_up: — Deps upgrade";
                  }
                  {
                    value = ":arrow_down:";
                    name = "⬇️  :arrow_down: — Deps downgrade";
                  }
                  {
                    value = ":rewind:";
                    name = "⏪  :rewind: — Revert";
                  }
                  {
                    value = ":tada:";
                    name = "🎉  :tada: — Initial commit";
                  }
                ];
              }
              {
                type = "input";
                title = "Commit-Message";
              }
            ];
            command = ''git commit -m "{{index .PromptResponses 0}} {{index .PromptResponses 1}}"'';
          }
        ];
      };
    };
  };
}
