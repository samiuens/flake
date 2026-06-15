# Peskyfox — UI Cleanup & Experience
# https://github.com/yokoffing/Betterfox
{ config, lib, ... }:
{
  config = lib.mkIf config.smi.programs.zen.enable {
    programs.zen-browser.profiles.default.settings = {

      /**
        MOZILLA UI *
      */
      "extensions.getAddons.showPane" = false;
      "extensions.htmlaboutaddons.recommendations.enabled" = false;
      "browser.discovery.enabled" = false;
      "browser.shell.checkDefaultBrowser" = false;
      "browser.newtabpage.activity-stream.asrouter.userprefs.cfr.addons" = false;
      "browser.newtabpage.activity-stream.asrouter.userprefs.cfr.features" = false;
      "browser.preferences.moreFromMozilla" = false;
      "browser.aboutConfig.showWarning" = false;
      "browser.startup.homepage_override.mstone" = "ignore";
      "browser.aboutwelcome.enabled" = false;
      "browser.profiles.enabled" = true;

      /**
        THEME ADJUSTMENTS *
      */
      "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
      "browser.compactmode.show" = true;
      "browser.privateWindowSeparation.enabled" = false;

      /**
        AI *
      */
      "browser.ai.control.default" = "blocked";
      "browser.ml.enable" = false;
      "browser.ml.chat.enabled" = false;
      "browser.ml.chat.menu" = false;
      "browser.tabs.groups.smart.enabled" = false;
      "browser.ml.linkPreview.enabled" = false;

      /**
        FULLSCREEN NOTICE *
      */
      "full-screen-api.transition-duration.enter" = "0 0";
      "full-screen-api.transition-duration.leave" = "0 0";
      "full-screen-api.warning.timeout" = 0;

      /**
        URL BAR *
      */
      "browser.urlbar.trending.featureGate" = false;

      /**
        NEW TAB PAGE *
      */
      "browser.newtabpage.activity-stream.default.sites" = "";
      "browser.newtabpage.activity-stream.showSponsoredTopSites" = false;
      "browser.newtabpage.activity-stream.feeds.section.topstories" = false;
      "browser.newtabpage.activity-stream.showSponsored" = false;
      "browser.newtabpage.activity-stream.showSponsoredCheckboxes" = false;

      /**
        DOWNLOADS *
      */
      "browser.download.manager.addToRecentDocs" = false;

      /**
        PDF *
      */
      "browser.download.open_pdf_attachments_inline" = true;

      /**
        TAB BEHAVIOR *
      */
      "browser.bookmarks.openInTabClosesMenu" = false;
      "browser.menu.showViewImageInfo" = true;
      "findbar.highlightAll" = true;
      "layout.word_select.eat_space_to_next_word" = false;
    };
  };
}
