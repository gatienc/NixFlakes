{
  pkgs,
  lib,
  config,
  ...
}:

{
  services.miniflux = {
    enable = true;
    config = {
      LISTEN_ADDR = "127.0.0.1:8080";
      POLLING_FREQUENCY = "15";
      BATCH_SIZE = "20";
      POLLING_PARSING_ERROR_LIMIT = "0";
      CREATE_ADMIN = false;
      RUN_MIGRATIONS = true;
      DATABASE_URL = "postgres:///miniflux?host=/run/postgresql";
    };
  };

  services.postgresql = {
    enable = true;
    ensureDatabases = [ "miniflux" ];
    ensureUsers = [
      {
        name = "miniflux";
        ensureDBOwnership = true;
      }
    ];
  };

}
