# Securefox — Privacy & Security
# https://github.com/yokoffing/Betterfox
{ config, lib, ... }:
{
  config = lib.mkIf config.smi.programs.zen.enable {
    programs.zen-browser.profiles.default.settings = {

      /**
        TRACKING PROTECTION *
      */
      "browser.contentblocking.category" = "strict";
      "browser.download.start_downloads_in_tmp_dir" = true;
      "browser.uitour.enabled" = false;
      "privacy.globalprivacycontrol.enabled" = true;

      /**
        OCSP & CERTS *
      */
      "security.OCSP.enabled" = 0;
      "privacy.antitracking.isolateContentScriptResources" = true;
      "security.csp.reporting.enabled" = false;

      /**
        SSL / TLS *
      */
      "security.ssl.treat_unsafe_negotiation_as_broken" = true;
      "browser.xul.error_pages.expert_bad_cert" = true;
      "security.tls.enable_0rtt_data" = false;

      /**
        DISK AVOIDANCE *
      */
      "browser.cache.disk.enable" = false;
      "browser.privatebrowsing.forceMediaMemoryCache" = true;
      "media.memory_cache_max_size" = 65536;
      "browser.sessionstore.interval" = 60000;

      /**
        SHUTDOWN & SANITIZING *
      */
      "privacy.history.custom" = true;
      "browser.privatebrowsing.resetPBM.enabled" = true;

      /**
        SPECULATIVE LOADING *
      */
      "network.http.speculative-parallel-limit" = 0;
      "network.dns.disablePrefetch" = true;
      "network.dns.disablePrefetchFromHTTPS" = true;
      "browser.urlbar.speculativeConnect.enabled" = false;
      "browser.places.speculativeConnect.enabled" = false;
      "network.prefetch-next" = false;

      /**
        SEARCH / URL BAR *
      */
      "browser.urlbar.trimHttps" = true;
      "browser.urlbar.untrimOnUserInteraction.featureGate" = true;
      "browser.search.separatePrivateDefault.ui.enabled" = true;
      "browser.search.suggest.enabled" = false;
      "browser.urlbar.quicksuggest.enabled" = false;
      "browser.urlbar.groupLabels.enabled" = false;
      "browser.formfill.enable" = false;
      "network.IDN_show_punycode" = true;

      /**
        HTTPS-ONLY MODE *
      */
      "dom.security.https_only_mode" = true;
      "dom.security.https_only_mode_error_page_user_suggestions" = true;

      /**
        PASSWORDS *
      */
      "signon.formlessCapture.enabled" = false;
      "signon.privateBrowsingCapture.enabled" = false;
      "network.auth.subresource-http-auth-allow" = 1;
      "editor.truncate_user_pastes" = false;

      /**
        EXTENSIONS *
      */
      "extensions.enabledScopes" = 5;

      /**
        HEADERS / REFERERS *
      */
      "network.http.referer.XOriginTrimmingPolicy" = 2;

      /**
        CONTAINERS *
      */
      "privacy.userContext.ui.enabled" = true;

      /**
        VARIOUS *
      */
      "pdfjs.enableScripting" = false;

      /**
        SAFE BROWSING *
      */
      "browser.safebrowsing.downloads.remote.enabled" = false;

      /**
        MOZILLA *
      */
      "permissions.default.desktop-notification" = 2;
      "permissions.default.geo" = 2;
      "geo.provider.network.url" = "https://beacondb.net/v1/geolocate";
      "browser.search.update" = false;
      "permissions.manager.defaultsUrl" = "";
      "extensions.getAddons.cache.enabled" = false;

      /**
        TELEMETRY *
      */
      "datareporting.policy.dataSubmissionEnabled" = false;
      "datareporting.healthreport.uploadEnabled" = false;
      "toolkit.telemetry.unified" = false;
      "toolkit.telemetry.enabled" = false;
      "toolkit.telemetry.server" = "data:,";
      "toolkit.telemetry.archive.enabled" = false;
      "toolkit.telemetry.newProfilePing.enabled" = false;
      "toolkit.telemetry.shutdownPingSender.enabled" = false;
      "toolkit.telemetry.updatePing.enabled" = false;
      "toolkit.telemetry.bhrPing.enabled" = false;
      "toolkit.telemetry.firstShutdownPing.enabled" = false;
      "toolkit.telemetry.coverage.opt-out" = true;
      "toolkit.coverage.opt-out" = true;
      "toolkit.coverage.endpoint.base" = "";
      "browser.newtabpage.activity-stream.feeds.telemetry" = false;
      "browser.newtabpage.activity-stream.telemetry" = false;
      "datareporting.usage.uploadEnabled" = false;

      /**
        EXPERIMENTS *
      */
      "app.shield.optoutstudies.enabled" = false;
      "app.normandy.enabled" = false;
      "app.normandy.api_url" = "";

      /**
        CRASH REPORTS *
      */
      "breakpad.reportURL" = "";
      "browser.tabs.crashReporting.sendReport" = false;
    };
  };
}
