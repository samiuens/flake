{ helpers, platform, ... }:
{
  imports = helpers.importPlatformDir platform ./.;
}
