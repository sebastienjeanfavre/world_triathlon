-- 1 Create API integration
CREATE OR REPLACE API INTEGRATION git_api_integration
  API_PROVIDER = git_https_api
  API_ALLOWED_PREFIXES = ('https://github.com/sebastienjeanfavre')
  ALLOWED_AUTHENTICATION_SECRETS = (git_secret_sebastienjeanfavre)
  ENABLED = TRUE;

desc integration git_api_integration;

CREATE OR REPLACE SECRET git_secret_sebastienjeanfavre
    TYPE = PASSWORD
    USERNAME = 'sebastienjeanfavre'
    PASSWORD = '';

-- 2 create git repo obj
CREATE OR REPLACE GIT REPOSITORY git_repo_stage_world_triathlon
  API_INTEGRATION = git_api_integration
  GIT_CREDENTIALS = git_secret_sebastienjeanfavre
  ORIGIN = 'https://github.com/sebastienjeanfavre/world_triathlon.git';

ls @git_repo_stage/branches/main/;